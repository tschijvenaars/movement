package models

import (
	"github.com/jinzhu/gorm"
)

type Device struct {
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
	UserId        int64
	User          User
	Logs          []Log
	ErrorLogs     []ErrorLog
}
