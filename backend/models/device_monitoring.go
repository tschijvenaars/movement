package models

import (
	"github.com/jinzhu/gorm"
)

type MonitoringDevice struct {
	gorm.Model

	Device        string
	Version       string
	Product       string
	DeviceModel   string
	Brand         string
	AndroidId     string
	SecureId      string
	SDK           string
	Width         float64
	Height        float64
	WidthLogical  float64
	HeightLogical float64
	Username      string
	LastAttempt   string
	BatteryLevel  int64
	Date          int64
}
