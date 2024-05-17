package project

import (
	"backend/global"
	commonreq "backend/model/common/request"
	commonresp "backend/model/common/response"
	sevice "backend/service"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

func Create(ctx *gin.Context) {
	req := &commonreq.Project{}
	err := ctx.ShouldBindJSON(req)
	if err != nil {
		global.LOGGER.Info("CreateProject failed,bind json params failed", zap.Any("req", req))
		commonresp.FailWithMessage(ctx, "绑定JSON参数失败")
		return
	}
	err = sevice.AddProject(req)
	if err != nil {
		global.LOGGER.Error("LotteryRecordAdd logic failed", zap.Any("req", req), zap.Error(err))
		commonresp.FailWithMessage(ctx, err.Error())
	}
	commonresp.Ok(ctx)
}
