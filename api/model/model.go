package model

import (
	"database/sql"
	"log"
)

type Model struct {
	*sql.DB
	*log.Logger
}
