package controllers

import (
	"context"
	"main/controllers/dtos"
	"main/databases"
	"main/models"
	"os"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"googlemaps.github.io/maps"
)

func ErrorCheck(userID int64, err error) {
	if err != nil {
		googleErrorLog := models.GoogleErrorLog{UserId: userID, ErrorMsg: err.Error()}
		databases.DB.Create(&googleErrorLog)
	}
}

func GetPlaceFromLatLonRadius(c *gin.Context) {
	latInput, _ := strconv.ParseFloat(c.Param("lat"), 64)
	lonInput, _ := strconv.ParseFloat(c.Param("lng"), 64)
	var googlePlace dtos.GooglePlaceDTO
	var client *maps.Client
	apiKey := os.Getenv("google_maps_api_key")
	client, _ = maps.NewClient(maps.WithAPIKey(apiKey))

	r := &maps.NearbySearchRequest{
		Radius:   50,
		Location: &maps.LatLng{Lat: latInput, Lng: lonInput},
	}

	resp, _ := client.NearbySearch(context.Background(), r)
	var interests = []string{}

	if len(resp.Results) > 0 {
		googlePlace.Place = resp.Results[0].Name
	}

	for i := 0; i < len(resp.Results); i++ {
		interests = append(interests, resp.Results[i].Types...)
	}

	googlePlace.PointsOfInterest = interests

	c.JSON(200, googlePlace)
}

func GetPlaceDetailsByQuery(c *gin.Context) {
	query := c.Param("query")

	var client *maps.Client
	apiKey := os.Getenv("google_maps_api_key")
	client, _ = maps.NewClient(maps.WithAPIKey(apiKey))

	tr := &maps.TextSearchRequest{
		Query: query,
	}

	tresp, _ := client.TextSearch(context.Background(), tr)

	pr := &maps.PlaceDetailsRequest{
		PlaceID: tresp.Results[0].PlaceID,
	}

	presp, _ := client.PlaceDetails(context.Background(), pr)
	print(presp.Vicinity)

	c.JSON(200, presp)
}

func GetPlaceDetailsByLatLon(c *gin.Context) {
	latInput, _ := strconv.ParseFloat(c.Param("lat"), 64)
	lonInput, _ := strconv.ParseFloat(c.Param("lng"), 64)
	var resultTypes = []string{"street_address"}
	var googlePlace dtos.GooglePlaceDTO

	var client *maps.Client
	apiKey := os.Getenv("google_maps_api_key")
	client, _ = maps.NewClient(maps.WithAPIKey(apiKey))

	gr := &maps.GeocodingRequest{
		ResultType: resultTypes,

		LatLng: &maps.LatLng{Lat: latInput, Lng: lonInput},
	}

	gresp, _ := client.Geocode(context.Background(), gr)

	if len(gresp) == 0 {
		googlePlace.PointsOfInterest = []string{}
		c.JSON(200, googlePlace)
		return
	}

	pr := &maps.PlaceDetailsRequest{

		PlaceID: gresp[0].PlaceID,
	}

	presp, _ := client.PlaceDetails(context.Background(), pr)

	googlePlace.PointsOfInterest = presp.Types
	googlePlace.Place = presp.FormattedAddress
	c.JSON(200, googlePlace)
}

