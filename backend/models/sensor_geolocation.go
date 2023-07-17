package models

type SensorGeolocation struct {
	Uuid         string  `gorm:"primary_key" json:"uuid"`
	Latitude     float64 `json:"latitude"`
	Longitude    float64 `json:"longitude"`
	Altitude     float64 `json:"altitude"`
	Bearing      float64 `json:"bearing"`
	Accuracy     float64 `json:"accuracy"`
	Speed        float64 `json:"speed"`
	SensorType   string  `json:"sensorType"`
	Provider     string  `json:"provider"`
	IsNoise      bool    `json:"isNoise"`
	CreatedOn    int64   `json:"createdOn"`
	DeletedOn    int64   `json:"deletedOn"`
	BatteryLevel int64   `json:"batteryLevel"`
	UserId       int64
}
