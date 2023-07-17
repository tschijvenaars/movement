package dtos

type UserTestDataDTO struct {
	Sdk                 string
	Brand               string
	Model               string
	User                string
	UserId              int64
	UserTestDaysDataDTO []UserTestDayDataDTO
}
