package main

func Must(v any, err error) any {
	if err != nil {
		panic(err)
	}
	return v
}
