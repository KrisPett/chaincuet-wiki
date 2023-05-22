### Using react-markdown with table of content

```jsx
type Props = {
  category: string
  filename: string
}

const fetchDocs = (token: string | undefined, category: string, filename: string): Promise<string> => {
  if (!token) throw "NO TOKEN"
  return fetch(`${process.env.REACT_APP_SERVER_BASE_URL}/texts/docs/${category}/${filename}`, {
    method: 'GET',
    headers: {'Authorization': 'Bearer ' + token, 'Content-Type': 'text/markdown'}
  }).then(res => {
    if (!res.ok) return Promise.reject(res)
    return res.text()
  }).catch(err => {
    console.log(err)
    throw new Error(err)
  })
}

interface Heading {
  level: number;
  id: string;
  title: string;
}

export default function PubText({category, filename}: Props) {
  const location = useLocation();
  const {keycloak} = useKeycloak();
  const token = keycloak && keycloak.token;
  const [tableOfContent, setTableOfContent] = useState<Heading[]>([]);
  const [activeId, setActiveId] = useState<string>("");

  const {data, isLoading, isRefetching} = useQuery(["FETCH_DOCS", category, filename], () =>
    fetchDocs(token, category, filename));

  const handleScroll = () => {
    const scrollPosition = window.scrollY;
    let newActiveId = "";

    tableOfContent.forEach(({id}) => {
      const element = document.getElementById(id);
      const elementTopOffset = element?.offsetTop ?? 0;
      const elementIsVisible = elementTopOffset - 100 <= scrollPosition;

      if (element && elementIsVisible) {
        newActiveId = id;
      }
    });

    if (newActiveId !== activeId) {
      setActiveId(newActiveId);
    }
  };

  useEffect(() => {
    setTableOfContent([])
  }, [location.pathname])

  useEffect(() => {
    window.addEventListener("scroll", handleScroll);
    return () => {
      window.removeEventListener("scroll", handleScroll);
    };
  }, [activeId, tableOfContent]);

  if (!data) return <><CircularProgress/></>
  if (isLoading || isRefetching) return <><CircularProgress/></>

  const addToTOC = ({children, ...props}: React.PropsWithChildren<HeadingProps>) => {
    const level = Number(props.node.tagName.match(/h(\d)/)?.slice(1));
    if (level && children && typeof children[0] === "string") {
      const id = children[0].toLowerCase().replace(/[^a-z0-9]+/g, "-");
      if (!tableOfContent.some(entry => entry.id === id)) {
        tableOfContent.push({level, id, title: children[0]});
      }
      return createElement(props.node.tagName, {id}, children)
    } else {
      return createElement(props.node.tagName, props, children);
    }
  };

  const onClickScrollToContentView = (e: React.MouseEvent<HTMLAnchorElement>, id: string) => {
    e.preventDefault();
    const element = document.getElementById(id);
    const offset = 80;
    const bodyRect = document.body.getBoundingClientRect().top;
    const elementRect = element?.getBoundingClientRect().top;
    const elementPosition = elementRect! - bodyRect;
    const offsetPosition = elementPosition - offset;

    window.scrollTo({
      top: offsetPosition,
      behavior: "smooth",
    });
  };

  const TableOfContent = () => {
    return (
      <div>
        <Typography variant={"h6"} fontWeight={"bold"} sx={{color: "#4b4b4b"}}>Table of Content</Typography>
        {tableOfContent.map(({level, id, title}) => (
          <div key={id} className={`toc-entry-level-${level}`} style={{listStyleType: "none", padding: 3}}>
            <a href={`#${id}`} onClick={e => onClickScrollToContentView(e, id)}
               style={{
                 textDecoration: "none",
                 color: activeId === id ? "#A040A0" : "#4b4b4b",
                 fontWeight: activeId === id ? "bold" : "normal"
               }}>{title}</a>
          </div>
        ))}
      </div>
    )
  }

  return (
    <Grid container border={"border"} direction={"row"}>
      <Grid item xs={9}>
        <ReactMarkdown
          components={{
            h1: addToTOC,
            h2: addToTOC,
            code: ({node, inline, className, children, ...props}) => {
              const newProps = {
                className: `highlight ${className}`,
                ...props,
              };
              return (
                <div>
                  <SyntaxHighlighter
                    children={String(children).replace(/\n$/, '')}
                    // @ts-ignore
                    style={routeros}
                    PreTag="div"
                    {...newProps}
                  />
                </div>
              );
            },
          }}
          children={data}
          remarkPlugins={[remarkGfm]}
          rehypePlugins={[rehypeRaw]}
          skipHtml={false}
          includeElementIndex={false}
        />
      </Grid>
      <Grid item xs={3} position={"fixed"} right={40} sx={{width: 300}}>
        <TableOfContent/>
      </Grid>
    </Grid>
  )
}
```

## Prevent copy paste

```jsx
const handleMouseUp = () => {
  if (window.getSelection) {
    const selection = window.getSelection();
    if (selection) selection.removeAllRanges();
  } else if (document.getSelection) {
    const selection = document.getSelection();
    if (selection) selection.removeAllRanges();
  }
}
<Grid item
      onCopy={e => e.preventDefault()}
      onMouseDown={e => e.preventDefault()}
      onMouseUp={handleMouseUp}
>
  <Typography variant={"body1"}>Text cant be copied</Typography>
</Grid>
```
