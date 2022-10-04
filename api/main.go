package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	_ "github.com/go-sql-driver/mysql"
	"github.com/joho/godotenv"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

func main() {
	if err := godotenv.Load(); err != nil {
		log.Fatalln(err)
	}

	connstring := fmt.Sprintf("%s:%s@/%s", os.Getenv("DB_USER"), os.Getenv("DB_PASSWD"), os.Getenv("DB_NAME"))
	db := util.Must(sql.Open(os.Getenv("DB_DRIVER"), connstring)).(*sql.DB)
	log.Println(connstring)
	res := util.Must(db.Exec(`INSERT INTO Users (email, readerdata, isadmin) VALUES (?,?,?)`, "inserted-from@go.org", "8278787384fdhd83", false)).(sql.Result)
	id := util.Must(res.LastInsertId()).(int64)
	log.Println("inserted id:", id)

}
