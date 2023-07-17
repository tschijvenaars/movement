package controllers

import (
	"main/databases"
	"main/models"

	"github.com/gin-gonic/gin"
)

// UpsertClassifiedPeriod godoc
// @Summary      Inserts or Updates classified period according to matching userID
// @Description  Upsert function for classified periods
// @Tags         classifiedPeriod
// @Accept       json
// @Produce      json
// @Success      200  {array}  models.ClassifiedPeriod
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /classifiedPeriod/upsert 			[get]
func UpsertClassifiedPeriod(c *gin.Context) {
	userID, _ := c.Get("userID")
	var classifiedPeriod models.ClassifiedPeriod
	var error = c.ShouldBindJSON(&classifiedPeriod)
	if error != nil {
		print(error.Error())
	}
	classifiedPeriod.UserId = userID.(int64)
	if databases.DB.Model(&classifiedPeriod).Where("uuid = ?", classifiedPeriod.Uuid).Updates(&classifiedPeriod).RowsAffected == 0 {
		databases.DB.Create(&classifiedPeriod)
	}
	c.JSON(200, classifiedPeriod)
}
