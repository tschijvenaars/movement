package controllers

import (
	"github.com/gin-gonic/gin"
	"main/databases"
	"main/models"
)

func UpsertManualGeolocation(c *gin.Context) {
	userID, _ := c.Get("userID")
	var manualGeolocation models.ManualGeolocation
	var error = c.ShouldBindJSON(&manualGeolocation)
	if error != nil {
		print(error.Error())
	}
	manualGeolocation.UserId = userID.(int64)
	if databases.DB.Model(&manualGeolocation).Where("uuid = ?", manualGeolocation.Uuid).Updates(&manualGeolocation).RowsAffected == 0 {
		databases.DB.Create(&manualGeolocation)
	}
	c.JSON(200, manualGeolocation)
}
