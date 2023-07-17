package models

import (
	"main/databases"
	"time"

	"github.com/jinzhu/gorm"
	"golang.org/x/crypto/bcrypt"
)

type User struct {
	gorm.Model

	Username    string
	Email       string
	Password    string
	Attempts    int64
	LastAttempt time.Time
}

// CreateUserRecord creates a user record in the database
func (user *User) CreateUserRecord() error {
	result := databases.DB.Create(&user)
	if result.Error != nil {
		return result.Error
	}

	return nil
}

// HashPassword encrypts user password
func (user *User) HashPassword(password string) error {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), 14)
	if err != nil {
		return err
	}

	user.Password = string(bytes)

	return nil
}

// CheckPassword checks user password
func (user *User) CheckPassword(providedPassword string) error {
	err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(providedPassword))
	if err != nil {
		return err
	}

	return nil
}

// CreateUserRecord creates a user record in the database
func (user *User) UpdateLoginAttempts() error {
	result := databases.DB.Save(&user)

	if result.Error != nil {
		return result.Error
	}

	return nil
}
