type test = { field: boolean }
type field = keyof<test, "field">

