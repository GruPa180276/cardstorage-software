// mock hardware library

package hardware

import (
	"log"
	"math/rand"
	"time"
)

func init() {
	rand.Seed(time.Now().Unix())
}

// @todo add user input for testing
func GetCard(position int) error {
	log.Printf("...getting card from position #%d\n", position)
	return nil
}

// @todo add user input for testing
func StoreCard(position int) error {
	log.Printf("...storing card at position #%d\n", position)
	return nil
}

// @todo add user input for testing
func Scan() ([]byte, error) {
	token := make([]byte, 8)
	rand.Read(token)
	return token, nil
}
