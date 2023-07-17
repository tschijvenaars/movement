package models

import (
	"github.com/jinzhu/gorm"
)

type Kpi struct {
	gorm.Model

	UserTotal         int
	UserUnused        int
	TotalLocationsDay int
	TotalLocations    int
}
