package middleware

import (
	"errors"
	"fmt"
	"github.com/gin-gonic/gin"
	"net/http"
)

func AuthCheck(c *gin.Context) {
	userId, _ := c.Get("user_id")
	userName, _ := c.Get("user_name")
	fmt.Printf("user_id:%s,user_name:%s\n", userId, userName)
}

var token = "123456"

func TokenCheck(c *gin.Context) {
	accessToken := c.GetHeader("access_token")

	if accessToken != token {
		c.JSON(http.StatusUnauthorized, gin.H{
			"message": "token error",
		})
		c.AbortWithError(http.StatusInternalServerError, errors.New("token error"))
	}
	c.Set("user_name", "nick")
	c.Set("user_id", "1")
	c.Next()
}
