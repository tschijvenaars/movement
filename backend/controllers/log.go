package controllers

import (
	"main/databases"
	"main/models"

	"github.com/gin-gonic/gin"
)

// GetLatestLogs godoc
// @Summary      Gets latest logs of secureId
// @Description  Gets latest logs of secureId from database
// @Tags         logging
// @Accept       json
// @Produce      json
// @Param        secureId   path	int  true	"Secure ID"
// @Success      200  {array}   models.Log
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /logs/getLatest/{secureId}			[get]
func GetLatestLogs(c *gin.Context) {
	var logs []models.Log
	secureId := c.Param("secureId")

	databases.DB.Table("logs").Joins("JOIN devices ON devices.id = logs.device_id").Where("devices.secure_id = ?", secureId).Order("id DESC").Limit(10).Find(&logs)
	c.JSON(200, logs)
}

// SyncLogs godoc
// @Summary      Syncs logs
// @Description  Syncs logs
// @Tags         logging
// @Accept       json
// @Produce      json
// @Param        logs   body	models.Log  true	"Log"
// @Success      200  {object}   models.Device
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /logs/syncLogs			[post]
func SyncLogs(c *gin.Context) {
	var logs []models.Log
	userID, _ := c.Get("userID")
	c.ShouldBindJSON(&logs)

	for _, log := range logs {
		log.UserId = userID.(int64)
		databases.DB.Create(&log)
	}

	c.JSON(200, logs)
}
