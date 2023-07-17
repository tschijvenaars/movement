package databases

import (
	"os"
	"github.com/jinzhu/gorm"
	_ "github.com/lib/pq"
)

var DB *gorm.DB

func InitializeDatabase() {
	password := os.Getenv("go_password")
	dbname := os.Getenv("go_dbname")
	conninfo := "user=postgres password=" + password + " host=127.0.0.1 dbname=" + dbname + " sslmode=disable"
	database, err := gorm.Open("postgres", conninfo)

	if err != nil {
		panic("failed to connect database")
	}

	DB = database

}
