package dtos

type TrackedMovementLatLonDTO struct {
	Id                int64
	Lat               float64
	Lon               float64
	MappedDate        int64
	TrackedMovementId int64
}
