package models

import (
	"github.com/jinzhu/gorm"
)

type TrackedMovement struct {
	gorm.Model

	TrackedMovementId  int64
	TrackedLocationId  int64
	MovementCategoryId int64
	StartTime          int64
	EndTime            int64
	Confirmed          bool
	Deleted            int64
	UserId             int64
	User               User
	TrackedLatLons     []TrackedLatLon
}
