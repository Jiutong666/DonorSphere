/*
 * @author: biturd
 * @date: 2024/5/8 01:32
 * @description:
 */
package user

import (
	"backend/global"
	commonreq "backend/model/common/request"
	commonresp "backend/model/common/response"
	user "backend/service"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"net/http"
)

func Login(ctx *gin.Context) {
	req := &commonreq.LoginReq{}
	resp := &commonresp.LoginResp{}

	err := ctx.ShouldBindJSON(req)
	if err != nil {
		global.LOGGER.Info("login failed,bind json params failed", zap.Any("req", req))
		ctx.JSON(http.StatusBadRequest, resp)
		return
	}

	err = user.Login(req)
	if err != nil {
		global.LOGGER.Error("login logic failed", zap.Any("req", req), zap.Error(err))
		ctx.JSON(http.StatusBadRequest, resp)
	}

	ctx.JSON(http.StatusOK, resp)
}

func Register(ctx *gin.Context) {
	req := &commonreq.RegisterReq{}
	resp := &commonresp.RegisterResp{}

	err := ctx.ShouldBindJSON(req)
	if err != nil {
		global.LOGGER.Info("Register failed,bind json params failed", zap.Any("req", req))
		ctx.JSON(http.StatusBadRequest, resp)
		return
	}

	err = user.Register(req)
	if err != nil {
		global.LOGGER.Error("Register logic failed", zap.Any("req", req), zap.Error(err))
		ctx.JSON(http.StatusBadRequest, resp)
	}

	ctx.JSON(http.StatusOK, resp)
}
