package models

type Stop struct {
	Uuid                 string `gorm:"primary_key" json:"uuid"`
	ClassifiedPeriodUuid string `json:"classifiedPeriodUuid"`
	ReasonId             int64  `json:"reasonId"`
	GoogleMapsDataUuid   string `json:"googleMapsDataUuid"`
	UserId               int64
}
