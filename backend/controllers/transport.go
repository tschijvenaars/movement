package controllers

import (
	"main/databases"
	"main/models"

	"github.com/gin-gonic/gin"
)

// GetTransports godoc
// @Summary      Gets transports
// @Description  Get transports from database
// @Tags         transport
// @Accept       json
// @Produce      json
// @Success      200  {array}   models.Transport
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /transports		[get]
func GetTransports(c *gin.Context) {
	var transports []models.Transport

	databases.DB.Table("transports").Find(&transports)
	c.JSON(200, transports)
}
