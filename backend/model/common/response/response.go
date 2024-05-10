package commonresp

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type Response struct {
	Code    int         `json:"code"`
	Message string      `json:"message"`
	Data    interface{} `json:"data"`
}

// 默认的成功和失败响应码
// 更多响应码存放于 global/biz/zcode.go 文件中
const (
	SUCCESS = 0  // 默认的成功响应 code
	FAIL    = -1 // 默认的失败响应 code
)

func Result(ctx *gin.Context, code int, message string, data interface{}) {
	ctx.JSON(http.StatusOK, Response{
		code,
		message,
		data,
	})
}

// Ok 不带数据的成功响应
func Ok(ctx *gin.Context) {
	Result(ctx, SUCCESS, "操作成功", map[string]interface{}{})
}

// OkWithData 带有数据的成功响应
func OkWithData(ctx *gin.Context, data interface{}) {
	Result(ctx, SUCCESS, "查询成功", data)
}

// OkWithMessage 带有消息的成功响应
func OkWithMessage(ctx *gin.Context, message string) {
	Result(ctx, SUCCESS, message, map[string]interface{}{})
}

// OkWithDetail 既有消息又有数据的成功响应
func OkWithDetail(ctx *gin.Context, message string, data interface{}) {
	Result(ctx, SUCCESS, message, data)
}

// Fail 不带数据的失败响应
func Fail(ctx *gin.Context) {
	Result(ctx, FAIL, "操作失败", map[string]interface{}{})
}

// FailWithMessage 带有消息的失败响应
func FailWithMessage(ctx *gin.Context, message string) {
	Result(ctx, FAIL, message, map[string]interface{}{})
}
