package models

type GoogleMapsData struct {
	Uuid     string `gorm:"primary_key" json:"uuid"`
	GoogleId string `json:"googleId"`
	Address  string `json:"address"`
	City     string `json:"city"`
	Postcode string `json:"postcode"`
	Country  string `json:"country"`
	Name     string `json:"name"`
	UserId   int64
}
