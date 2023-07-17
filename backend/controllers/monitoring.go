package controllers

import (
	"main/controllers/dtos"
	"main/databases"
	"main/models"
	"time"

	"github.com/gin-gonic/gin"
)

// GetDevicesForMonitoring godoc
// @Summary      Get List of all devices
// @Description  Gets devices from database with latest tracker
// @Tags         device
// @Accept       json
// @Produce      json
// @Success      200  {array}  models.Device
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /devicesMonitoring 			[get]
func GetDevicesForMonitoring(c *gin.Context) {
	var devices []models.MonitoringDevice
	//subQuery2 := databases.DB.Raw("SELECT MAX(trackers.date) FROM public.trackers WHERE public.trackers.device_id = track.device_id").QueryExpr()
	//databases.DB.Raw("SELECT * FROM public.devices JOIN public.users ON users.id = user_id JOIN public.trackers track ON track.device_id = devices.id WHERE track.date = (?) ORDER BY devices.id DESC", subQuery2).Scan(&devices)
	subQuery1 := databases.DB.Raw("SELECT distinct on (device_id) device_id, id as tracker_id, date, battery_level from trackers order by device_id, date desc").QueryExpr()
	subQuery2 := databases.DB.Raw("select distinct on (lt.device_id) lt.device_id, lt.battery_level, l.id, l.date from latest_tracker as lt join locations as l on l.tracker_id = lt.tracker_id order by lt.device_id, l.date desc").QueryExpr()
	databases.DB.Raw("WITH latest_tracker as (?), latest_location as (?) select * from devices d inner join users u on u.id = d.user_id left join latest_location l on l.device_id = d.id", subQuery1, subQuery2).Scan(&devices)

	c.JSON(200, devices)
}

func GetDataForMonitoring(c *gin.Context) {
	var devices []models.Device
	var syncData []dtos.SyncDTO

	databases.DB.Table("devices").Find(&devices)

	if len(devices) == 0 {
		c.JSON(200, []dtos.SyncDTO{})
		return
	}

	for i := 0; i < len(devices); i++ {
		var sync = dtos.SyncDTO{}
		var geolocations []models.SensorGeolocation
		var days []models.TrackedDay
		var user models.User

		databases.DB.Table("sensor_geolocations").Where("sensor_geolocations.user_id = ?", devices[i].UserId).Find(&geolocations)
		databases.DB.Table("tracked_days").Where("tracked_days.user_id = ?", devices[i].UserId).Find(&days)
		databases.DB.Table("users").Where("users.id = ?", devices[i].UserId).Find(&user)

		var splittedGeoLocations = splitSensorGeolocation(geolocations)

		if len(geolocations) > 0 {
			sync.BatteryLevel = geolocations[len(geolocations)-1].BatteryLevel
			sync.LastSync = geolocations[len(geolocations)-1].CreatedOn
		}

		sync.UserId = int64(user.ID)
		sync.Device = user.Username + " - " + devices[i].Device + " - " + devices[i].Brand

		if len(splittedGeoLocations[0]) > 0 {
			sync.LastSyncs = append(sync.LastSyncs, splittedGeoLocations[0][len(splittedGeoLocations[0])-1].CreatedOn)
		}

		if len(splittedGeoLocations[1]) > 0 {
			sync.LastSyncs = append(sync.LastSyncs, splittedGeoLocations[1][len(splittedGeoLocations[1])-1].CreatedOn)
		}

		if len(splittedGeoLocations[2]) > 0 {
			sync.LastSyncs = append(sync.LastSyncs, splittedGeoLocations[2][len(splittedGeoLocations[2])-1].CreatedOn)
		}

		for d := 0; d < len(days); d++ {
			var date = time.Unix(days[d].Day/1000, 0)
			var startTime = time.Date(date.Year(), date.Month(), date.Day(), 0, 0, 0, 0, time.UTC).Unix() * 1000
			var endTime = time.Date(date.Year(), date.Month(), date.Day(), 23, 59, 59, 0, time.UTC).Unix() * 1000
			var count int64 = 0

			databases.DB.Table("sensor_geolocations").Where("sensor_geolocations.user_id = ?", days[d].UserId).Where("sensor_geolocations.created_on > ? AND sensor_geolocations.created_on < ?", startTime, endTime).Count(&count)
			sync.Days = append(sync.Days, count)
		}

		syncData = append(syncData, sync)
	}

	c.JSON(200, syncData)
}

