package models

import (
	"time"
)

type Reason struct {
	ID        uint       `gorm:"primary_key" json:"id"`
	CreatedAt time.Time  `json:"created_at"`
	UpdatedAt time.Time  `json:"updated_at"`
	DeletedAt *time.Time `json:"deleted_at"`

	Name  string `json:"name"`
	Icon  string `json:"icon"`
	Color string `json:"color"`
	Key   string `json:"key"`
}
