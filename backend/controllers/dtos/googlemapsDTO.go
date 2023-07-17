package dtos

type GoogleMapsDTO struct {
	PlaceId     string  `json:"placeId"`
	Lat         float64 `json:"lat"`
	Lon         float64 `json:"lon"`
	DisplayName string  `json:"displayName"`
	Address     string  `json:"address"`
}
