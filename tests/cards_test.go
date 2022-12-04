package tests

import (
	"bytes"
	"encoding/json"
	"fmt"
	"math/rand"
	"mime"
	"net/http"
	"os"
	"testing"
	"time"
)

func TestMain(m *testing.M) {
	rand.Seed(time.Now().Unix())
	os.Exit(m.Run())
}

func TestAddNewCardToExistingStorageUnit(t *testing.T) {
	id := rand.Intn(100)
	card, _ := json.Marshal(struct {
		StorageId  int    `json:"storageid"`
		Name       string `json:"name"`
		Position   int    `json:"position"`
		ReaderData string `json:"readerdata"`
	}{
		StorageId:  1,
		Name:       fmt.Sprintf("card-%d", id),
		Position:   id,
		ReaderData: "hello-not-null!",
	})
	must(nil, must(http.Post(API_CARDS, mime.TypeByExtension(".json"), bytes.NewBuffer(card))).(*http.Response).Body.Close())

	_ = must(http.Get(API_CARDS + fmt.Sprintf("/name/card-%d", id))).(*http.Response)

	// json.Unmarshal(r.Body
}
