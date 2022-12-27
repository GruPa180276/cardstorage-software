package main

import (
	"encoding/json"
	"fmt"
)

func main() {
	type creator struct {
		Name      string `json:"name"`
		Storage   string `json:"storage"`
		Accessed  *uint  `json:"accessed"`
		Available *bool  `json:"available"`
	}
	c := creator{}
	if err := json.Unmarshal([]byte(`{"name": "a", "storage": "b", "available": false}`), &c); err != nil {
		panic(err)
	}
	if c.Available != nil {
		fmt.Println(*c.Available)
	}
	if c.Accessed != nil {
		fmt.Println(*c.Accessed)
	}
	fmt.Printf("%+v\n", c)
}
