package controllers

import (
	"main/controllers/dtos"
	"main/databases"
	"main/models"
	"time"

	"github.com/gin-gonic/gin"
)

func SyncTracked(c *gin.Context) {
	var tracker models.TrackedDay
	var error = c.ShouldBindJSON(&tracker)
	if error != nil {
		print(error.Error())
	}

	databases.DB.Create(&tracker)
	c.JSON(200, tracker)
}

// SyncInsertedTrackedDay godoc
// @Summary      Insert Tracked Day
// @Description  POST request to insert tracked day into database
// @Tags         trackedday
// @Accept       json
// @Produce      json
// @Param        userID  header    string  true  "UserID"
// @Success      200  {object}  dtos.TrackedDayDTO
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Security	 Authorization
// @Router       /tracked/insertTrackedDay 			[post]
func SyncInsertedTrackedDay(c *gin.Context) {
	var dto dtos.TrackedDayDTO
	var error = c.ShouldBindJSON(&dto)
	if error != nil {
		print(error.Error())
	}

	userID, _ := c.Get("userID")

	var trackedDay models.TrackedDay
	trackedDay.ChoiceId = dto.ChoiceId
	trackedDay.ChoiceText = dto.ChoiceText
	trackedDay.Confirmed = dto.Confirmed
	trackedDay.Day = dto.Day
	trackedDay.Uuid = dto.Uuid
	trackedDay.UserId = userID.(int64)

	databases.DB.Create(&trackedDay)
	c.JSON(200, dto)
}

// SyncUpdatedTrackedDay godoc
// @Summary      Update Tracked Day
// @Description  POST request to update tracked day in database
// @Tags         trackedday
// @Accept       json
// @Produce      json
// @Param        userID  header    string  true  "UserID"
// @Success      200  {object}  dtos.TrackedDayDTO
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Security	 Authorization
// @Router       /tracked/updateTrackedDay 			[post]
func SyncUpdatedTrackedDay(c *gin.Context) {
	var dto dtos.TrackedDayDTO
	var error = c.ShouldBindJSON(&dto)
	if error != nil {
		print(error.Error())
	}

	userID, _ := c.Get("userID")

	var trackedDay models.TrackedDay
	databases.DB.Find(&trackedDay, models.TrackedDay{Uuid: dto.Uuid, UserId: userID.(int64)})

	trackedDay.ChoiceId = dto.ChoiceId
	trackedDay.ChoiceText = dto.ChoiceText
	trackedDay.Confirmed = dto.Confirmed

	if trackedDay.ID == 0 {
		databases.DB.Create(&trackedDay)
	} else {
		databases.DB.Model(&trackedDay).Update(trackedDay)
	}

	c.JSON(200, dto)
}

// SyncInsertedTrackedLocation godoc
// @Summary      Insert Tracked Location
// @Description  POST request to insert tracked location in database
// @Tags         trackedlocation
// @Accept       json
// @Produce      json
// @Param        userID  header    string  true  "UserID"
// @Success      200  {object}  dtos.TrackedLocationDTO
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Security	 Authorization
// @Router       /tracked/insertTrackedLocation 			[post]
func SyncInsertedTrackedLocation(c *gin.Context) {
	var locationDTO dtos.TrackedLocationDTO

	var error = c.ShouldBindJSON(&locationDTO)

	if error != nil {
		print(error.Error())
	}

	userID, _ := c.Get("userID")

	var trackedLocation models.TrackedLocation
	trackedLocation.TrackedDayId = locationDTO.TrackedDayId
	trackedLocation.TrackedLocationPhoneId = locationDTO.Id
	trackedLocation.Confirmed = locationDTO.Confirmed
	trackedLocation.StartTime = locationDTO.StartTime
	trackedLocation.EndTime = locationDTO.EndTime
	trackedLocation.Lat = locationDTO.Lat
	trackedLocation.Lon = locationDTO.Lon
	trackedLocation.Name = locationDTO.Name
	trackedLocation.ReasonId = locationDTO.ReasonId
	trackedLocation.UserId = userID.(int64)

	if trackedLocation.ID == 0 {
		databases.DB.Create(&trackedLocation)
	} else {
		databases.DB.Model(&trackedLocation).Update(trackedLocation)
	}
	c.JSON(200, locationDTO)
}

