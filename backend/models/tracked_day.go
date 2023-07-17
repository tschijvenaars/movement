package models

import (
	"github.com/jinzhu/gorm"
)

type TrackedDay struct {
	gorm.Model

	Uuid       string
	Date       int64
	Day        int64
	Confirmed  bool
	ChoiceId   int64
	ChoiceText string
	UserId     int64
	User       User
}
