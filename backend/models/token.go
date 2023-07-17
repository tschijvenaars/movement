package models

import "github.com/jinzhu/gorm"

type Token struct {
	gorm.Model

	AccessToken  string
	RefreshToken string
	AccessUuid   string
	RefreshUuid  string
	AtExpires    int64
	RtExpires    int64
}
