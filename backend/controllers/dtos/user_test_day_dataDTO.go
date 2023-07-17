package dtos

import "main/models"

type UserTestDayDataDTO struct {
	RawData       []models.Location
	TestRawData   [][]models.Location
	ValidatedData models.TrackedDay
	Pings         []models.Tracker
}
