package dtos

type UserSensorGeolocationDataDTO struct {
	Sdk                             string
	Brand                           string
	Model                           string
	User                            string
	UserId                          int64
	UserSensorGeolocationDayDataDTO []UserSensorGeolocationDayDataDTO
}
