package dtos

type SyncDTO struct {
	LastSyncs    []int64 `json:"lastSyncs"`
	LastSync     int64   `json:"lastSync"`
	Device       string  `json:"device"`
	UserId       int64   `json:"userId"`
	BatteryLevel int64   `json:"batteryLevel"`
	Days         []int64 `json:"days"`
}
