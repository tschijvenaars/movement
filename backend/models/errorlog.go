package models

import (
	"github.com/jinzhu/gorm"
)

type ErrorLog struct {
	gorm.Model

	message        string
	stacktrace     string
	innerException string
	statusCode     int32
	typeException  string
	DeviceID       int
	Type           string
	dateTime       int32
}
