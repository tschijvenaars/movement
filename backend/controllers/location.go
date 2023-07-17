package controllers

import (
	"main/controllers/dtos"
	"main/databases"
	"main/models"

	"github.com/gin-gonic/gin"
)

// GetLatestLocations godoc
// @Summary      Get latest location
// @Description  Get latest location from database
// @Tags         location
// @Accept       json
// @Produce      json
// @Param        secureId   path	int  true	"Secure ID"
// @Success      200  {array}  models.Location
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /locations/getLatest/{secureId}			[get]
func GetLatestLocations(c *gin.Context) {
	var locations []models.Location
	secureId := c.Param("secureId")

	databases.DB.Table("locations").Joins("JOIN trackers ON  locations.tracker_id = trackers.id").Joins("JOIN devices ON devices.id = trackers.device_id").Where("devices.secure_id = ?", secureId).Order("id DESC").Limit(10).Find(&locations)
	c.JSON(200, locations)
}

// GetLatestLocationsPeriods godoc
// @Summary      Get latest location periods
// @Description  Get latest location periods from database
// @Tags         location
// @Accept       json
// @Produce      json
// @Param        secureId   path	int  true	"Secure ID"
// @Success      200  {array}  dtos.DeltaDTO
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /locations/GetLatestLocationsPeriods/{secureId}			[get]
func GetLatestLocationsPeriods(c *gin.Context) {

	secureId := c.Param("secureId")

	var dto []dtos.DeltaDTO
	databases.DB.Raw("select l.date, l.date - lag(l.date) over () as delta from locations l inner join trackers t on t.id = l.tracker_id inner join devices d on d.id = t.device_id where d.secure_id = ?", secureId).Scan(&dto)
	c.JSON(200, dto)
}
