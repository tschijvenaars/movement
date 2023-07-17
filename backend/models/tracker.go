package models

import (
	"github.com/jinzhu/gorm"
)

type Tracker struct {
	gorm.Model

	BatteryLevel int64
	Date         int64
	Locations    []Location
	Device       Device
	DeviceID     int64
}
