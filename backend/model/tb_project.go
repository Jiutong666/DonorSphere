package model

const TableNameTbProject = "tb_project"

type TbProject struct {
	Id           int64  `gorm:"column:id;primary_key;AUTO_INCREMENT;NOT NULL"` // 项目ID
	NgoId        int64  `gorm:"column:ngo_id;NOT NULL"`                        // 组织ID
	NgoName      string `gorm:"column:ngo_name;NOT NULL"`                      // 组织名称
	Name         string `gorm:"column:name;NOT NULL"`                          // 项目名称
	Description  string `gorm:"column:description;NOT NULL"`                   // 项目描述
	Founder      int64  `gorm:"column:founder;NOT NULL"`                       // 项目创始人
	Beneficiary  int64  `gorm:"column:beneficiary;NOT NULL"`                   // 捐款地址
	TargetAmount int64  `gorm:"column:target_amount;NOT NULL"`                 // 目标金额
	RaisedAmount int64  `gorm:"column:raised_amount;NOT NULL"`                 // 已筹集金
	CreatTime    string `gorm:"column:create_time;NOT NULL"`                   // 创建时间
	EndTime      string `gorm:"column:end_time;NOT NULL"`                      // 结束时间
	Picture      string `gorm:"column:picture;NOT NULL"`                       // 项目图片
}

func (t *TbProject) TableName() string {
	return TableNameTbProject
}
