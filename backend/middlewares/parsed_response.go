package middlewares

import (
	"encoding/json"
	"main/controllers/dtos"

	"github.com/gin-gonic/gin"
)

type responseBodyWriter struct {
	gin.ResponseWriter
	ApiResponse dtos.ApiResponse
}

func (r responseBodyWriter) Write(b []byte) (int, error) {
	r.ApiResponse.Body = string(b)
	response, _ := json.Marshal(r.ApiResponse)
	return r.ResponseWriter.Write(response)
}

func LogResponseBody(c *gin.Context) {
	apiResponse := dtos.ApiResponse{
		ErrorMessages: "",
	}

	w := &responseBodyWriter{ApiResponse: apiResponse, ResponseWriter: c.Writer}
	c.Writer = w
	c.Next()
}
