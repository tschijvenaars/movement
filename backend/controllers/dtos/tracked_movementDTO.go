package dtos

type TrackedMovementDTO struct {
	Id                 int64
	Latlons            []LatLonDTO
	StartTime          int64
	EndTime            int64
	TrackedLocationId  int64
	MovementCategoryId int64
	Confirmed          bool
}
