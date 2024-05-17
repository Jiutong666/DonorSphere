package commonreq

import (
	"time"
)

type Project struct {
	NgoId        int64     `gorm:"column:ngo_id;NOT NULL" json:"ngoId"`               // 组织ID
	NgoName      string    `gorm:"column:ngo_name;NOT NULL" json:"ngoName"`           // 组织名称
	Name         string    `gorm:"column:name;NOT NULL" json:"name"`                  // 项目名称
	Description  string    `gorm:"column:description;NOT NULL" json:"description"`    // 项目描述
	Founder      int64     `gorm:"column:founder;NOT NULL" json:"founder"`            // 项目创始人
	Beneficiary  int64     `gorm:"column:beneficiary;NOT NULL" json:"beneficiary"`    // 捐款地址
	TargetAmount int64     `gorm:"column:target_amount;NOT NULL" json:"targetAmount"` // 目标金额
	RaisedAmount int64     `gorm:"column:raised_amount;NOT NULL" json:"raisedAmount"` // 已筹集金
	CreateTime   time.Time `gorm:"column:create_time;NOT NULL" json:"createTime"`     // 创建时间
	EndTime      time.Time `gorm:"column:end_time;NOT NULL" json:"endTime"`           // 结束时间
	Picture      string    `gorm:"column:picture;NOT NULL" json:"picture"`            // 项目图片URL
}
