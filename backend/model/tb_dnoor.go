package model

const TableNameTbUser = "tb_donor"

type Donor struct {
	Id           int64  `gorm:"column:id;primary_key;NOT NULL"` // 捐款人ID
	Address      int64  `gorm:"column:address;NOT NULL"`        // 捐款人地址
	Name         string `gorm:"column:name;NOT NULL"`           // 捐款人名
	ProjectId    int64  `gorm:"column:project_id;NOT NULL"`     // 捐款项目
	DonateAmount int64  `gorm:"column:donate_amount;NOT NULL"`  // 捐款金额
}

func (*Donor) TableName() string {
	return TableNameTbUser
}

func f() {
	d1 := Donor{
		Id:           1,
		Address:      1,
		Name:         "zs",
		ProjectId:    1,
		DonateAmount: 1,
	}
	d1.TableName()
}
