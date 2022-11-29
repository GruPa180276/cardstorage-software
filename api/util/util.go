package util

import (
	"fmt"
	"log"
	"os"
)

func Must(value interface{}, err error) interface{} {
	if err != nil {
		log.New(os.Stderr, "Fatal: util.Must (intermediary): ", log.LstdFlags|log.Lshortfile).Fatalln(err)
	}
	return value
}

func Keys[K comparable, V any](m map[K]V) []K {
	keys := make([]K, 0)

	for k, _ := range m {
		keys = append(keys, k)
	}

	return keys
}

func ContainsValue[K comparable, V comparable](m map[K]V, value V) bool {
	if m == nil {
		return false
	}
	for _, v := range m {
		if v == value {
			return true
		}
	}
	return false
}

func ContainsKey[K comparable, V any](m map[K]V, key K) bool {
	if m == nil {
		return false
	}
	for k, _ := range m {
		if k == key {
			return true
		}
	}
	return false
}

var ErrNotImplemented error = fmt.Errorf("error: not (yet) implemented")
