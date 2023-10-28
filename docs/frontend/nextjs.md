- SEO (Search Engine Optimization)
- Client-Side Rendering (CSR) - **default in Nextjs 13**
- Server-Side Rendering (SSR) - dynamic content
- Static Site Generation (SSG)
- Incremental Static Regeneration (ISR) - dynamic content
- client "use client"
- server "use server" - **default in Nextjs 13**
- cache

## Summary

Client-Side Rendering **(CSR)** for interactive experiences, Server-Side Rendering **(SSR)** for fast initial page loads
and
SEO, Static Site Generation **(SSG)** for content-rich websites, or Incremental Static Regeneration **(ISR)** for
dynamic
content,

## SEO (Search Engine Optimization)

Adding proper metadata, including descriptive and relevant information in HTML such as title tags, meta descriptions,
and structured data, is indeed an important part of SEO.

```
export const metadata: Metadata = {
  title: "",
  description: ""
}
```

## Client-Side Rendering (CSR)

Client-Side Rendering (CSR) is the **default** rendering strategy in React applications. In CSR, the initial request
loads a minimal HTML file that includes JavaScript files responsible for rendering the application. The client’s browser
then executes the JavaScript, fetching data from APIs and rendering the page on the client-side. This approach provides
a smooth and interactive user experience, **but may result in slower initial load times**, especially for content-heavy
pages.

## Server-Side Rendering (SSR)

Server-Side Rendering (SSR) involves rendering the React components on the server and sending the fully rendered HTML to
the client. This approach **improves initial page load times** and ensures that search engines can index the content
effectively. SSR is particularly beneficial for applications with dynamic data that changes frequently or requires
personalized information.

**Activate SSR using getServerSideProps()**

## Static Site Generation (SSG)

Static Site Generation (SSG) involves pre-rendering the entire website at **build time**, generating static HTML files
for
each page. This approach provides **excellent performance and security while reducing the server load**. SSG is ideal
for
websites with content that doesn't change frequently, such as blogs, marketing pages, or documentation.

**Activate SSG using getStaticProps()**

## Incremental Static Regeneration (ISR)

Incremental Static Regeneration (ISR) **builds upon Static Site Generation (SSG)** by allowing dynamic parts of a page
to be regenerated on-demand. This means that some parts of the page can be static while others can be re-rendered when
the data changes. ISR **strikes a balance between performance and freshness of content**, making it suitable for
applications with frequently updated content.

**Activate ISR using getStaticProps() and revalidate option**, Setting ```revalidate: 60``` the page will be regenerated
every 60 seconds, ensuring that the content stays up-to-date without sacrificing performance.

## client "use client"

The client refers to the browser on a user's device that sends a request to a server for your application code. It then
turns the response from the server into a user interface.

## server "use server"

The server refers to the computer in a data center that stores your application code, receives requests from a client,
and sends back an appropriate response.

## cache

Each fetch is cached on default

```
// Opt out of caching for an individual `fetch` request
fetch(`https://...`, { cache: 'no-store' })
```

## Next Pages Router

#### Normal Route

```
about -> folder -> index.tsx
```

#### Dynamic Route

```
about -> folder -> index.tsx -> [id].tsx

const { id } = router.query
```

#### Slug Route

**Example http://localhost:3000/about/1/2/3/4/dwad?name=testName**

```
about -> folder -> index.tsx -> [id].tsx -> [...ids].tsx

const router = useRouter()
const slug = (router.query.ids as string[]) || []
const name = (router.query.name as string)
```

#### Environment Variables

```
Environment variables are prefixed with NEXT_PUBLIC_ and can be accessed from the client side but environment variables without the prefix are only accessible on the server side.
Server side is pages/api and client side is pages
```

#### Token from api

```jsx
import {decode} from "jsonwebtoken";

const handler = async (req: NextApiRequest, res: NextApiResponse) => {
    const access_token = req.headers.authorization
    const token = access_token?.replace('Bearer ', '')
    const sub = decode(token)?.sub
}
export default handler;
```
