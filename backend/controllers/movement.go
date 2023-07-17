package controllers

import (
	"main/databases"
	"main/models"

	"github.com/gin-gonic/gin"
)

// UpsertMovement godoc
// @Summary      Inserts or Updates movement according to matching userID
// @Description  Upsert function for movements
// @Tags         movement
// @Accept       json
// @Produce      json
// @Success      200  {array}  models.Movement
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /movement/upsert 			[get]
func UpsertMovement(c *gin.Context) {
	userID, _ := c.Get("userID")
	var movement models.Movement
	var error = c.ShouldBindJSON(&movement)
	if error != nil {
		print(error.Error())
	}
	movement.UserId = userID.(int64)
	if databases.DB.Model(&movement).Where("uuid = ?", movement.Uuid).Updates(&movement).RowsAffected == 0 {
		databases.DB.Create(&movement)
	}
	c.JSON(200, movement)
}
