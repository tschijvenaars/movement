package models

import (
	"github.com/jinzhu/gorm"
)

type GoogleErrorLog struct {
	gorm.Model

	UserId   int64
	ErrorMsg string
}
