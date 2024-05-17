package sevice

import (
	"backend/model"
	"github.com/gin-gonic/gin"
	"log"
)

func CreateOrgInfo(c *gin.Context) {
	orgInfo := new(model.OrgInfo)
	err := c.ShouldBindJSON(orgInfo)
	if err != nil {
		log.Printf(err.Error())
	}
	c.JSON(200, gin.H{
		"code":    0, //  0成功   -1失败
		"message": "添加组织信息成功！",
		"data":    orgInfo,
	})
}

func EditOrgInfo(c *gin.Context) {

}

func GetOrgInfo(c *gin.Context) {

}

func DeleteOrgInfo(c *gin.Context) {

}
