package controllers

import (
	"main/controllers/dtos"
	"main/databases"
	"main/models"
	"time"

	"github.com/gin-gonic/gin"
)

func GetUsers(c *gin.Context) {
	var userDeviceData []dtos.UserDeviceDTO
	var users []models.User
	databases.DB.Table("users").Find(&users)
	for i := 0; i < len(users); i++ {

		var device models.Device
		databases.DB.Table("devices").Where("devices.user_id = ?", users[i].ID).Find(&device)

		var userDeviceDTO dtos.UserDeviceDTO
		userDeviceDTO.User = users[i]
		userDeviceDTO.User = users[i]
		userDeviceDTO.Device = device

		var days []models.TrackedDay
		databases.DB.Table("tracked_days").Where("tracked_days.user_id = ?", users[i].ID).Find(&days)

		if len(days) > 0 {
			userDeviceData = append(userDeviceData, userDeviceDTO)
		}

	}

	c.JSON(200, userDeviceData)
}

func SyncDate(c *gin.Context) {
	var days []models.TrackedDay
	databases.DB.Table("tracked_days").Find(&days)

	for i := 0; i < len(days); i++ {
		days[i].Date = days[i].Day
		databases.DB.Model(&days[i]).Update(days[i])
	}

	c.JSON(200, "Success")
}

func GetUser(c *gin.Context) {
	userId := c.Param("userId")

	var user models.User

	var days []models.TrackedDay
	var userDays []dtos.UserSensorGeolocationDayDataDTO
	databases.DB.Table("users").Where("users.id = ?", userId).Find(&user)
	databases.DB.Table("tracked_days").Where("tracked_days.user_id = ?", user.ID).Find(&days)
	for i := 0; i < len(days); i++ {

		var rawLocations []models.SensorGeolocation
		var date = time.Unix(days[i].Date/1000, 0)
		var y = date.Year()
		var m = date.Month()
		var d = date.Day()
		var startTime = time.Date(y, m, d, 0, 0, 0, 0, time.UTC).Unix() * 1000
		var endTime = time.Date(y, m, d, 23, 59, 59, 0, time.UTC).Unix() * 1000

		databases.DB.Table("sensor_geolocations").Where("sensor_geolocations.user_id = ?", days[i].UserId).Where("sensor_geolocations.created_on > ? AND sensor_geolocations.created_on < ?", startTime, endTime).Find(&rawLocations)

		var day = dtos.UserSensorGeolocationDayDataDTO{}
		day.RawData = rawLocations
		day.ValidatedData = days[i]
		day.TestRawData = splitSensorGeolocation(rawLocations)
		userDays = append(userDays, day)
	}

	var device models.Device
	databases.DB.Table("devices").Where("devices.user_id = ?", user.ID).Find(&device)

	var data = dtos.UserSensorGeolocationDataDTO{}
	data.UserSensorGeolocationDayDataDTO = userDays
	data.User = user.Username
	data.UserId = int64(user.ID)
	data.Brand = device.Brand
	data.Sdk = device.SDK
	data.Model = device.DeviceModel

	c.JSON(200, data)
}
