package main

import "os"

func main() {
	println(os.Getenv("A"))
	println(os.Getenv("B"))
	println(os.Getenv("C"))
}
