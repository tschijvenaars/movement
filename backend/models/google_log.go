package models

import (
	"github.com/jinzhu/gorm"
)

type GoogleLog struct {
	gorm.Model

	WasAllowed bool
	Query      string
	Lat        float64
	Lon        float64
	DateTime   int64
	UserId     int64
	Request    string
}
