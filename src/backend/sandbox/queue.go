package main

import (
	"fmt"
)

type Queue[T any] struct {
	cap int
	len int
	q   chan T
}

func NewQueue[T any](cap int) *Queue[T] {
	return &Queue[T]{cap, 0, make(chan T, cap)}
}

func (self *Queue[T]) Enqueue(t T) {
	if self.len+1 >= self.cap-1 {
		return
	}
	self.len++
	self.q <- t
}

func (self *Queue[T]) Dequeue() T {
	self.len--
	return <-self.q
}

func (self Queue[T]) IsEmpty() bool {
	return self.len == 0
}

func (self *Queue[T]) Done() {
	close(self.q)
}

func main() {
	var q *Queue[string] = NewQueue[string](10)

	q.Enqueue("hello")
	q.Enqueue("whatsup?")
	q.Enqueue("not much...")
	q.Enqueue("o.k")
	q.Enqueue("bye")

	for !(*q).IsEmpty() {
		fmt.Println(q.Dequeue())
	}

	q.Done()
}
