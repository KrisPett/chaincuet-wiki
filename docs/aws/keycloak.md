#### Keycloak Notes

 - Keycloak stop support of adapters https://www.keycloak.org/2022/02/adapter-deprecation
 - Best Alternative is https://github.com/panva/node-openid-client, if not using next-auth


##### Public vs confidential client

 - Public client: Using redirect_uri to authenticate client to server after user login
 - Confidential client: Using client_secret to authenticate client to server, used for backend servers that cannot use user-interaction flow

#### Docker-compose

##### Using postgres

```
# docker stop postgres_kc_03_25_23 keycloak_03_25_23 && docker rm postgres_kc_03_25_23 keycloak_03_25_23 && docker volume rm postgres_data_03_25_23
# docker exec -it postgres_kc_03_25_23 psql -U keycloak_user -d keycloak_DB
# docker exec -it postgres_kc_03_25_23 psql -U postgres

# export POSTGRES_PASSWORD=postgres_password
# docker-compose -f docker-compose-kc.yml up
# docker-compose -f docker-compose-kc.yml down && docker volume rm postgres_data_03_25_23

version: "3.8"
services:
  postgres_kc_03_25_23:
    container_name: postgres_kc_03_25_23
    image: postgres:10.4
    restart: always
    volumes:
      - postgres_data_03_25_23:/var/lib/postgresql/data
    environment:
      POSTGRES_DB: keycloak_DB
      POSTGRES_USER: keycloak_user
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    ports:
      - "5433:5432"
    networks:
      - chaincue-tech-net

  keycloak_03_25_23:
    container_name: keycloak_03_25_23
    image: quay.io/keycloak/keycloak:19.0.3-legacy
    restart: always
    environment:
      DB_VENDOR: POSTGRES
      DB_ADDR: postgres_kc_03_25_23
      DB_DATABASE: keycloak_DB
      DB_USER: keycloak_user
      DB_SCHEMA: public
      DB_PASSWORD: ${POSTGRES_PASSWORD}
      KEYCLOAK_USER: admin
      KEYCLOAK_PASSWORD: admin
      PROXY_ADDRESS_FORWARDING: "true"
    ports:
      - "8080:8080"
      - "8443:8443"
    depends_on:
      - postgres_kc_03_25_23
    networks:
      - chaincue-tech-net

volumes:
  postgres_data_03_25_23:
    name: postgres_data_03_25_23

networks:
  chaincue-tech-net:
    name: chaincue-tech-net
    driver: bridge

```

#### Setup Keycloak using nextjs / next-auth

##### Create [...nextauth].tsx

```
interface DecodedToken {
  sub: string;
  exp: number;
}

export function decodeJwt(token: string): DecodedToken | null {
  try {
    return jwt.decode(token) as DecodedToken;
  } catch (err) {
    console.error('Error decoding JWT:', err);
    return null;
  }
}

const keycloak = KeycloakProvider({
  clientId: process.env.KEYCLOAK_ID,
  clientSecret: process.env.KEYCLOAK_SECRET,
  issuer: process.env.KEYCLOAK_ISSUER,
});

const refreshAccessToken = async (token: JWT): Promise<JWT> => {
  const myHeaders = new Headers();
  myHeaders.append("Content-Type", "application/x-www-form-urlencoded");

  const urlencoded = new URLSearchParams();
  if (token.refresh_token) {
    urlencoded.append("grant_type", "refresh_token");
    urlencoded.append("client_id", process.env.KEYCLOAK_ID);
    urlencoded.append("refresh_token", token.refresh_token);
    urlencoded.append("client_secret", process.env.KEYCLOAK_SECRET);
  }

  return fetch(`${process.env.KEYCLOAK_ISSUER}/protocol/openid-connect/token`, {
    method: 'POST',
    headers: myHeaders,
    body: urlencoded
  })
    .then(response => {
      if (!response.ok) return Promise.reject(new Error('Failed to refresh access token'))
      return response.json()
    })
    .then(result => {
      const decodeToken = decodeJwt(result.access_token);
      if (decodeToken) {
        token.refresh_token = result.refresh_token;
        token.access_token = result.access_token;
        token.id_token = result.id_token;
        token.expires_at = decodeToken.exp
        return token
      } else {
        return Promise.reject(new Error('Failed to decode access token'))
      }
    })
    .catch(error => {
      console.error(error)
      token.error = "RefreshAccessTokenError"
      return token
    });
}

export default NextAuth({
  providers: [keycloak],
  secret: process.env.NEXTAUTH_SECRET,
  callbacks: {
    jwt: async ({token, account}) => {
      if (token.expires_at) {
        const expiresAt = new Date(token.expires_at * 1000);
        const currentTime = new Date(Date.now());
        if (currentTime.getTime() < expiresAt.getTime()) {
          return token;
        }
      }
      if (account) {
        token.access_token = account.access_token;
        token.refresh_token = account.refresh_token;
        token.id_token = account.id_token;
        token.providerAccountId = account.providerAccountId;
        token.scope = account.scope;
        token.session_state = account.session_state;
        token.token_type = account.token_type;
        token.type = account.type;
        token.userId = account.userId;
        token.expires_at = account.expires_at;
      }
      return refreshAccessToken(token)
    },
    session: async ({session, token}: { session: Session; token: JWT }) => {
      session.access_token = token.access_token
      session.refresh_token = token.refresh_token
      session.id_token = token.id_token
      session.providerAccountId = token.providerAccountId
      session.scope = token.scope
      session.session_state = token.session_state
      session.token_type = token.token_type
      session.type = token.type
      session.userId = token.userId
      session.expires_at = token.expires_at
      session.error = token.error
      return session
    },
  },
});
```