// SyncUpdatedTrackedLocation godoc
// @Summary      Update Tracked Location
// @Description  POST request to update tracked location in database
// @Tags         trackedlocation
// @Accept       json
// @Produce      json
// @Param        userID  header    string  true  "UserID"
// @Success      200  {object}  dtos.TrackedLocationDTO
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Security	 Authorization
// @Router       /tracked/updateTrackedLocation 			[post]
func SyncUpdatedTrackedLocation(c *gin.Context) {
	var locationDTO dtos.TrackedLocationDTO

	var error = c.ShouldBindJSON(&locationDTO)

	if error != nil {
		print(error.Error())
	}

	userID, _ := c.Get("userID")

	var trackedLocation models.TrackedLocation
	databases.DB.Find(&trackedLocation, models.TrackedLocation{TrackedLocationPhoneId: locationDTO.Id, UserId: userID.(int64)})

	trackedLocation.TrackedDayId = locationDTO.TrackedDayId
	trackedLocation.TrackedLocationPhoneId = locationDTO.Id
	trackedLocation.Confirmed = locationDTO.Confirmed
	trackedLocation.StartTime = locationDTO.StartTime
	trackedLocation.EndTime = locationDTO.EndTime
	trackedLocation.Lat = locationDTO.Lat
	trackedLocation.Lon = locationDTO.Lon
	trackedLocation.Name = locationDTO.Name
	trackedLocation.ReasonId = locationDTO.ReasonId

	if trackedLocation.ID == 0 {
		databases.DB.Create(&trackedLocation)
	} else {
		databases.DB.Model(&trackedLocation).Update(trackedLocation)
	}
	c.JSON(200, locationDTO)
}

// SyncDeleteTrackedLocation godoc
// @Summary      Delete Tracked Location
// @Description  POST request to delete tracked location in database
// @Tags         trackedlocation
// @Accept       json
// @Produce      json
// @Param        userID  header    string  true  "UserID"
// @Success      200  {object}  dtos.TrackedLocationDTO
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Security	 Authorization
// @Router       /tracked/deleteTrackedLocation 			[post]
func SyncDeleteTrackedLocation(c *gin.Context) {
	var locationDTO dtos.TrackedLocationDTO

	var error = c.ShouldBindJSON(&locationDTO)

	if error != nil {
		print(error.Error())
	}

	userID, _ := c.Get("userID")

	var trackedLocation models.TrackedLocation
	databases.DB.Find(&trackedLocation, models.TrackedLocation{TrackedLocationPhoneId: locationDTO.Id, UserId: userID.(int64)})

	trackedLocation.Deleted = time.Now().UnixNano() / 1000000

	if trackedLocation.ID == 0 {
		databases.DB.Create(&trackedLocation)
	} else {
		databases.DB.Model(&trackedLocation).Update(trackedLocation)
	}
	c.JSON(200, locationDTO)
}

// SyncInsertedTrackedMovement godoc
// @Summary      Insert Tracked Movement
// @Description  POST request to insert tracked movement in database
// @Tags         trackedmovement
// @Accept       json
// @Produce      json
// @Param        userID  header    string  true  "UserID"
// @Success      200  {object}  dtos.TrackedMovementDTO
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Security	 Authorization
// @Router       /tracked/insertTrackedMovement 			[post]
func SyncInsertedTrackedMovement(c *gin.Context) {
	var dto dtos.TrackedMovementDTO
	var error = c.ShouldBindJSON(&dto)
	if error != nil {
		print(error.Error())
	}

	userID, _ := c.Get("userID")

	var trackedMovement models.TrackedMovement
	trackedMovement.Confirmed = dto.Confirmed
	trackedMovement.StartTime = dto.StartTime
	trackedMovement.EndTime = dto.EndTime
	trackedMovement.MovementCategoryId = dto.MovementCategoryId
	trackedMovement.TrackedLocationId = dto.TrackedLocationId
	trackedMovement.TrackedMovementId = dto.Id
	trackedMovement.UserId = userID.(int64)

	if trackedMovement.ID == 0 {
		databases.DB.Create(&trackedMovement)
	} else {
		databases.DB.Model(&trackedMovement).Update(trackedMovement)
	}
	c.JSON(200, dto)
}

