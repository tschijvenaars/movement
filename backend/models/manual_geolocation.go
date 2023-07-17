package models

type ManualGeolocation struct {
	Uuid                 string  `gorm:"primary_key" json:"uuid"`
	ClassifiedPeriodUuid string  `json:"classifiedPeriodUuid"`
	Latitude             float64 `json:"latitude"`
	Longitude            float64 `json:"longitude"`
	CreatedOn            int64   `json:"createdOn"`
	DeletedOn            int64   `json:"deletedOn"`
	UserId               int64
}
