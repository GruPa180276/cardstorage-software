package main

import (
	"fmt"
	"math/rand"
	"time"
)

func RandomIntExclude(min, max int, blacklist []int) int {
	blacklistMap := make(map[int]bool)
	for _, v := range blacklist {
		blacklistMap[v] = true
	}
	for {
		n := min + rand.Intn(max+1)
		if blacklistMap[n] {
			continue
		}
		return n
	}
}

func init() {
	rand.Seed(time.Now().Unix())
}

func main() {
	fmt.Println(RandomIntExclude(0, 10, []int{3, 7, 9}))
}