// GetLocationsFromQuery godoc
// @Summary      Gets locations from text query
// @Description  GET request for location strings based on search query
// @Tags         googleapi
// @Accept       json
// @Produce      json
// @Param        query   path	string  true	"Query"
// @Param        userID  header    string  true  "UserID"
// @Success      200  {array}  maps.PlacesSearchResult
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Security	 Authorization
// @Router       /googlesearch/textsearch/:query 			[get]
func GetLocationsFromQuery(c *gin.Context) {
	query := c.Param("query")
	userID, _ := c.Get("userID")

	if len(query) == 0 {
		c.JSON(200, []maps.PlacesSearchResult{})
		return
	}

	isAllowed := isAllowedQuery(c, query)

	if !isAllowed {
		c.JSON(200, []maps.PlacesSearchResult{})
		return
	}

	var client *maps.Client
	var err error
	apiKey := os.Getenv("google_maps_api_key")
	client, err = maps.NewClient(maps.WithAPIKey(apiKey))
	ErrorCheck(userID.(int64), err)

	r := &maps.TextSearchRequest{
		Query: query,
	}

	resp, err := client.TextSearch(context.Background(), r)
	ErrorCheck(userID.(int64), err)

	var googleMaps []dtos.GoogleMapsDTO
	var nameString string
	for _, element := range resp.Results {
		if element.Name != "" {
			nameString = element.Name + "," + element.FormattedAddress
		} else {
			nameString = element.FormattedAddress
		}
		googleMaps = append(googleMaps, dtos.GoogleMapsDTO{PlaceId: element.PlaceID, Lat: element.Geometry.Location.Lat, Lon: element.Geometry.Location.Lng, DisplayName: nameString, Address: element.FormattedAddress})
	}

	c.JSON(200, googleMaps)
}

// GetLocationsFromQueryRadius godoc
// @Summary      Gets prioritized locations from text query and position
// @Description  GET request for location strings based on search query and latlon of user
// @Tags         googleapi
// @Accept       json
// @Produce      json
// @Param        userID  header    string  true  "UserID"
// @Param        query   path	string  true	"Query"
// @Param        lat   path	string  true	"Latitude"
// @Param        lng   path	string  true	"Longitude"
// @Success      200  {array}  maps.PlacesSearchResult
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Security	 Authorization
// @Router       /googlesearch/textsearch/:query/:lat/:lng			[get]
func GetLocationsFromQueryRadius(c *gin.Context) {
	query := c.Param("query")
	userID, _ := c.Get("userID")
	latInput, _ := strconv.ParseFloat(c.Param("lat"), 64)
	lonInput, _ := strconv.ParseFloat(c.Param("lng"), 64)

	if len(query) == 0 {
		c.JSON(200, []maps.PlacesSearchResult{})
		return
	}

	isAllowed := isAllowedQueryLatLon(c, query, latInput, lonInput)

	if !isAllowed {
		c.JSON(200, []maps.PlacesSearchResult{})
		return
	}

	var client *maps.Client
	var err error
	apiKey := os.Getenv("google_maps_api_key")
	client, err = maps.NewClient(maps.WithAPIKey(apiKey))
	ErrorCheck(userID.(int64), err)

	r := &maps.TextSearchRequest{
		Query:    query,
		Radius:   25000,
		Location: &maps.LatLng{Lat: latInput, Lng: lonInput},
	}

	resp, err := client.TextSearch(context.Background(), r)
	ErrorCheck(userID.(int64), err)

	var googleMaps []dtos.GoogleMapsDTO
	var nameString string
	for _, element := range resp.Results {
		if element.Name != "" {
			nameString = element.Name + "," + element.FormattedAddress
		} else {
			nameString = element.FormattedAddress
		}
		googleMaps = append(googleMaps, dtos.GoogleMapsDTO{PlaceId: element.PlaceID, Lat: element.Geometry.Location.Lat, Lon: element.Geometry.Location.Lng, DisplayName: nameString, Address: element.FormattedAddress})
	}

	c.JSON(200, googleMaps)
}

