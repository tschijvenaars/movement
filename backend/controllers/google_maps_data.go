package controllers

import (
	"github.com/gin-gonic/gin"
	"main/databases"
	"main/models"
)

func UpsertGoogleMapsData(c *gin.Context) {
	userID, _ := c.Get("userID")
	var googleMapsData models.GoogleMapsData
	var error = c.ShouldBindJSON(&googleMapsData)
	if error != nil {
		print(error.Error())
	}
	googleMapsData.UserId = userID.(int64)
	if databases.DB.Model(&googleMapsData).Where("uuid = ?", googleMapsData.Uuid).Updates(&googleMapsData).RowsAffected == 0 {
		databases.DB.Create(&googleMapsData)
	}
	c.JSON(200, googleMapsData)
}
