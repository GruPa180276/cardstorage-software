package model

type Storage struct {
	StorageID uint   `json:"-"        gorm:"primaryKey"`
	Name      string `json:"name"     gorm:"not null;unique;type:varchar(32);column:name"`
	Location  string `json:"location" gorm:"not null;type:varchar(32)"`
	Address   string `json:"address"  gorm:"not null;unique;type:varchar(32)"`
	Capacity  uint   `json:"capacity" gorm:"not null;default:10"`
	Cards     []Card `json:"cards"    gorm:"many2many:storage_cards;constraint:OnDelete:CASCADE;"`
	//DeletedAt gorm.DeletedAt `json:"-"        gorm:"index"`
}
