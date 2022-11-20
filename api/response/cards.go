package response

import (
	"database/sql"
	"encoding/json"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/model"
	"log"
	"net/http"
)

type Card struct {
	*sql.DB
	*log.Logger
}

func (self *Card) GetAllCardsHandler(res http.ResponseWriter, req *http.Request) {
	card := model.Card{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	cards, err := card.SelectAll()
	if err != nil {
		self.Println(err)
		return
	}

	if err := json.NewEncoder(res).Encode(cards); err != nil {
		self.Println(err)
		return
	}
}

func (self *Card) AddNewCardHandler(res http.ResponseWriter, req *http.Request) {
	card := model.Card{Model: &model.Model{DB: self.DB, Logger: self.Logger}}

	if err := json.NewDecoder(req.Body).Decode(&card); err != nil {
		self.Println(err)
		return
	}

	if card.Name == model.CardNameUnset ||
		card.StorageId == model.StorageUnitIdUnset ||
		card.Position == model.CardPositionUnset {
		return
	}

	// check if given storageid foreign key exists
	storage := model.StorageUnit{Model: card.Model}
	storage.Id = card.StorageId
	if err := storage.SelectById(); err != nil {
		if err == sql.ErrNoRows {
			// invalid storage id
			self.Printf("error: trying to add new card with non-existent storage '%s'\n", (&storage).String())
			return
		}
	}

	cardCopy := model.CopyCard(&card)
	err := cardCopy.SelectByName()

	if err != nil && err != sql.ErrNoRows {
		self.Println(err)
		return
	}

	// insert only if there is no card with the same id yet
	if err == sql.ErrNoRows {
		if err := card.Insert(); err != nil {
			self.Println(err)
			return
		}
		self.Println("successfully inserted " + (&card).String())
	}
}
