package util

import "log"

func Must(value interface{}, err error) interface{} {
	if err != nil {
		log.Fatalln(err)
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
