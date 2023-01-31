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
#### Example http://localhost:3000/about/1/2/3/4/dwad?name=testName
```
about -> folder -> index.tsx -> [id].tsx -> [...ids].tsx

const router = useRouter()
const slug = (router.query.ids as string[]) || []
const name = (router.query.name as string)
```