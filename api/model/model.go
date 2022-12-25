package model

import (
	"database/sql"
	"log"
)

type Model struct {
	*sql.DB
	*log.Logger
}

type Operations[T any] interface {
	Select() (T, error)
	SelectAll() ([]T, error)
	Insert() error
	Update() error
	Delete() error
}
