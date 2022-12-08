package main

import (
	"fmt"
)

type ComparableNumber interface {
	comparable
	uint8 | uint16 | uint32 | uint64 | int8 | int16 | int32 | int64 | int | float32 | float64
}

type NumericStack[T ComparableNumber] []T

func (self *NumericStack[T]) Push(t T) {
	*self = append(*self, t)
}

func (self *NumericStack[T]) Pop() T {
	t := (*self)[len(*self)-1]
	*self = (*self)[:len(*self)-1]
	return t
}

func (self NumericStack[T]) IsEmpty() bool {
	return len(self) == 0
}

func main() {
	var s NumericStack[int] = []int{1, 2, 3}

	(&s).Push(4)
	(&s).Push(5)

	for !s.IsEmpty() {
		fmt.Println((&s).Pop())
	}
}
