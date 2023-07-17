package dtos

import "main/models"

type StopDTO struct {
	StopId             int64
	Reason             models.Reason
	GoogleMapsData     models.GoogleMapsData
	ClassifiedPeriod   models.ClassifiedPeriod
	ManualGeolocations []models.ManualGeolocation
	SensorGeolocations []models.SensorGeolocation
}