// GetStats godoc
// @Summary      Gets data object containing all KPIs
// @Description  Gets data object with all stats and KPIs
// @Tags         stats
// @Accept       json
// @Produce      json
// @Success      200  {array}  models.Kpi
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /getKPIs 			[get]
func GetStats(c *gin.Context) {
	var notUsedLogin int
	var totalLogins int
	var totalLocations int
	var totalLocationsDay int

	databases.DB.Table("users").Where("last_attempt <= '2000-01-01'").Count(&notUsedLogin)
	databases.DB.Table("users").Count(&totalLogins)
	databases.DB.Table("locations").Count(&totalLocations)
	databases.DB.Table("locations").Where("to_timestamp(date/1000)::date >= NOW() - '1 day'::INTERVAL").Count(&totalLocationsDay)
	stats := models.Kpi{UserTotal: totalLogins, UserUnused: notUsedLogin, TotalLocationsDay: totalLocationsDay, TotalLocations: totalLocations}
	c.JSON(200, stats)
}

// GetLogs godoc
// @Summary      Gets latest 100 logs
// @Description  Gets latest logs from database
// @Tags         logging
// @Accept       json
// @Produce      json
// @Success      200  {array}   models.Log
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /logsMonitoring			[get]
func GetLogs(c *gin.Context) {
	var logs []models.Log

	databases.DB.Table("logs").Order("id DESC").Limit(100).Find(&logs)
	c.JSON(200, logs)
}

// GetUnusedUsernames godoc
// @Summary      Get List of all unused usernames
// @Description  Gets usernames from database which have not been initialized (never logged in, timestamp of 0001-01-01).
// @Tags         user
// @Accept       json
// @Produce      json
// @Success      200  {array}  models.User
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /unusedUsernames 			[get]
func GetUnusedUsernames(c *gin.Context) {
	var users []models.User

	time := "2000-01-01"
	databases.DB.Table("users").Select("username, last_attempt").Where("last_attempt <= ?", time).Find(&users)
	c.JSON(200, users)
}

// GetErrorLogs godoc
// @Summary      Gets error latest logs
// @Description  Gets latest error logs from database
// @Tags         logging
// @Accept       json
// @Produce      json
// @Success      200  {array}   models.GoogleErrorLog
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /errorMonitoring			[get]
func GetErrorLogs(c *gin.Context) {
	var logs []models.ErrorLog

	databases.DB.Table("error_logs").Order("id DESC").Limit(100).Find(&logs)
	c.JSON(200, logs)
}

// GetGoogleErrorLogs godoc
// @Summary      Gets latest google error logs
// @Description  Gets latest google error logs from database
// @Tags         logging
// @Accept       json
// @Produce      json
// @Success      200  {array}   models.GoogleErrorLog
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /googleErrorMonitoring			[get]
func GetGoogleErrorLogs(c *gin.Context) {
	var logs []models.GoogleErrorLog

	databases.DB.Table("google_error_logs").Order("id DESC").Limit(100).Find(&logs)
	c.JSON(200, logs)
}

func DeleteTrackedDaysUser(c *gin.Context) {
	userId := c.Param("userId")

	var days []models.TrackedDay
	var device models.Device

	databases.DB.Table("tracked_days").Where("tracked_days.user_id = ?", userId).Delete(&days)
	databases.DB.Table("devices").Where("devices.user_id = ?", userId).Delete(&device)

	c.JSON(200, device)
}
