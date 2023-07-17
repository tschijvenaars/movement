package dtos

import "main/models"

type UserDeviceDTO struct {
	User   models.User
	Device models.Device
}