// SyncUpdatedTrackedMovement godoc
// @Summary      Update Tracked Movement
// @Description  POST request to update tracked movement in database
// @Tags         trackedmovement
// @Accept       json
// @Produce      json
// @Param        userID  header    string  true  "UserID"
// @Success      200  {object}  dtos.TrackedMovementDTO
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Security	 Authorization
// @Router       /tracked/updateTrackedMovement 			[post]
func SyncUpdatedTrackedMovement(c *gin.Context) {
	var dto dtos.TrackedMovementDTO
	var error = c.ShouldBindJSON(&dto)
	if error != nil {
		print(error.Error())
	}

	userID, _ := c.Get("userID")

	var trackedMovement models.TrackedMovement
	databases.DB.Find(&trackedMovement, models.TrackedMovement{TrackedMovementId: dto.Id, UserId: userID.(int64)})
	trackedMovement.Confirmed = dto.Confirmed
	trackedMovement.StartTime = dto.StartTime
	trackedMovement.EndTime = dto.EndTime
	trackedMovement.MovementCategoryId = dto.MovementCategoryId
	trackedMovement.TrackedLocationId = dto.TrackedLocationId

	if trackedMovement.ID == 0 {
		databases.DB.Create(&trackedMovement)
	} else {
		databases.DB.Model(&trackedMovement).Update(trackedMovement)
	}
	c.JSON(200, dto)
}

// SyncDeletedTrackedMovement godoc
// @Summary      Delete Tracked Movement
// @Description  POST request to delete tracked movement from database
// @Tags         trackedmovement
// @Accept       json
// @Produce      json
// @Param        userID  header    string  true  "UserID"
// @Success      200  {object}  dtos.TrackedMovementDTO
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Security	 Authorization
// @Router       /tracked/deleteTrackedMovement 			[post]
func SyncDeletedTrackedMovement(c *gin.Context) {
	var dto dtos.TrackedMovementDTO

	var error = c.ShouldBindJSON(&dto)

	if error != nil {
		print(error.Error())
	}

	userID, _ := c.Get("userID")

	var trackedMovement models.TrackedMovement
	databases.DB.Find(&trackedMovement, models.TrackedMovement{TrackedMovementId: dto.Id, UserId: userID.(int64)})

	trackedMovement.Deleted = time.Now().UnixNano() / 1000000

	if trackedMovement.ID == 0 {
		databases.DB.Create(&trackedMovement)
	} else {
		databases.DB.Model(&trackedMovement).Update(trackedMovement)
	}
	c.JSON(200, dto)
}

// SyncInsertedTrackedLatLon godoc
// @Summary      Insert Tracked LatLon
// @Description  POST request to insert tracked latlon in database
// @Tags         trackedmovement
// @Accept       json
// @Produce      json
// @Param        userID  header    string  true  "UserID"
// @Success      200  {object}  dtos.TrackedMovementLatLonDTO
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Security	 Authorization
// @Router       /tracked/insertTrackedMovementLatLon 			[post]
func SyncInsertedTrackedLatLon(c *gin.Context) {
	var dto dtos.TrackedMovementLatLonDTO
	var error = c.ShouldBindJSON(&dto)
	if error != nil {
		print(error.Error())
	}

	userID, _ := c.Get("userID")

	var trackedLatLon models.TrackedLatLon
	trackedLatLon.UserId = userID.(int64)
	trackedLatLon.Lat = dto.Lat
	trackedLatLon.Lon = dto.Lon
	trackedLatLon.MappedDate = dto.MappedDate
	trackedLatLon.TrackedMovementid = dto.TrackedMovementId
	trackedLatLon.TrackedLatLonId = dto.Id

	databases.DB.Create(&trackedLatLon)
	c.JSON(200, dto)
}

// SyncUpdatedTrackedLatLon godoc
// @Summary      Update Tracked LatLon
// @Description  POST request to update tracked latlon in database
// @Tags         trackedmovement
// @Accept       json
// @Produce      json
// @Param        userID  header    string  true  "UserID"
// @Success      200  {object}  dtos.TrackedMovementLatLonDTO
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Security	 Authorization
// @Router       /tracked/updateTrackedMovementLatLon 			[post]
func SyncUpdatedTrackedLatLon(c *gin.Context) {
	var dto dtos.TrackedMovementLatLonDTO
	var error = c.ShouldBindJSON(&dto)
	if error != nil {
		print(error.Error())
	}

	userID, _ := c.Get("userID")

	var trackedLatLon models.TrackedLatLon
	trackedLatLon.UserId = userID.(int64)
	trackedLatLon.Lat = dto.Lat
	trackedLatLon.Lon = dto.Lon
	trackedLatLon.MappedDate = dto.MappedDate
	trackedLatLon.TrackedMovementid = dto.TrackedMovementId
	trackedLatLon.TrackedLatLonId = dto.Id

	if trackedLatLon.ID == 0 {
		databases.DB.Create(&trackedLatLon)
	} else {
		databases.DB.Model(&trackedLatLon).Update(trackedLatLon)
	}
	c.JSON(200, dto)
}
