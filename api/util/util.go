package util

import "log"

func Must(value interface{}, err error) interface{} {
	if err != nil {
		log.Fatalln(err)
	}
	return value
}
