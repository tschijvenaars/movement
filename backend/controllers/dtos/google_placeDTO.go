package dtos

type GooglePlaceDTO struct {
	PointsOfInterest []string `json:"pointsOfInterest"`
	Place            string   `json:"place"`
}
