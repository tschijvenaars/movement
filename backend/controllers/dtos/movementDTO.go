package dtos

import "main/models"

type MovementDTO struct {
	MovementId         int64
	Vehicle            models.Transport
	ClassifiedPeriod   models.ClassifiedPeriod
	ManualGeolocations []models.ManualGeolocation
	SensorGeolocations []models.SensorGeolocation
}
