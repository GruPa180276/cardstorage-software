package main

import (
	"log"

	"github.com/joho/godotenv"
)

func main() {
	values, err := godotenv.Read("dot.env");
	if err != nil {
		log.Fatalln(err)
	}
	log.Println(values)
}
