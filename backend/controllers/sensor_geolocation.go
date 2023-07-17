package controllers

import (
	"main/databases"
	"main/models"

	"github.com/gin-gonic/gin"
)

func InsertSensorGeolocation(c *gin.Context) {
	userID, _ := c.Get("userID")
	var geolocation models.SensorGeolocation
	var error = c.ShouldBindJSON(&geolocation)
	if error != nil {
		print(error.Error())
	}
	geolocation.UserId = userID.(int64)
	databases.DB.Create(&geolocation)
	c.JSON(200, geolocation)
}


func BulkInsertSensorGeolocation(c *gin.Context) {
	userID, _ := c.Get("userID")
	var geolocations []models.SensorGeolocation
	c.ShouldBindJSON(&geolocations)

	for _, geolocation := range geolocations {
		geolocation.UserId = userID.(int64)
		databases.DB.Create(&geolocation)
	}
	c.JSON(200, geolocations)
}
