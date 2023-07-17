package controllers

import (
	"main/databases"
	"main/models"

	"github.com/gin-gonic/gin"
)

// GetReasons godoc
// @Summary      Gets reasons
// @Description  Gets reasons from database
// @Tags         reasons
// @Accept       json
// @Produce      json
// @Success      200  {array}   models.Reason
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /reasons			[get]
func GetReasons(c *gin.Context) {
	var reasons []models.Reason

	databases.DB.Table("reasons").Find(&reasons)
	c.JSON(200, reasons)
}
