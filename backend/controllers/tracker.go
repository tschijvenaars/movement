package controllers

import (
	"main/controllers/dtos"
	"main/databases"
	"main/models"

	"github.com/gin-gonic/gin"
)

// GetLatestTrackers godoc
// @Summary      Get latest trackers
// @Description  Get latest trackers from database
// @Tags         tracker
// @Accept       json
// @Produce      json
// @Param        secureId   path	int  true	"Secure ID"
// @Success      200  {array}  models.Tracker
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /trackers/getLatest/{secureId}			[get]
func GetLatestTrackers(c *gin.Context) {
	var trackers []models.Tracker
	secureId := c.Param("secureId")

	databases.DB.Table("trackers").Joins("JOIN devices ON devices.id = trackers.device_id").Where("devices.secure_id = ?", secureId).Order("id DESC").Limit(10).Find(&trackers)
	c.JSON(200, trackers)
}

// GetLatestTrackersPeriods godoc
// @Summary      Get latest tracker periods
// @Description  Get latest tracker periods from database
// @Tags         tracker
// @Accept       json
// @Produce      json
// @Param        secureId   path	int  true	"Secure ID"
// @Success      200  {array}  dtos.DeltaDTO
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /trackers/GetLatestTrackersPeriods/{secureId}			[get]
func GetLatestTrackersPeriods(c *gin.Context) {

	secureId := c.Param("secureId")

	var dto []dtos.DeltaDTO
	databases.DB.Raw("select date, date - lag(date) over () as delta from trackers t inner join devices d on d.id = t.device_id where d.secure_id = ?", secureId).Scan(&dto)
	c.JSON(200, dto)
}

// SyncTrackers godoc
// @Summary      Sync Trackers
// @Description  Sync Trackers
// @Tags         tracker
// @Accept       json
// @Produce      json
// @Param        tracker   body	models.Tracker  true		"Tracker"
// @Success      200  {object}  models.Tracker
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /trackers			[post]
func SyncTrackers(c *gin.Context) {
	var tracker models.Tracker
	var error = c.ShouldBindJSON(&tracker)
	if error != nil {
		print(error.Error())
	}

	var device models.Device
	databases.DB.Find(&device, models.Device{SecureId: tracker.Device.SecureId})

	if device.SecureId != "" {
		tracker.DeviceID = int64(device.ID)
		tracker.Device = models.Device{}
	}

	databases.DB.Create(&tracker)
	c.JSON(200, tracker)
}
