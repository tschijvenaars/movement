package controllers

import (
	"fmt"
	"log"
	"main/auth"
	"main/controllers/dtos"
	"main/databases"
	"main/models"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
)

func Signup(c *gin.Context) {
	var user models.User
	user.Attempts = 0

	err := c.ShouldBindJSON(&user)
	if err != nil {
		log.Println(err)

		c.JSON(400, gin.H{
			"msg": "invalid json",
		})
		c.Abort()

		return
	}

	err = user.HashPassword(user.Password)
	if err != nil {
		log.Println(err.Error())

		c.JSON(500, gin.H{
			"msg": "error hashing password",
		})
		c.Abort()

		return
	}

	err = user.CreateUserRecord()
	if err != nil {
		log.Println(err)

		c.JSON(500, gin.H{
			"msg": "error creating user",
		})
		c.Abort()

		return
	}

	c.JSON(200, user)
}

// Login logs users in

// Login godoc
// @Summary      Login for users
// @Description  Checks usercredentials and logs in, returns token for authorized User
// @Tags         auth
// @Accept       json
// @Produce      json
// @Success      200  {object}  dtos.LoginResponse
// @Param        payload   body	dtos.LoginPayload  true	"Payload"
// @Param        user   body	models.User  true		"User"
// @Failure      400  {string}  string					"invalid json"
// @Failure      401  {string}	string					"invalid user credentials"
// @Failure      404  {object}  models.ErrorLog
// @Failure      500  {string}	string					"error signing token"
// @Router       /login 			[post]
func Login(c *gin.Context) {
	var payload dtos.LoginPayload
	var user models.User

	err := c.ShouldBindJSON(&payload)
	if err != nil {
		c.JSON(400, gin.H{
			"ErrorMessages": "invalid json",
		})
		c.Abort()
		return
	}

	result := databases.DB.Where("username = ?", payload.Username).First(&user)

	if result.Error == gorm.ErrRecordNotFound {
		c.JSON(401, gin.H{
			"ErrorMessages": "invalid username",
			"InfoMessages":  "false,false," + fmt.Sprint(time.Now()) + "," + fmt.Sprint(user.Attempts),
		})
		c.Abort()
		return
	}

	if !passwordCheck(c, user, payload) {
		return
	}

	jwtWrapper := auth.JwtWrapper{
		SecretKey:       "verysecretkey",
		Issuer:          "AuthService",
		ExpirationHours: 300,
	}

	signedToken, err := jwtWrapper.GenerateToken(int64(user.ID))
	if err != nil {
		log.Println(err)
		c.JSON(500, gin.H{
			"ErrorMessages": "error signing token",
		})
		c.Abort()
		return
	}

	user.Attempts = 0
	user.LastAttempt = time.Now()
	user.UpdateLoginAttempts()

	tokenResponse := dtos.LoginResponse{
		Token: signedToken,
	}

	c.JSON(200, tokenResponse)
}

func Test(c *gin.Context) {
	email, _ := c.Get("username") // from the authorization middleware

	c.JSON(200, email)
}

func inTimeSpan(start, end, check time.Time) bool {
	if start.Before(end) {
		return !check.Before(start) && !check.After(end)
	}
	if start.Equal(end) {
		return check.Equal(start)
	}
	return !start.After(check) || !end.Before(check)
}

func sendJsonInfomessage(c *gin.Context, user models.User, isTimeLocked bool) {
	c.JSON(401, gin.H{
		"ErrorMessages": "password incorrect",
		"InfoMessages":  "true," + fmt.Sprint(isTimeLocked) + "," + fmt.Sprint(user.LastAttempt) + "," + fmt.Sprint(time.Now()) + "," + fmt.Sprint(user.Attempts), //usernameFound, isLocked, lastAttempt, Attempts
	})
	c.Abort()
}

func passwordCheck(c *gin.Context, user models.User, payload dtos.LoginPayload) bool {
	if user.Attempts >= 3 {
		if inTimeSpan(user.LastAttempt, user.LastAttempt.Add(time.Second*60), time.Now()) {
			sendJsonInfomessage(c, user, true)
			return false
		} else {
			err := user.CheckPassword(payload.Password)
			if err != nil {
				user.Attempts++
				user.LastAttempt = time.Now()
				user.UpdateLoginAttempts()
				log.Println(err)
				sendJsonInfomessage(c, user, true)
				return false
			}
		}
	} else {
		err := user.CheckPassword(payload.Password)
		if err != nil {
			user.Attempts++
			user.LastAttempt = time.Now()
			user.UpdateLoginAttempts()
			log.Println(err)
			sendJsonInfomessage(c, user, false)
			c.Abort()
			return false
		}
	}
	return true
}
