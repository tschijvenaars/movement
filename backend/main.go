package main

import (
	"main/controllers"
	"main/databases"
	"main/middlewares"
	"main/models"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/rs/cors"

	ginSwagger "github.com/swaggo/gin-swagger"
	"github.com/swaggo/gin-swagger/swaggerFiles"

	_ "main/docs"
)

func sayHello(c *gin.Context) {
	c.JSON(200, gin.H{
		"hello": "privationel",
	})
}

// @title           CBS Backend Swagger server
// @version         1.0
// @description     CBS Swagger backend server.
// @termsOfService  http://swagger.io/terms/

// @contact.name   API Support
// @contact.url    http://www.swagger.io/support
// @contact.email  support@swagger.io

// @license.name  Apache 2.0
// @license.url   http://www.apache.org/licenses/LICENSE-2.0.html

// @host      localhost:8000
// @BasePath  /api

// @securitydefinitions.basic BasicAuthorization
// @authorizationurl http://localhost:8000/api/login
// @in header
// @name Authorization
// run: swag init --parseDependency --parseInternal
func main() {
	databases.InitializeDatabase()

	router := gin.Default()

	router.GET("/ping", func(c *gin.Context) {
		c.String(200, "pong")
	})

	router.GET("/", sayHello)

	api := router.Group("/api")
	{
		public := api.Group("").Use(middlewares.LogResponseBody)
		{

			public.POST("/login", controllers.Login)
			public.POST("/signup", controllers.Signup)

			//devices
			public.GET("/devices", controllers.GetDevices)
			public.GET("/devices/bySecureId/{secureId}", controllers.GetDeviceBySecureId)
			public.PUT("/device", controllers.UpdateDevice)

			//locations
			public.GET("/locations/getLatest/{secureId}", controllers.GetLatestLocations)
			public.GET("/locations/GetLatestLocationsPeriods/{secureId}", controllers.GetLatestLocationsPeriods)

			//trackers
			public.POST("/trackers", controllers.SyncTrackers)
			public.GET("/trackers/getLatest/{secureId}", controllers.GetLatestTrackers)
			public.GET("/trackers/GetLatestTrackersPeriods/{secureId}", controllers.GetLatestTrackersPeriods)

			//transport
			public.GET("/transports", controllers.GetTransports)

			//reasons
			public.GET("/reasons", controllers.GetReasons)

			public.GET("/verificationdata/users", controllers.GetUsers)
			public.GET("/verificationdata/user/:userId", controllers.GetUser)
			public.GET("/verificationdata/deleteTrackedDays/:userId", controllers.DeleteTrackedDaysUser)
			public.GET("/verificationdata/syncdays", controllers.SyncDate)

			//test cases data
			public.GET("/testcasedata", controllers.GetTestCaseData)
			public.GET("/testcasedata/shallow", controllers.GetShallowTestCaseData)
			public.GET("/testcasedata/details/:dayId/:userId", controllers.GetTestCase)
			public.GET("/testcasedata/users", controllers.GetUserTestCaseData)
			public.GET("/testcasedata/getUserSensorGeolocationData", controllers.GetUserSensorGeolocationData)

			//google test
			public.GET("/googlesearch/query/:query", controllers.GetPlaceDetailsByQuery)
			public.GET("/googlesearch/place/:lat/:lng", controllers.GetPlaceDetailsByLatLon)
			public.GET("/googlesearch/radius/:lat/:lng", controllers.GetPlaceFromLatLonRadius)
		}

		// here
		protected := api.Group("").Use(middlewares.Authz()).Use(middlewares.LogResponseBody)
		{
			//test
			protected.GET("/test", controllers.Test)

			//device
			protected.POST("/device", controllers.CreateDevice)

			//monitoring
			protected.GET("/devicesMonitoring", controllers.GetDevicesForMonitoring)
			protected.GET("/syncMonitoring", controllers.GetDataForMonitoring)
			protected.GET("/logsMonitoring", controllers.GetLogs)
			protected.GET("/errorMonitoring", controllers.GetErrorLogs)
			protected.GET("/googleErrorMonitoring", controllers.GetGoogleErrorLogs)
			protected.GET("/unusedUsernames", controllers.GetUnusedUsernames)
			protected.GET("/getKPIs", controllers.GetStats)
			protected.GET("/deleteTrackedDays/:userId", controllers.DeleteTrackedDaysUser)

			//tracked
			protected.POST("/tracked/insertTrackedDay", controllers.SyncInsertedTrackedDay)
			protected.POST("/tracked/updateTrackedDay", controllers.SyncUpdatedTrackedDay)

			protected.POST("/tracked/insertTrackedLocation", controllers.SyncInsertedTrackedLocation)
			protected.POST("/tracked/updateTrackedLocation", controllers.SyncUpdatedTrackedLocation)
			protected.POST("/tracked/deleteTrackedLocation", controllers.SyncDeleteTrackedLocation)

			protected.POST("/tracked/insertTrackedMovement", controllers.SyncInsertedTrackedMovement)
			protected.POST("/tracked/updateTrackedMovement", controllers.SyncUpdatedTrackedMovement)
			protected.POST("/tracked/deleteTrackedMovement", controllers.SyncDeletedTrackedMovement)

			protected.POST("/tracked/insertTrackedMovementLatLon", controllers.SyncInsertedTrackedLatLon)
			protected.POST("/tracked/updateTrackedMovementLatLon", controllers.SyncUpdatedTrackedLatLon)

			// Google Maps Tunnel
			protected.GET("/googlesearch/textsearch/:query", controllers.GetLocationsFromQuery)
			protected.GET("/googlesearch/textsearch/:query/:lat/:lng", controllers.GetLocationsFromQueryRadius)
			protected.GET("/googlesearch/geosearch/:lat/:lng", controllers.GetAddressFromLatLng)

			// Questionnaire
			protected.POST("/addQuestionnaire", controllers.AddQuestionnaire)

			// Syncing
			protected.POST("/syncing/AddGeoLocation", controllers.InsertSensorGeolocation) // Deprecated as of 2 Nov 2022
			protected.POST("/sensorGeolocation/bulkInsert", controllers.BulkInsertSensorGeolocation)
			
			protected.POST("/classifiedPeriod/upsert", controllers.UpsertClassifiedPeriod)
			protected.POST("/stop/upsert", controllers.UpsertStop)
			protected.POST("/movement/upsert", controllers.UpsertMovement)
			protected.POST("/manualGeolocation/upsert", controllers.UpsertManualGeolocation)
			protected.POST("/googlesearch/upsert", controllers.UpsertGoogleMapsData)

			//logs
			protected.POST("/logs", controllers.SyncLogs)
			protected.POST("/logs/syncLogs", controllers.SyncLogs)
		}
	}

	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"http://localhost:4200"},
		AllowCredentials: true,
	})

	databases.DB.AutoMigrate(&models.Device{}, &models.ErrorLog{}, &models.Log{}, &models.Tracker{}, &models.Location{}, &models.User{}, &models.Transport{}, &models.Reason{}, &models.TrackedDay{}, &models.GoogleLog{}, &models.GoogleErrorLog{}, &models.Questionnaire{}, &models.SensorGeolocation{}, &models.Stop{}, &models.ClassifiedPeriod{}, &models.Movement{}, &models.ManualGeolocation{}, &models.GoogleMapsData{})

	handler := c.Handler(router)

	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	http.ListenAndServe(":8000", handler)
}