// GetAddressFromLatLng godoc
// @Summary      Gets closest address based on location
// @Description  GET request for closest address based on location latlon
// @Tags         googleapi
// @Accept       json
// @Produce      json
// @Param        userID  header    string  true  "UserID"
// @Param        lat   path	string  true	"Latitude"
// @Param        lng   path	string  true	"Longitude"
// @Success      200  {array}  maps.PlacesSearchResult
// @Failure      400  {object}  models.ErrorLog
// @Failure      404  {object}  models.ErrorLog
// @Security	 Authorization
// @Router       /googlesearch/geosearch/:lat/:lng			[get]
func GetAddressFromLatLng(c *gin.Context) {
	userID, _ := c.Get("userID")
	latInput, _ := strconv.ParseFloat(c.Param("lat"), 64)
	lonInput, _ := strconv.ParseFloat(c.Param("lng"), 64)
	var resultTypes = []string{"street_address"}

	isAllowed := isAllowedLatLng(c, latInput, lonInput)

	// TODO: this should return an error code (ratelimit reached) instead of an empty list
	if !isAllowed {
		c.JSON(200, []maps.PlacesSearchResult{})
		return
	}

	var client *maps.Client
	var err error
	apiKey := os.Getenv("google_maps_api_key")
	client, err = maps.NewClient(maps.WithAPIKey(apiKey))
	ErrorCheck(userID.(int64), err)

	r := &maps.GeocodingRequest{
		ResultType: resultTypes,
		LatLng:     &maps.LatLng{Lat: latInput, Lng: lonInput},
	}

	resp, err := client.Geocode(context.Background(), r)
	ErrorCheck(userID.(int64), err)

	var googleMaps []dtos.GoogleMapsDTO

	// TODO: this should return an error code (no google api result) instead of an empty list
	if len(resp) == 0 {
		c.JSON(200, []maps.PlacesSearchResult{})
		return
	}

	for _, element := range resp {
		googleMaps = append(googleMaps, dtos.GoogleMapsDTO{PlaceId: element.PlaceID, Lat: element.Geometry.Location.Lat, Lon: element.Geometry.Location.Lng, DisplayName: element.FormattedAddress, Address: element.FormattedAddress})
	}

	c.JSON(200, googleMaps)
}

func isAllowedQuery(c *gin.Context, query string) bool {
	counter := 500
	userID, _ := c.Get("userID")
	hourInMilliseconds := 3600 * 1000
	now := (time.Now().Unix() * 1000) - int64(hourInMilliseconds)

	//check counter
	amountUsed := 0

	databases.DB.Table("google_logs").Where("google_logs.user_id = ?", userID).Where("google_logs.date_time > ?", now).Count(&amountUsed)
	isAllowed := amountUsed < counter

	//insert log
	googleLog := models.GoogleLog{Query: query, UserId: userID.(int64), Request: c.FullPath(), DateTime: now, WasAllowed: isAllowed}
	databases.DB.Create(&googleLog)

	//return if was allowed
	return isAllowed
}

func isAllowedQueryLatLon(c *gin.Context, query string, lat float64, lon float64) bool {
	counter := 500
	userID, _ := c.Get("userID")
	hourInMilliseconds := 3600 * 1000
	now := (time.Now().Unix() * 1000) - int64(hourInMilliseconds)

	//check counter
	amountUsed := 0

	databases.DB.Table("google_logs").Where("google_logs.user_id = ?", userID).Where("google_logs.date_time > ?", now).Count(&amountUsed)
	isAllowed := amountUsed < counter

	//insert log
	googleLog := models.GoogleLog{Query: query, Lat: lat, Lon: lon, UserId: userID.(int64), Request: c.FullPath(), DateTime: now, WasAllowed: isAllowed}
	databases.DB.Create(&googleLog)

	//return if was allowed
	return isAllowed
}

func isAllowedLatLng(c *gin.Context, lat float64, lon float64) bool {
	counter := 500
	userID, _ := c.Get("userID")
	hourInMilliseconds := 3600 * 1000
	now := (time.Now().Unix() * 1000) - int64(hourInMilliseconds)

	//check counter
	amountUsed := 0

	databases.DB.Table("google_logs").Where("google_logs.user_id = ?", userID).Where("google_logs.date_time > ?", now).Count(&amountUsed)
	isAllowed := amountUsed < counter

	//insert log
	googleLog := models.GoogleLog{Lat: lat, Lon: lon, UserId: userID.(int64), Request: c.FullPath(), DateTime: now, WasAllowed: isAllowed}
	databases.DB.Create(&googleLog)

	//return if was allowed
	return isAllowed
}
