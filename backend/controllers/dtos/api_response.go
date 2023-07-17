package dtos

type ApiResponse struct {
	Body          string
	InfoMessages  []string
	ErrorMessages string
	DebugMessages []string
}
