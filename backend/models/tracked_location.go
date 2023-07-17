package models

import (
	"github.com/jinzhu/gorm"
)

type TrackedLocation struct {
	gorm.Model

	TrackedLocationPhoneId int64
	Name                   string
	ReasonId               int64
	TrackedDayId           int64
	StartTime              int64
	EndTime                int64
	Confirmed              bool
	Lat                    float64
	Lon                    float64
	Deleted                int64
	UserId                 int64
	User                   User
	TrackedMovements       []TrackedMovement
}