##### Secret needs to be set for production
```
openssl rand -base64 32
secret: process.env.NEXTAUTH_SECRET
```

##### Create types/environment.d.ts].tsx && next-auth.d.ts

```
declare namespace NodeJS {
  interface ProcessEnv {
    NEXT_PUBLIC_CLIENT_URL: string
    NEXTAUTH_URL: string
    NEXTAUTH_SECRET: string
    KEYCLOAK_ID: string
    KEYCLOAK_SECRET: string
    KEYCLOAK_ISSUER: string
  }
}


import NextAuth, {DefaultSession} from "next-auth"

declare module "next-auth/jwt" {
  interface JWT {
    accessToken?: string
    idToken?: string
  }
}

declare module "next-auth" {
  interface Session {
    user: {
      address: string
    }
    accessToken?: string
    idToken?: string
  }
}
```

##### Configure logout function might vary based on keycloak versions

```
const handleSignOut = async () => {
    if (data) {
      const post_logout_redirect_uri = process.env.NEXTAUTH_URL;
      const logoutUrl = `https://auth.chaincuet.com/auth/realms/chainbot/protocol/openid-connect/logout?id_token_hint=${data.idToken}&post_logout_redirect_uri=${post_logout_redirect_uri}`;
      signOut().then(() => router.replace(logoutUrl));
    }
};
```

##### Configure Login

```
const {status} = useSession({required: true, onUnauthenticated: () => signIn('keycloak')});
const loading = status === 'loading';
if (loading) return <></>

<SessionProvider session={pageProps.session}>
    <Layout>
        <Component {...pageProps} />
    </Layout>
</SessionProvider>
```

#### Theming Keycloak

##### docker-compose.yml example
```jsx
# docker stop keycloak_name && docker rm keycloak_name && docker stop postgres_name && docker rm postgres_name && docker volume rm postgres_data
# docker-compose up -d

version: '3.5'
services:
  postgres:
    container_name: postgres_name
    image: postgres:10.4
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      POSTGRES_DB: keycloak
      POSTGRES_USER: keycloak
      POSTGRES_PASSWORD: POSTGRES_PASSWORD
    ports:
      - "5433:5432"
    networks:
      - keycloak_net

  keycloak:
    container_name: keycloak_name
    image: quay.io/keycloak/keycloak:19.0.3-legacy
    environment:
      DB_VENDOR: POSTGRES
      DB_ADDR: postgres
      DB_DATABASE: keycloak
      DB_USER: keycloak
      DB_SCHEMA: public
      DB_PASSWORD: POSTGRES_PASSWORD
      KEYCLOAK_USER: admin
      KEYCLOAK_PASSWORD: admin
      PROXY_ADDRESS_FORWARDING: "true"
    ports:
      - "8080:8080"
      - "8443:8443"
    # volumes:
    #    - /keycloak-theme:/opt/jboss/keycloak/themes/keycloak/
    depends_on:
      - postgres
    networks:
      - keycloak_net

volumes:
  postgres_data:
    name: postgres_data

networks:
  keycloak_net:
    name: keycloak_net
    driver: bridge
