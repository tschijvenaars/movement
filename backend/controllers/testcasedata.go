package controllers

import (
	"main/controllers/dtos"
	"main/databases"
	"main/models"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

func GetTestCase(c *gin.Context) {
	dayId, _ := strconv.ParseInt(c.Param("dayId"), 10, 32)
	userId, _ := strconv.ParseInt(c.Param("userId"), 10, 32)

	var day models.TrackedDay
	databases.DB.Table("tracked_days").Where("tracked_days.id = ?", dayId).Where(&models.TrackedDay{UserId: userId}).Find(&day)

	var locations []models.TrackedLocation
	databases.DB.Table("tracked_locations").Where("tracked_locations.tracked_day_id = ? and tracked_locations.user_id = ?", day.Uuid, day.UserId).Where(&models.TrackedLocation{Confirmed: true}).Where(&models.TrackedLocation{Deleted: 0}).Find(&locations)
	// day.TrackedLocations = locations

	// for j := 0; j < len(day.TrackedLocations); j++ {
	// 	var movements []models.TrackedMovement
	// 	databases.DB.Table("tracked_movements").Where("tracked_movements.tracked_location_id = ? and tracked_movements.user_id = ?", day.TrackedLocations[j].TrackedLocationPhoneId, day.UserId).Where(&models.TrackedMovement{Confirmed: true}).Find(&movements)
	// 	day.TrackedLocations[j].TrackedMovements = movements

	// 	for k := 0; k < len(day.TrackedLocations[j].TrackedMovements); k++ {
	// 		var latlons []models.TrackedLatLon
	// 		databases.DB.Table("tracked_lat_lons").Where("tracked_lat_lons.tracked_movementid = ? and tracked_movements.user_id", day.TrackedLocations[j].TrackedMovements[k].TrackedMovementId, day.UserId).Find(&latlons)
	// 		day.TrackedLocations[j].TrackedMovements[k].TrackedLatLons = latlons
	// 	}
	// }

	var rawLocations []models.Location
	var date = time.Unix(day.Date/1000, 0)
	var startTime = time.Date(date.Year(), date.Month(), date.Day(), 0, 0, 0, 0, time.UTC).Unix() * 1000
	var endTime = time.Date(date.Year(), date.Month(), date.Day(), 23, 59, 59, 0, time.UTC).Unix() * 1000

	databases.DB.Table("locations").Joins("JOIN trackers ON  locations.tracker_id = trackers.id").Joins("JOIN devices ON devices.id = trackers.device_id").Where("devices.user_id = ?", day.UserId).Where("locations.date > ? AND locations.date < ?", startTime, endTime).Find(&rawLocations)

	var device models.Device
	databases.DB.Table("devices").Where("devices.user_id = ?", day.UserId).Find(&device)

	var testCase = dtos.TestCaseDTO{}
	testCase.ValidatedData = day
	testCase.RawData = rawLocations
	testCase.Day = day.Date
	testCase.Brand = device.Brand
	testCase.Sdk = device.SDK
	testCase.Model = device.DeviceModel

	c.JSON(200, testCase)
}

func GetShallowTestCaseData(c *gin.Context) {
	var days []models.TrackedDay
	var testCaseData []dtos.TestCaseDTO
	databases.DB.Table("tracked_days").Find(&days)
	for i := 0; i < len(days); i++ {

		var locations []models.TrackedLocation
		databases.DB.Table("tracked_locations").Where("tracked_locations.tracked_day_id = ? and tracked_locations.user_id = ?", days[i].Uuid, days[i].UserId).Where(&models.TrackedLocation{Confirmed: true}).Where(&models.TrackedLocation{Deleted: 0}).Find(&locations)
		// days[i].TrackedLocations = locations

		// for j := 0; j < len(days[i].TrackedLocations); j++ {
		// 	var movements []models.TrackedMovement
		// 	databases.DB.Table("tracked_movements").Where("tracked_movements.tracked_location_id = ? and tracked_movements.user_id = ?", days[i].TrackedLocations[j].TrackedLocationPhoneId, days[i].UserId).Where(&models.TrackedMovement{Confirmed: true}).Find(&movements)
		// 	days[i].TrackedLocations[j].TrackedMovements = movements

		// 	for k := 0; k < len(days[i].TrackedLocations[j].TrackedMovements); k++ {
		// 		var latlons []models.TrackedLatLon
		// 		databases.DB.Table("tracked_lat_lons").Where("tracked_lat_lons.tracked_movementid = ? and tracked_lat_lons.user_id = ?", days[i].TrackedLocations[j].TrackedMovements[k].TrackedMovementId, days[i].UserId).Find(&latlons)
		// 		days[i].TrackedLocations[j].TrackedMovements[k].TrackedLatLons = latlons
		// 	}
		// }

		var rawLocations []models.Location
		var date = time.Unix(days[i].Date/1000, 0)
		var startTime = time.Date(date.Year(), date.Month(), date.Day(), 0, 0, 0, 0, time.UTC).Unix() * 1000
		var endTime = time.Date(date.Year(), date.Month(), date.Day(), 23, 59, 59, 0, time.UTC).Unix() * 1000

		databases.DB.Table("locations").Joins("JOIN trackers ON  locations.tracker_id = trackers.id").Joins("JOIN devices ON devices.id = trackers.device_id").Where("devices.user_id = ?", days[i].UserId).Where("locations.date > ? AND locations.date < ?", startTime, endTime).Find(&rawLocations)

		var device models.Device
		databases.DB.Table("devices").Where("devices.user_id = ?", days[i].UserId).Find(&device)

		var user models.User
		databases.DB.Table("users").Where("users.id = ?", days[i].UserId).Find(&user)

		var testCase = dtos.TestCaseDTO{}
		testCase.User = user.Username
		testCase.RawData = rawLocations
		testCase.ValidatedData = days[i]
		testCase.TrackedDayId = int64(days[i].ID)
		testCase.Day = days[i].Date
		testCase.Brand = device.Brand
		testCase.Sdk = device.SDK
		testCase.Model = device.DeviceModel
		testCaseData = append(testCaseData, testCase)
	}

	c.JSON(200, testCaseData)
}

func GetTestCaseData(c *gin.Context) {
	var days []models.TrackedDay
	var testCaseData []dtos.TestCaseDTO
	databases.DB.Table("tracked_days").Where(&models.TrackedDay{Confirmed: true}).Find(&days)

	for i := 0; i < len(days); i++ {
		var locations []models.TrackedLocation
		databases.DB.Table("tracked_locations").Where("tracked_locations.tracked_day_id = ? and tracked_locations.user_id = ?", days[i].Uuid, days[i].UserId).Where(&models.TrackedLocation{Confirmed: true}).Where(&models.TrackedLocation{Deleted: 0}).Find(&locations)
		// days[i].TrackedLocations = locations

		// for j := 0; j < len(days[i].TrackedLocations); j++ {
		// 	var movements []models.TrackedMovement
		// 	databases.DB.Table("tracked_movements").Where("tracked_movements.tracked_location_id = ? and tracked_movements.user_id = ?", days[i].TrackedLocations[j].TrackedLocationPhoneId, days[i].UserId).Where(&models.TrackedMovement{Confirmed: true}).Where(&models.TrackedMovement{Deleted: 0}).Find(&movements)
		// 	days[i].TrackedLocations[j].TrackedMovements = movements

		// 	for k := 0; k < len(days[i].TrackedLocations[j].TrackedMovements); k++ {
		// 		var latlons []models.TrackedLatLon
		// 		databases.DB.Table("tracked_lat_lons").Where("tracked_lat_lons.tracked_movementid = ? and tracked_movements.user_id", days[i].TrackedLocations[j].TrackedMovements[k].TrackedMovementId, days[i].UserId).Find(&latlons)
		// 		days[i].TrackedLocations[j].TrackedMovements[k].TrackedLatLons = latlons
		// 	}
		// }

		var rawLocations []models.Location
		var date = time.Unix(days[i].Date/1000, 0)
		var startTime = time.Date(date.Year(), date.Month(), date.Day(), 0, 0, 0, 0, time.UTC).Unix() * 1000
		var endTime = time.Date(date.Year(), date.Month(), date.Day(), 23, 59, 59, 0, time.UTC).Unix() * 1000

		databases.DB.Table("locations").Joins("JOIN trackers ON  locations.tracker_id = trackers.id").Joins("JOIN devices ON devices.id = trackers.device_id").Where("devices.user_id = ?", days[i].UserId).Where("locations.date > ? AND locations.date < ?", startTime, endTime).Find(&rawLocations)

		var device models.Device
		databases.DB.Table("devices").Where("devices.user_id = ?", days[i].UserId).Find(&device)

		var testCase = dtos.TestCaseDTO{}
		testCase.ValidatedData = days[i]
		testCase.RawData = rawLocations
		testCase.Day = days[i].Date
		testCase.Brand = device.Brand
		testCase.Sdk = device.SDK
		testCaseData = append(testCaseData, testCase)
	}

	c.JSON(200, testCaseData)
}

func GetUserTestCaseData(c *gin.Context) {
	var userData []dtos.UserTestDataDTO
	var users []models.User
	databases.DB.Table("users").Find(&users)
	for u := 0; u < len(users); u++ {
		var days []models.TrackedDay
		var userDays []dtos.UserTestDayDataDTO
		databases.DB.Table("tracked_days").Where("tracked_days.user_id = ?", users[u].ID).Find(&days)
		for i := 0; i < len(days); i++ {

			var locations []models.TrackedLocation
			databases.DB.Table("tracked_locations").Where("tracked_locations.tracked_day_id = ? and tracked_locations.user_id = ?", days[i].Uuid, days[i].UserId).Where(&models.TrackedLocation{Confirmed: true}).Where(&models.TrackedLocation{Deleted: 0}).Find(&locations)
			// days[i].TrackedLocations = locations

			// for j := 0; j < len(days[i].TrackedLocations); j++ {
			// 	var movements []models.TrackedMovement
			// 	databases.DB.Table("tracked_movements").Where("tracked_movements.tracked_location_id = ? and tracked_movements.user_id = ?", days[i].TrackedLocations[j].TrackedLocationPhoneId, days[i].UserId).Where(&models.TrackedMovement{Confirmed: true}).Find(&movements)
			// 	days[i].TrackedLocations[j].TrackedMovements = movements

			// 	for k := 0; k < len(days[i].TrackedLocations[j].TrackedMovements); k++ {
			// 		var latlons []models.TrackedLatLon
			// 		databases.DB.Table("tracked_lat_lons").Where("tracked_lat_lons.tracked_movementid = ? and tracked_lat_lons.user_id = ?", days[i].TrackedLocations[j].TrackedMovements[k].TrackedMovementId, days[i].UserId).Find(&latlons)
			// 		days[i].TrackedLocations[j].TrackedMovements[k].TrackedLatLons = latlons
			// 	}
			// }

			var rawLocations []models.Location
			var date = time.Unix(days[i].Date/1000, 0)
			var startTime = time.Date(date.Year(), date.Month(), date.Day(), 0, 0, 0, 0, time.UTC).Unix() * 1000
			var endTime = time.Date(date.Year(), date.Month(), date.Day(), 23, 59, 59, 0, time.UTC).Unix() * 1000

			var pings []models.Tracker
			databases.DB.Table("locations").Joins("JOIN trackers ON  locations.tracker_id = trackers.id").Joins("JOIN devices ON devices.id = trackers.device_id").Where("devices.user_id = ?", days[i].UserId).Where("locations.date > ? AND locations.date < ?", startTime, endTime).Find(&rawLocations)
			databases.DB.Table("trackers").Joins("JOIN devices ON devices.id = trackers.device_id").Where("devices.user_id = ?", days[i].UserId).Find(&pings)

			var day = dtos.UserTestDayDataDTO{}
			day.RawData = rawLocations
			day.ValidatedData = days[i]
			day.Pings = pings
			day.TestRawData = splitLocations(rawLocations)
			userDays = append(userDays, day)
		}

		var device models.Device
		databases.DB.Table("devices").Where("devices.user_id = ?", users[u].ID).Find(&device)

		var data = dtos.UserTestDataDTO{}
		data.UserTestDaysDataDTO = userDays
		data.User = users[u].Username
		data.UserId = int64(users[u].ID)
		data.Brand = device.Brand
		data.Sdk = device.SDK
		data.Model = device.DeviceModel

		if len(data.UserTestDaysDataDTO) > 0 {
			userData = append(userData, data)
		}

	}

	c.JSON(200, userData)
}

func GetUserSensorGeolocationData(c *gin.Context) {
	var userData []dtos.UserSensorGeolocationDataDTO
	var users []models.User
	databases.DB.Table("users").Find(&users)
	for u := 0; u < len(users); u++ {
		var days []models.TrackedDay
		var userDays []dtos.UserSensorGeolocationDayDataDTO
		databases.DB.Table("tracked_days").Where("tracked_days.user_id = ?", users[u].ID).Find(&days)
		for i := 0; i < len(days); i++ {

			var locations []models.TrackedLocation
			databases.DB.Table("tracked_locations").Where("tracked_locations.tracked_day_id = ? and tracked_locations.user_id = ?", days[i].Uuid, days[i].UserId).Where(&models.TrackedLocation{Confirmed: true}).Where(&models.TrackedLocation{Deleted: 0}).Find(&locations)
			// days[i].TrackedLocations = locations

			// for j := 0; j < len(days[i].TrackedLocations); j++ {
			// 	var movements []models.TrackedMovement
			// 	databases.DB.Table("tracked_movements").Where("tracked_movements.tracked_location_id = ? and tracked_movements.user_id = ?", days[i].TrackedLocations[j].TrackedLocationPhoneId, days[i].UserId).Where(&models.TrackedMovement{Confirmed: true}).Find(&movements)
			// 	days[i].TrackedLocations[j].TrackedMovements = movements

			// 	for k := 0; k < len(days[i].TrackedLocations[j].TrackedMovements); k++ {
			// 		var latlons []models.TrackedLatLon
			// 		databases.DB.Table("tracked_lat_lons").Where("tracked_lat_lons.tracked_movementid = ? and tracked_lat_lons.user_id = ?", days[i].TrackedLocations[j].TrackedMovements[k].TrackedMovementId, days[i].UserId).Find(&latlons)
			// 		days[i].TrackedLocations[j].TrackedMovements[k].TrackedLatLons = latlons
			// 	}
			// }

			var rawLocations []models.SensorGeolocation
			var date = time.Unix(days[i].Day/1000, 0)
			var startTime = time.Date(date.Year(), date.Month(), date.Day(), 0, 0, 0, 0, time.UTC).Unix() * 1000
			var endTime = time.Date(date.Year(), date.Month(), date.Day(), 23, 59, 59, 0, time.UTC).Unix() * 1000

			databases.DB.Table("sensor_geolocations").Where("sensor_geolocations.user_id = ?", days[i].UserId).Where("sensor_geolocations.created_on > ? AND sensor_geolocations.created_on < ?", startTime, endTime).Find(&rawLocations)

			var day = dtos.UserSensorGeolocationDayDataDTO{}
			day.RawData = rawLocations
			day.ValidatedData = days[i]
			day.TestRawData = splitSensorGeolocation(rawLocations)
			userDays = append(userDays, day)
		}

		var device models.Device
		databases.DB.Table("devices").Where("devices.user_id = ?", users[u].ID).Find(&device)

		var data = dtos.UserSensorGeolocationDataDTO{}
		data.UserSensorGeolocationDayDataDTO = userDays
		data.User = users[u].Username
		data.UserId = int64(users[u].ID)
		data.Brand = device.Brand
		data.Sdk = device.SDK
		data.Model = device.DeviceModel

		if len(data.UserSensorGeolocationDayDataDTO) > 0 {
			userData = append(userData, data)
		}

	}

	c.JSON(200, userData)
}

func splitLocations(locations []models.Location) [][]models.Location {
	var testLocations = [][]models.Location{}
	var fusedLocations = []models.Location{}
	var normalLocations = []models.Location{}
	var balancedLocations = []models.Location{}

	for i := 0; i < len(locations); i++ {
		if locations[i].SensorType == "fused" {
			fusedLocations = append(fusedLocations, locations[i])
		} else if locations[i].SensorType == "balanced" {
			balancedLocations = append(balancedLocations, locations[i])
		} else if locations[i].SensorType == "normal" {
			normalLocations = append(normalLocations, locations[i])
		}
	}

	testLocations = append(testLocations, fusedLocations)
	testLocations = append(testLocations, normalLocations)
	testLocations = append(testLocations, balancedLocations)

	return testLocations
}

func splitSensorGeolocation(locations []models.SensorGeolocation) [][]models.SensorGeolocation {
	var testLocations = [][]models.SensorGeolocation{}
	var fusedLocations = []models.SensorGeolocation{}
	var normalLocations = []models.SensorGeolocation{}
	var balancedLocations = []models.SensorGeolocation{}

	for i := 0; i < len(locations); i++ {
		if locations[i].SensorType == "fused" {
			fusedLocations = append(fusedLocations, locations[i])
		} else if locations[i].SensorType == "balanced" {
			balancedLocations = append(balancedLocations, locations[i])
		} else if locations[i].SensorType == "normal" {
			normalLocations = append(normalLocations, locations[i])
		} else if locations[i].SensorType == "" {
			normalLocations = append(normalLocations, locations[i])
		}
	}

	testLocations = append(testLocations, fusedLocations)
	testLocations = append(testLocations, normalLocations)
	testLocations = append(testLocations, balancedLocations)

	return testLocations
}
