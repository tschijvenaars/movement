package models

import (
	"github.com/jinzhu/gorm"
)

type TrackedLatLon struct {
	gorm.Model

	TrackedLatLonId   int64
	TrackedMovementid int64
	Lat               float64
	Lon               float64
	Altitude          float64
	MappedDate        int64
	UserId            int64
	User              User
}