```

```
docker stop keycloak_name && docker rm keycloak_name && \
docker stop postgres_name && docker rm postgres_name && \
docker volume rm postgres_data \
docker-compose up -d
```

```
http://0.0.0.0:8080/auth/
http://localhost:8080/auth/
```

##### List databases 
```
docker exec -it postgres_name psql -U postgres -c "\l"
```

#### Keycloak Extensions

##### Install an extension 

```
svn export https://github.com/thomasdarimont/keycloak-extension-playground/trunk/auth-identity-first-extension
mvn clean install
docker cp auth-trust-device-0.0.1-SNAPSHOT.jar <container_id>:/opt/jboss/keycloak/standalone/deployments
```

#### Using Java webclient

##### Create new user

```jsx
    private static Mono<String> getAccessTokenFromClientAdminCli() {
        String endpointUrl = "http://localhost:8080/auth/auth/realms/lambda/protocol/openid-connect/token";
        WebClient webClient = WebClient.builder().baseUrl(endpointUrl).build();

        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("username", "manageuser");
        body.add("password", "password");
        body.add("grant_type", "password");
        body.add("client_id", "admin-cli");

        return webClient.post()
                .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE)
                .body(BodyInserters.fromFormData(body))
                .retrieve()
                .bodyToMono(String.class)
                .map(response -> new JSONObject(response).getString("access_token"));
    }

    private static Mono<String> createNewUserUsingAccessToken(String accessToken) {
        String endpointUrl = "http://localhost:8080/auth/admin/realms/lambda/users";
        WebClient webClient = WebClient.builder().baseUrl(endpointUrl).build();

        JSONObject newUser = new JSONObject();
        newUser.put("enabled", true);
        newUser.put("username", "test@gmail.com");
        newUser.put("email", "test@gmail.com");
        newUser.put("firstName", "test@gmail.com");
        newUser.put("lastName", "test@gmail.com");

        JSONArray credentials = new JSONArray();
        JSONObject credential = new JSONObject();
        credential.put("type", "password");
        credential.put("value", "123");
        credential.put("temporary", false);
        credentials.put(credential);
        newUser.put("credentials", credentials);

        return webClient.post()
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken)
                .contentType(MediaType.APPLICATION_JSON)
                .body(BodyInserters.fromValue(newUser.toString()))
                .retrieve()
                .bodyToMono(String.class);
    }
```

##### Delete user

```jsx
    private Mono<String> getUserSubId(String accessToken, String email) {
        String endpointUrl = "http://localhost:8080/auth/admin/realms/lambda/users?email=" + email;
        WebClient webClient = WebClient.builder().baseUrl(endpointUrl).build();
        return webClient.get()
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken)
                .retrieve()
                .bodyToMono(String.class)
                .map(response -> {
                    JSONArray jsonArray = new JSONArray(response);
                    JSONObject jsonObject = jsonArray.getJSONObject(0);
                    return jsonObject.getString("id");
                });
    }

    private Mono<String> deleteUserByUserid(String accessToken, String subId) {
        String endpointUrl = "http://localhost:8080/auth/admin/realms/lambda/users/";
        WebClient webClient = WebClient.builder().baseUrl(endpointUrl).build();
        return webClient.delete()
                .uri(subId)
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken)
                .retrieve()
                .bodyToMono(String.class);
    }
