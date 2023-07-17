package controllers

import (
	"main/databases"
	"main/models"

	"github.com/gin-gonic/gin"
)

func GetTestCases(c *gin.Context) {
	var devices []models.Device
	databases.DB.Find(&devices)

	c.JSON(200, devices)
}
