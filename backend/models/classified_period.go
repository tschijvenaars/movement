package models

type ClassifiedPeriod struct {
	Uuid      string `gorm:"primary_key" json:"uuid"`
	Origin    string `json:"origin"`
	StartDate int64  `json:"startDate"`
	EndDate   int64  `json:"endDate"`
	Confirmed bool   `json:"confirmed"`
	CreatedOn int64  `json:"createdOn"`
	DeletedOn int64  `json:"deletedOn"`
	UserId    int64
}
