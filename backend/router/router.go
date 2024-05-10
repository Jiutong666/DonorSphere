package router

import (
	"backend/api/v1/user"
	"github.com/gin-gonic/gin"
	"net/http"
)

func Router() *gin.Engine {

	r := gin.Default()

	r.NoRoute(func(ctx *gin.Context) {
		ctx.JSON(http.StatusOK, gin.H{
			"message": "404 PAGE NOT FOUND!",
		})
	})

	apiGroup := r.Group("/api/v1")

	// ApiGroup 前台路由组
	chaindrawApiGroup := apiGroup.Group("organization")
	{
		chaindrawApiGroup.POST("create")
	}

	// 用户逻辑相关 路由组
	userApiGroup := apiGroup.Group("user")
	{
		userApiGroup.POST("login", user.Login)
		userApiGroup.POST("register", user.Register)
	}

	return r
}
