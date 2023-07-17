package models

type Movement struct {
	Uuid                 string `gorm:"primary_key" json:"uuid"`
	ClassifiedPeriodUuid string `json:"classifiedPeriodUuid"`
	VehicleId            int64  `json:"vehicleId"`
	UserId               int64
}
