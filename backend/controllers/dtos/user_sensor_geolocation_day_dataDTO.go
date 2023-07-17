package dtos

import "main/models"

type UserSensorGeolocationDayDataDTO struct {
	RawData       []models.SensorGeolocation
	TestRawData   [][]models.SensorGeolocation
	ValidatedData models.TrackedDay
}
