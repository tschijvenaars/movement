package dtos

import "main/models"

type SensorGeolocationBatchDTO struct {
	SensorGeoLocationBatch []models.SensorGeolocation `json:"sensorGeoLocationBatch"`
	UserId                 int64                      `json:"userId"`
}
