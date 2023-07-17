package controllers

import (
	"main/databases"
	"main/models"

	"github.com/gin-gonic/gin"
)

// GetDevices godoc
// @Summary      Get List of all devices
// @Description  Gets devices from database.
// @Tags         device
// @Accept       json
// @Produce      json
// @Success      200  {array}  models.Device
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /devices 			[get]
func GetDevices(c *gin.Context) {
	var devices []models.Device
	databases.DB.Find(&devices)

	c.JSON(200, devices)
}

func GetDevice(c *gin.Context) {

	var device models.Device
	databases.DB.First(&device, c.Param("id"))
	c.JSON(200, device)
}

// GetDeviceBySecureId godoc
// @Summary      Get device by its secure ID
// @Description  Gets Device from database by matching secure ID.
// @Tags         device
// @Accept       json
// @Produce      json
// @Param        secureId   path	int  true "Secure ID"
// @Success      200  {object}  models.Device
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /devices/bySecureId/{secureId} 			[get]
func GetDeviceBySecureId(c *gin.Context) {

	var device models.Device
	databases.DB.First(&device, "devices.secure_id = ?", c.Param("secureId"))
	c.JSON(200, device)
}

// CreateDevice godoc
// @Summary      Creates device on database.
// @Description  Post request to add new device with user ID on database
// @Tags         device
// @Accept       json
// @Produce      json
// @Param        userID  header    string  true  "UserID"
// @Success      200  {object}  models.Device
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Security	 Authorization
// @Router       /device 			[post]
func CreateDevice(c *gin.Context) {
	userID, _ := c.Get("userID")

	var device models.Device
	c.ShouldBindJSON(&device)

	device.UserId = userID.(int64)

	databases.DB.Create(&device)
	c.JSON(200, device)
}

// UpdateDevice godoc
// @Summary      Update Device on database
// @Description  Updates Device on database.
// @Tags         device
// @Accept       json
// @Produce      json
// @Param        device   body	models.Device  true		"Device"
// @Success      200  {object}  models.Device
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /device			[put]
func UpdateDevice(c *gin.Context) {
	var device models.Device
	c.ShouldBindJSON(&device)

	databases.DB.Update(&device)
	c.JSON(200, device)
}

func DeleteDevice(c *gin.Context) {
	var device models.Device
	databases.DB.First(&device, c.Param("id"))
	databases.DB.Delete(&device)

	var devices []models.Device
	databases.DB.Find(&devices)
	c.JSON(200, devices)
}
