## UseStates

#### Updates textfield based on Id

```JSX
const [options, setOptions] = useState<string[]>(props.question.options);

  const onChangeQueryOption = (value: string, option: string) => {
    let findOptionByID = options.find(item => item === option);
    if (findOptionByID) {
      findOptionByID = value;
      setOptions([...options])
    }
  }
```

#### Updates textfield based on string only

```JSX
const [options, setOptions] = useState<string[]>("");

const findIndexByValue = (value: string) => options.indexOf(value);

const onChangeQueryOption = (newValue: string, option: string) => {
    let index = findIndexByValue(option);
    options[index] = newValue;
    setOptions([...options]);
};
```

#### Updates textfield based on interface object

```JSX
interface OptionValues {
  id: number
  value: string
}

  const [options, setOptions] = useState<OptionValues[]>([]);

  useEffect(() => {
    const tmpOptions: OptionValues[] = [];
    props.question.options.forEach((value, i) => tmpOptions.push({id: i, value: value}))
    setOptions(tmpOptions)
  }, [props.question])

  const onChangeQueryOption = (value: string, option: OptionValues) => {
    let findOptionByID = options.find(item => item.id === option.id)
    if (findOptionByID) {
      findOptionByID.value = value;
      setOptions([...options])
    }
  }
```

#### Push to useState

```JSX
setItems(prevState => [...prevState, newArr])
```

#### Remove an item from useState

```JSX
setItems(prevState => prevState.filter(item => item.id !== itemToRemove.id))
```

#### Push and remove array based on checkbox toggle

```JSX
  const handleCheckboxClick = (assignment: Assignment) => {
    const newArr = new Assignment(assignment.id, assignment.assignmentName, assignment.courseName, assignment.assignmentName, assignment.assignmentType)
    const ifAssignmentExistRemove = duplicateAssignments.find(value => value.id === assignment.id);
    if (ifAssignmentExistRemove) {
      return setDuplicateAssignments(prevState => prevState.filter(item => item.id !== assignment.id))
    }
    return setDuplicateAssignments(prevState => [...prevState, newArr])
  }
```

#### How to use the MUI Autocomplete

```JSX
  const handleTagSelection = (event: any, values: [], reason: string, detail: AutocompleteChangeDetails<> | undefined) => {
    if (reason === "selectOption" && detail) {
      const addDTORequestBody = new DTORequestBody(detail.option.id, props.selected.id);
      fetchAddMutation.mutate(DTORequestBody);
      set(values);
    }
    if (reason === "removeOption" && detail) {
      const removeDTORequestBody = new DTORequestBody(detail.option.id, props.selected.id);
      fetchRemoveMutation.mutate(removeDTORequestBody);
      set(values);
    }
  };
       <Autocomplete
              multiple
              id=""
              sx={{
                '.MuiAutocomplete-popupIndicator': {
                  color: 'gray',
                  background: 'none'
                },
                '.MuiAutocomplete-clearIndicator': {
                  color: 'gray',
                  background: 'none'
                },
              }}
              options={all}
              getOptionLabel={(option) => option.name}
              disableClearable
              filterSelectedOptions
              onChange={(event, values, reason, details) => handleSelection(event, values, reason, details)}
              value={selected}
              renderInput={params => (<TextField{...params}/>)}
            />
```

#### Render PDF

```JSX
import React, {useState} from 'react';
import {Document, Page, pdfjs} from 'react-pdf';
import {CircularProgress, Grid} from "@mui/material";

pdfjs.GlobalWorkerOptions.workerSrc = `//unpkg.com/pdfjs-dist@${pdfjs.version}/build/pdf.worker.min.js`;

function MyComponent() {
  const [pageNumber, setPageNumber] = useState(1);

  const onDocumentLoadSuccess = ({numPages}: { numPages: number }) => {
    setPageNumber(numPages);
  };

  return (
    <Grid container justifyContent={"center"} style={{border: "solid"}}>
      <Document file={'https://s3.eu-central-1...'}
                onLoadSuccess={onDocumentLoadSuccess}  loading={<CircularProgress color="success" />}>
        {Array.from(new Array(pageNumber ?? 0), (_, index) => (
          <Page key={`page_${index + 1}`} pageNumber={index + 1} loading={<CircularProgress color="success" />}/>
        ))}
      </Document>
    </Grid>
  );
}

export default MyComponent;

```

## NextJS

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


## Fetch

#### Download file
*Works if not blocked by cors*

```JSX
fetch(url)
  .then(response => response.blob())
  .then(blob => {
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'image.jpg';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  });
```
