package models

import (
	"github.com/jinzhu/gorm"
)

type Location struct {
	gorm.Model

	Lon        float64
	Lat        float64
	Altitude   float64
	SensorType string
	Date       int64
	Speed      float64
	Bearing    float64
	Provider   string
	Accuracy   float64
	TrackerID  int64
}
