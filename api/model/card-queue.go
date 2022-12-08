package model

import (
	"time"
)

type CardQueueEntry struct {
	Id       int           `json:"id,omitempty"`
	Userid   int           `json:"user-id"`
	Since    time.Duration `json:"since"`
	Until    time.Duration `json:"until"`
	Returned bool          `json:"returned"`
	Reserved bool          `json:"reserved"`
}
