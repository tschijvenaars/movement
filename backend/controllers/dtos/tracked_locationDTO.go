package dtos

type TrackedLocationDTO struct {
	Id           int64
	Lat          float64
	Lon          float64
	StartTime    int64
	EndTime      int64
	Name         string
	ReasonId     int64
	Confirmed    bool
	TrackedDayId int64
	Movements    []TrackedMovementDTO
}
