#### Setup Keycloak using nextjs / next-auth

##### Create [...nextauth].tsx

```
const keycloak = KeycloakProvider({
  clientId: process.env.KEYCLOAK_ID,
  clientSecret: process.env.KEYCLOAK_SECRET,
  issuer:  process.env.KEYCLOAK_ISSUER,
});

export default NextAuth({
  providers: [keycloak],
  secret: process.env.NEXTAUTH_SECRET,
  callbacks: {
    async jwt({token, account}) {
      if (account) {
        token.accessToken = account.access_token
        token.idToken = account.id_token
      }
      return token;
    },
    async session({session, token}: { session: Session; token: JWT }) {
      session.accessToken = token.accessToken
      session.idToken = token.idToken
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
    NEXTAUTH_URL:string
    NEXTAUTH_SECRET:string
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
```
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