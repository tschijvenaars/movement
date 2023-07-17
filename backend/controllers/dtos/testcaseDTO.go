package dtos

import "main/models"

type TestCaseDTO struct {
	Sdk           string
	Day           int64
	Brand         string
	Model         string
	TrackedDayId  int64
	User          string
	RawData       []models.Location
	ValidatedData models.TrackedDay
}
