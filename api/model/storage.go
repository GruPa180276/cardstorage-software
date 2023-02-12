package model

type Storage struct {
	StorageID uint   `json:"-"        gorm:"primaryKey;column:storage_id"`
	Name      string `json:"name"     gorm:"not null;unique;type:varchar(32);column:name"`
	Location  string `json:"location" gorm:"not null;type:varchar(32)"`
	Address   string `json:"address"  gorm:"not null;type:varchar(32);default:'schule.local'"`
	Capacity  uint   `json:"capacity" gorm:"not null;default:10"`
	Cards     []Card `json:"cards"`
}