```

#### Keycloak Rest API

##### quay.io/keycloak/keycloak:19.0.3-legacy

*https://www.keycloak.org/docs-api/19.0.3/rest-api/index.html*

*http://localhost:8080/auth/realms/lambda/.well-known/openid-configuration*

**Get userinfo** (POST | GET)

```
curl --location 'http://localhost:8080/auth/realms/lambda/protocol/openid-connect/userinfo' \
--header 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJOMnF3eEFDTC0wVDFPYVJxR3JzTzlsdDFMeVpFejhHWlZMSm5GMkszMDdRIn0.eyJleHAiOjE2NzgxOTQwMDcsImlhdCI6MTY3ODE5MzcwNywiYXV0aF90aW1lIjoxNjc4MTkyMzQ1LCJqdGkiOiJmMDUyNjJmYi1jNjAyLTQxM2UtOWIzNi02MjViZjBiOTRlODYiLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwODAvYXV0aC9yZWFsbXMvbGFtYmRhIiwiYXVkIjpbInJlYWxtLW1hbmFnZW1lbnQiLCJicm9rZXIiLCJhY2NvdW50Il0sInN1YiI6IjhjNmUzNjM1LTVkODUtNGIwNS1hMTFmLTI4YWE0MzEwNmVjOCIsInR5cCI6IkJlYXJlciIsImF6cCI6InN0dWRlbnQtcG9ydGFsLWNsaWVudCIsIm5vbmNlIjoiNGZmOWU2MjItM2JjYi00MTc4LWE4YjktNjY3YTkzMmI1ODA1Iiwic2Vzc2lvbl9zdGF0ZSI6ImFkNzgyNWRmLTQ2MDYtNGZjNi05NjFhLTE4MTE5YjYxYmI4OCIsImFjciI6IjAiLCJhbGxvd2VkLW9yaWdpbnMiOlsiKiJdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiZGVmYXVsdC1yb2xlcy1sYW1iZGEiLCJvZmZsaW5lX2FjY2VzcyIsInVtYV9hdXRob3JpemF0aW9uIiwiYWRtaW4tYWNjZXNzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsicmVhbG0tbWFuYWdlbWVudCI6eyJyb2xlcyI6WyJ2aWV3LWlkZW50aXR5LXByb3ZpZGVycyIsInZpZXctZXZlbnRzIl19LCJicm9rZXIiOnsicm9sZXMiOlsicmVhZC10b2tlbiJdfSwiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsInZpZXctYXBwbGljYXRpb25zIiwidmlldy1jb25zZW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJtYW5hZ2UtY29uc2VudCIsImRlbGV0ZS1hY2NvdW50Iiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJvcGVuaWQgZW1haWwgYWRkcmVzcyBwaG9uZSBtaWNyb3Byb2ZpbGUtand0IG9mZmxpbmVfYWNjZXNzIHByb2ZpbGUiLCJzaWQiOiJhZDc4MjVkZi00NjA2LTRmYzYtOTYxYS0xODExOWI2MWJiODgiLCJ1cG4iOiJ1c2VyQGVtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhZGRyZXNzIjp7fSwibmFtZSI6InVzZXJAZW1haWwuY29tIHVzZXJAZW1haWwuY29tIiwiZ3JvdXBzIjpbImRlZmF1bHQtcm9sZXMtbGFtYmRhIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsImFkbWluLWFjY2VzcyJdLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJ1c2VyQGVtYWlsLmNvbSIsImdpdmVuX25hbWUiOiJ1c2VyQGVtYWlsLmNvbSIsImZhbWlseV9uYW1lIjoidXNlckBlbWFpbC5jb20iLCJlbWFpbCI6InVzZXJAZW1haWwuY29tIn0.jPMpi-xjyJDSOFFcuonkXrhWEsrThtMdw4NAPFjhCMOp_rTEHUpyAVbvR9mer8FCb5-gb-OX39c016_xxnheXjmBMdSXpZ0G4Ad26gMyp3k_fmQu8-d3oJdasu0MtSkytGq4NVSEsSi1Zv5pRSUv_rnAHtoo_9xJYiMqMo0_cwy6QnPpqhc18G5yWyH3m5YbvToIcgvXYnNa5xpyz9v0L9ilVNmB25sx5iPWTRth2j53bUqZMiCSpT1Bui_QRk0xoXXI2v-yBt9q9RfAv4TYcO-VHlOmhf_RoUyq5PF9uQKPqNxXPJy882nqiJaAAdTAXCiQe9Sf5n7duZZZJbgnqQ'
```

**Get Token** (POST)

```
curl --location 'http://localhost:8080/auth/realms/lambda/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=user@email.com' \
--data-urlencode 'password=user@email.com' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=student-portal-client'
--data-urlencode 'otp=262004'
```

**Refresh Token** (POST)

``` 
curl --location 'http://localhost:8080/auth/realms/lambda/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'grant_type=refresh_token' \
--data-urlencode 'client_id=<clientId>' \
--data-urlencode 'refresh_token=eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJhZjQwNjEyZS01NmFmLTQ3N2ItYWIyNy0wNDBkNTA0ZDFhNjYifQ.eyJleHAiOjE2NzczNjU3MzUsImlhdCI6MTY3NzM2MzkzNSwianRpIjoiZGIzYTM0NmItN2YwZC00YmFkLTgyODMtNDJiYTYyNjFkYTc1IiwiaXNzIjoiaHR0cHM6Ly9hdXRoLmNoYWluY3VldC5jb20vYXV0aC9yZWFsbXMvY2hhaW5ib3QiLCJhdWQiOiJodHRwczovL2F1dGguY2hhaW5jdWV0LmNvbS9hdXRoL3JlYWxtcy9jaGFpbmJvdCIsInN1YiI6IjI2N2U5ODU5LTMzNTEtNDE5NC05YWU3LWY3M2E1ZWQ5ZWYxMSIsInR5cCI6IlJlZnJlc2giLCJhenAiOiJjaGF0Ym90LWNsaWVudCIsInNlc3Npb25fc3RhdGUiOiI2NzhkZDAzNS0yZTYxLTQxNWEtOWUyMy04ZTBjYjFkOGJlOTEiLCJzY29wZSI6Im9wZW5pZCBlbWFpbCBwcm9maWxlIiwic2lkIjoiNjc4ZGQwMzUtMmU2MS00MTVhLTllMjMtOGUwY2IxZDhiZTkxIn0.9YhXN4QOALYKzR-cuggZ-BCicUWAd-93pAV85MYlfSc' \
--data-urlencode 'client_secret=<secretId>'
```

**Logout**

```
# Get idToken from the token response
http://localhost:8080/auth/realms/lambda/protocol/openid-connect/logout?id_token_hint=idToken&post_logout_redirect_uri=http://localhost:3000`;
```

**Create a user**

```
# Create a user in Master realm 'createuseradmin'
# Create a realm-role 'create-user' and assign <realm>manage-users role and assign it to the user
# Get admin-cli token from keycloak for the user 'createuser@email.com' (POST)
curl --location 'http://localhost:8080/auth/realms/lambda/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=createuser@email.com' \
--data-urlencode 'password=createuser@email.com' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=admin-cli'

