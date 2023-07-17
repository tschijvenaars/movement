package models

import (
	"github.com/jinzhu/gorm"
)

type Log struct {
	gorm.Model

	Message     string
	Description string
	UserId      int64
	User        User
	Type        string
	DateTime    int64
}

// types
// - synced
// - clicked
// -
