package model

import "database/sql"

type Card struct {
	Id           int
	Fk_storageid int
	Cardname     string
}

func NewCard(cardname string) *Card {
	return &Card{Id: UNSET_FIELD, Fk_storageid: UNSET_FIELD, Cardname: cardname}
}

func (self *Card) Insert(db *sql.DB) (sql.Result, error) {
	if self == nil {
		return nil, NullReferenceError
	}
	if self.Id != UNSET_FIELD && self.Fk_storageid != UNSET_FIELD {
		return db.Exec(`INSERT INTO Cards (id, fk_storageid, cardname) VALUES (?,?,?)`, self.Id, self.Fk_storageid, self.Cardname)
	}
	return db.Exec(`INSERT INTO Cards (cardname) VALUES (?)`, self.Cardname)
}

func (self *Card) Update(db *sql.DB, c *Card) (sql.Result, error) {
	if self == nil || c == nil {
		return nil, NullReferenceError
	}
	return db.Exec(`UPDATE Cards SET cardname = ? WHERE id = ? AND fk_storageid = ?`, c.Cardname, self.Id, self.Fk_storageid)
}

func (self *Card) SelectAll(db *sql.DB) ([]Card, error) {
	rows, err := db.Query(`SELECT id, fk_storageid, cardname FROM Cards`)
	if err != nil {
		return nil, err
	}
	cards := make([]Card, 0)
	for rows.Next() {
		c := Card{}
		if err := rows.Scan(&c.Id, &c.Fk_storageid, &c.Cardname); err != nil {
			return nil, err
		}
		cards = append(cards, c)
	}
	return cards, nil
}

func (self *Card) Delete(db *sql.DB) (*sql.Result, error) {

}
