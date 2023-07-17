package models

import (
	"github.com/jinzhu/gorm"
)

type Questionnaire struct {
	gorm.Model

	Answers string
	UserId  int64
}
