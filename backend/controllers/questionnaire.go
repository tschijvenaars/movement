package controllers

import (
	"main/databases"
	"main/models"

	"github.com/gin-gonic/gin"
)

// AddQuestionnaire godoc
// @Summary      Posts questionnaire to database
// @Description  Posts questionnaire to database
// @Tags         questionnaire
// @Accept       json
// @Produce      json
// @Success      200  {object}  models.Questionnaire
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Router       /addQuestionnaire 			[get]
func AddQuestionnaire(c *gin.Context) {
	userID, _ := c.Get("userID")

	var questionnaire models.Questionnaire
	var error = c.ShouldBindJSON(&questionnaire)
	if error != nil {
		print(error.Error())
	}

	questionnaire.UserId = userID.(int64)

	databases.DB.Omit("id").Create(&questionnaire)
	c.JSON(200, questionnaire)
}