# Create user using admin-cli token (POST)
curl --location 'http://localhost:8080/auth/admin/realms/lambda/users' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJwZmpNdkdTbUtZcGtIRWVBTnBzeXFsdnU2Q2V2bzNId3JYTEo1R2RsMWM4In0.eyJleHAiOjE2NzgzNzA5MzIsImlhdCI6MTY3ODM3MDg3MiwianRpIjoiMjIyMWI4MmEtNzNlNC00MzJjLTk5MzUtYjhjMzE3ZDI1MDVjIiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL2F1dGgvcmVhbG1zL21hc3RlciIsInN1YiI6IjRjYzhlNTFkLTlmNjEtNGJlZC1iODA0LTk0ZWFiYTY2MGI1MiIsInR5cCI6IkJlYXJlciIsImF6cCI6ImFkbWluLWNsaSIsInNlc3Npb25fc3RhdGUiOiI1YmYwMmZhMy00ODVhLTQ5YzItOWU2My1jM2ZlZWNjNTU0MGUiLCJhY3IiOiIxIiwic2NvcGUiOiJlbWFpbCBwcm9maWxlIiwic2lkIjoiNWJmMDJmYTMtNDg1YS00OWMyLTllNjMtYzNmZWVjYzU1NDBlIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInByZWZlcnJlZF91c2VybmFtZSI6ImFkbWluIiwiZ2l2ZW5fbmFtZSI6IiIsImZhbWlseV9uYW1lIjoiIn0.M8K8_5PEc5oYosIrP_JKmF-5u8aLKq_rdGqkgiRdfD-OOCoWVxBy_avgSF4um8ohQ6PbK52IFKFueIPrD-bfQ5e7rLEQ3tUINSAIx1zZv7pxs50DCC_90GXWbPobuoZKziyG33mgY6eGNv2pzdYmkN3VLmft0pmpLA2occILwi1mhte8yLk2OQrczlmSRgq5y4AydS8bWBC2aEqJx9-_DA-Lolit4uc4wMS_0CoDpZL6BlRLOJz4ABqnmIh3DjyL2B42MTCsnKH-__cVZqndeZ5WlmjF9c0in3pfwgdE4R0d6sxh11zOI6flV7NyDMY66cczWOOHX4B7M-XaCK13QQ' \
--data-raw '{
    "enabled": true,
    "username": "test@gmail.com",
    "email": "test@gmail.com",
    "firstName": "test@gmail.com",
    "lastName": "test@gmail.com",
    "groups": [
        "user"
    ],
    "credentials": [
        {
            "type": "password",
            "value": "123",
            "temporary": false
        }
    ]
}'
```

**Get userId by email (GET)**
```
curl --location 'http://localhost:8080/auth/admin/realms/lambda/users?email=email@email.com' \
--header 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmQ3JMUHhXUVJsZVh1NHkwMHVVV2RkVkJtSlZkMDVJSUZVZ3dpM0pwMjVvIn0.eyJleHAiOjE2Nzg3MDQ0MjAsImlhdCI6MTY3ODcwNDEyMCwianRpIjoiODMwY2UwZDAtZjg0YS00NTUxLTljMDctMzc1MmE5M2UyNzczIiwiaXNzIjoiaHR0cHM6Ly9pYW0uc2Vuc2VyYS5zZS9hdXRoL3JlYWxtcy9sYW1iZGEiLCJzdWIiOiIxNzgzOTI4OS1hNDcxLTRjMjItYjc2MC02OGIwM2U2YzYzMzQiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJhZG1pbi1jbGkiLCJzZXNzaW9uX3N0YXRlIjoiY2Q2ZDcwYzgtYzQyYi00N2UzLTgxNDAtNTNmMTQ4YmVmNzAxIiwiYWNyIjoiMSIsInNjb3BlIjoiZW1haWwgcHJvZmlsZSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwibmFtZSI6Ik1hbmFnZSBVc2VyIiwicHJlZmVycmVkX3VzZXJuYW1lIjoibWFuYWdldXNlciIsImdpdmVuX25hbWUiOiJNYW5hZ2UiLCJmYW1pbHlfbmFtZSI6IlVzZXIiLCJlbWFpbCI6Im1hbmFnZXVzZXJAZW1haWwuY29tIn0.DM1U49hbqU1k-_K7e5seqJWvUg6Z6E_RZeoJ05OpmUPBswJ7vkjSXsOuB56eO1x5nvjxWsWNCcxF7A7ArsmfwyrcuiSbS3iWL7YG-U0wEBi_mXgN0OnEKPYhPpT8R64dAfmzSOZrl57Ia8lnoY0YcvxQEUjbqi36lUGuhuaFK5ZqzYQvOH0BAzu5Xg2Dg8QzJEupt6Isr0QNj7O__R-8f1QfSV577jyNCx1q3Z-rAzIhpjIB9DG-4Sxe0HvUCsRNsKRQpNZbHLMfOJ-5xR3R0fx9LthlYw8rkBq863YrxAuUT5wk0V4JWzJur8MnRME8YQ1gvdNKl2gRLsjXZSNhyw'
```

**Delete user by userId (DELETE)**
```
curl --location --request DELETE 'http://localhost:8080/auth/admin/realms/lambda/users/55a0adfc-b5e5-425d-afc2-c37814ba4a15' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmQ3JMUHhXUVJsZVh1NHkwMHVVV2RkVkJtSlZkMDVJSUZVZ3dpM0pwMjVvIn0.eyJleHAiOjE2Nzg3MDQ4MTAsImlhdCI6MTY3ODcwNDUxMCwianRpIjoiMDFmYjEwNTYtYzdjNS00OWRhLWE0Y2UtZWM3YzY3YjE3ZDE5IiwiaXNzIjoiaHR0cHM6Ly9pYW0uc2Vuc2VyYS5zZS9hdXRoL3JlYWxtcy9sYW1iZGEiLCJzdWIiOiIxNzgzOTI4OS1hNDcxLTRjMjItYjc2MC02OGIwM2U2YzYzMzQiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJhZG1pbi1jbGkiLCJzZXNzaW9uX3N0YXRlIjoiYzUzNzE2N2EtNTNiYS00ZTRhLThiNzktYzg5NGYzYTcyZTU0IiwiYWNyIjoiMSIsInNjb3BlIjoiZW1haWwgcHJvZmlsZSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwibmFtZSI6Ik1hbmFnZSBVc2VyIiwicHJlZmVycmVkX3VzZXJuYW1lIjoibWFuYWdldXNlciIsImdpdmVuX25hbWUiOiJNYW5hZ2UiLCJmYW1pbHlfbmFtZSI6IlVzZXIiLCJlbWFpbCI6Im1hbmFnZXVzZXJAZW1haWwuY29tIn0.cklfxHDVKXAaH9f0O1cZLMwP09nrKVvLM_Xo3taTV7-VhRrdWjiJn7ZWaAyFYEh91fQAaNZwnkkO-dnQtKWH41RZqlBAQzXUlJ8rRmf0xPf8vzYeitxLxCYKmNqa3TWPAE0Z873cUHSZ7AFJOy9xGVpLsJBgbItJ1NrlmQEjBlETnh6xTFwOFcLoPGNk4SDfkA16-Ts9Ko6p25TDEnsTsHnVsftC5aVcnZSyrq3JTVXA4Vq5iMN7EuJwlh6XZBOoEAMZVoWYNN_AaEbyuYo2lMxcwxkuDtQFLs_V9Q1j52qHt1za1ZnQpJjkNGtHG7cpePVbLRuFL0AANSdHkwhFeg' \
--data ''
```

**Update user using admin privilegios (PUT)**

```
curl --location --request PUT 'http://localhost:8080/auth/admin/realms/lambda/users/67958fa7-e7a4-43fb-8c60-432169bf1d07' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmQ3JMUHhXUVJsZVh1NHkwMHVVV2RkVkJtSlZkMDVJSUZVZ3dpM0pwMjVvIn0.eyJleHAiOjE2Nzg3MTM4NzgsImlhdCI6MTY3ODcxMzU3OCwianRpIjoiMWIzMmE1M2UtODQyNC00Zjc0LTk1NDgtY2M4ZmVmNWIyMDRjIiwiaXNzIjoiaHR0cHM6Ly9pYW0uc2Vuc2VyYS5zZS9hdXRoL3JlYWxtcy9sYW1iZGEiLCJzdWIiOiIxNzgzOTI4OS1hNDcxLTRjMjItYjc2MC02OGIwM2U2YzYzMzQiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJhZG1pbi1jbGkiLCJzZXNzaW9uX3N0YXRlIjoiOTljOTg5MDEtYzZhNi00Mjg4LTlhMGMtMDkzZGM2MzgxMWI3IiwiYWNyIjoiMSIsInNjb3BlIjoiZW1haWwgcHJvZmlsZSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwibmFtZSI6Ik1hbmFnZSBVc2VyIiwicHJlZmVycmVkX3VzZXJuYW1lIjoibWFuYWdldXNlciIsImdpdmVuX25hbWUiOiJNYW5hZ2UiLCJmYW1pbHlfbmFtZSI6IlVzZXIiLCJlbWFpbCI6Im1hbmFnZXVzZXJAZW1haWwuY29tIn0.jKioR0YuuR3ZkioYTbXwYDTbCLcS1MlVX03pV4WpZnOmzJ1llQdkEqJjr9beLS7LxrgyQfi-DeGIZcWAWcbG5mT-OLUiXNAOvWHlDhbQ7N4TKxIb7DiTolc_Sue3vv6l_SXA6XZsm6StIK3pOSdlwIZJqSIqszA9QB-nRAWVj4MvPLL9yWrX9o-PnZy3NN8Sttt1m9WW_kPTvgI0j-egOzuFZd646EWr0SQ1DrBDS22GsXil3kGWro3MTDqNIwyDu-5ycG8bNyPMPSm4iL4X60SSgkVR5FBz-Y5_ajKQ_jOW5j3tsZsUOV7ATPZ_mQiQXFOlEMOZuiOjn-kuOimZcA' \
--data-raw '{
    "firstName": "newFirstname",
    "lastName": "newLastname",
    "email": "new@email.com",
    "credentials": [
        {
            "type": "password",
            "value": "newPassword"        
        }
    ]
}'
```

**Update user using account endpoint (POST)**
**Use user access token**

```
curl --location 'http://localhost:8080/auth/realms/lambda/account' \
--header 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmQ3JMUHhXUVJsZVh1NHkwMHVVV2RkVkJtSlZkMDVJSUZVZ3dpM0pwMjVvIn0.eyJleHAiOjE2Nzg3MjE2MzcsImlhdCI6MTY3ODcyMTMzNywianRpIjoiY2VlNGM0YjgtZTRhMy00ODI5LTgzNTItZjY2MmRiNjMwZTEzIiwiaXNzIjoiaHR0cHM6Ly9pYW0uc2Vuc2VyYS5zZS9hdXRoL3JlYWxtcy9sYW1iZGEiLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZGI2MTQ2YTItNDBkNy00MmUxLTkyMTctMzJkNTI4MTM1NTIwIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoic3R1ZGVudC1wb3J0YWwtY2xpZW50Iiwic2Vzc2lvbl9zdGF0ZSI6IjNjMmM5YzQ5LTAxYTItNDZiNS05NTQ2LWVkMzk5NTkxY2EwNiIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiKiJdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoiZW1haWwgcHJvZmlsZSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwibmFtZSI6Im5ld0ZpcnN0bmFtZSBsYXN0TmFtZSIsInByZWZlcnJlZF91c2VybmFtZSI6InRlc3RAZ21haWwuY29tIiwiZ2l2ZW5fbmFtZSI6Im5ld0ZpcnN0bmFtZSIsImZhbWlseV9uYW1lIjoibGFzdE5hbWUiLCJlbWFpbCI6InRlc3RAZ21haWwuY29tIn0.PDDTJZjlVfQH0ZNKysHNl-erAZ22bpO_-Q9TZ3gcTxgArQsJw85PKCAgUXn_KY0YjUHXi9yclHXBdcrkUkwFj39D_8fr4OWFTvpONM1B-Sig19thjd9byQfmdADBV3_C3osb1xIr0ClY3xTPRU3oXMVvpZOV13ELJBUUfftUgJMSYO_fpsETCWx-SADGWLbfjEslAbYjKWKsnXnRph8Qu14QNCuve7lKtjLYBv3UDiirOoQB3UeTpjl8NaPxc6cupgCOFc_CEi3XwTI3w6r0mrUgjBY0DBcaPs7HA2axE35v9lR6w6swaxEQFh4D2AjGwiq5eEBg3geVkAA57wfzKw' \
--header 'Content-Type: application/json' \
--data-raw '{
    "firstName": "newFirstname",
    "lastName": "lastName",
    "email": "test@gmail.com"
}'
```

**Get account credentials (GET)**
**Update password depricated using cli**

```
curl --location --request GET 'http://localhost:8080/auth/realms/lambda/account/credentials' \
--header 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmQ3JMUHhXUVJsZVh1NHkwMHVVV2RkVkJtSlZkMDVJSUZVZ3dpM0pwMjVvIn0.eyJleHAiOjE2Nzg4ODUxMTUsImlhdCI6MTY3ODg4NDgxNSwianRpIjoiMzQwY2U3NTEtOTRlNS00YzUwLTljOGItZWJlYzZiODM5M2M2IiwiaXNzIjoiaHR0cHM6Ly9pYW0uc2Vuc2VyYS5zZS9hdXRoL3JlYWxtcy9sYW1iZGEiLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZGI2MTQ2YTItNDBkNy00MmUxLTkyMTctMzJkNTI4MTM1NTIwIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoic3R1ZGVudC1wb3J0YWwtY2xpZW50Iiwic2Vzc2lvbl9zdGF0ZSI6IjIzMWYwOGFmLThlODEtNGRlYy05MWI3LTMzZWVhNDRiZThhYiIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiKiJdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoiZW1haWwgcHJvZmlsZSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYW1lIjoibmV3Rmlyc3RuYW1lIG5ld0xhc3RuYW1lIiwicHJlZmVycmVkX3VzZXJuYW1lIjoidGVzdEBnbWFpbC5jb20iLCJnaXZlbl9uYW1lIjoibmV3Rmlyc3RuYW1lIiwiZmFtaWx5X25hbWUiOiJuZXdMYXN0bmFtZSIsImVtYWlsIjoidGVzdEBnbWFpbC5jb20ifQ.YGY5u2IZASf2tS7AIvG9diHhSd9DC38fhsQUknmKFfVYIC5KZ1igV5F1ccMj3DDF86Sf_v3jaTVmSav_hWpxptjpO3ZVkFKUmQ4xmkCJARjF8PCzBDibEixpyz8L7ON2nAszM8PPZMspG7SXWQydC_vnvW6QdcM1DYQ8EPArEa_RWQ-T1SK7altXqcl0vzYvlKbcPzaKUco-_YgH-ge_3RmpRQ8i-jNGWqqufL11Sr43WwGY-OA9Hrb-FbEH22RD3nrHAVbiKQ50fh_nRoDxIWaRiu2V5j4YBJ-uVD2LRPZqMXSf0VFO6zb4xSgGcLdVOlFTxuG0y5_82aNXm3jzww' \
--header 'Content-Type: application/json' \
--data '{}'
```

**Reset password**

```jsx
const url = "http://localhost:8080/auth/realms/lambda/protocol/openid-connect/auth?client_id=<client_id>&redirect_uri=http://localhost:3000/&response_type=code&scope=openid&kc_action=UPDATE_PASSWORD";
window.location.href = url;
```