package controllers

import (
	"main/databases"
	"main/models"

	"github.com/gin-gonic/gin"
)

// UpsertStop godoc
// @Summary      Inserts or Updates stop according to matching userID
// @Description  Upsert function for stops
// @Tags         stop
// @Accept       json
// @Produce      json
// @Success      200  {array}  models.Stop
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /stop/upsert 			[get]
func UpsertStop(c *gin.Context) {
	userID, _ := c.Get("userID")
	var stop models.Stop
	var error = c.ShouldBindJSON(&stop)
	if error != nil {
		print(error.Error())
	}
	stop.UserId = userID.(int64)
	if databases.DB.Model(&stop).Where("uuid = ?", stop.Uuid).Updates(&stop).RowsAffected == 0 {
		databases.DB.Create(&stop)
	}
	c.JSON(200, stop)
}
