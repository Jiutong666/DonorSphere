package initialize

import (
	"backend/global"
	"fmt"
	"gorm.io/gorm/logger"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

func Gorm() *gorm.DB {
	if global.APP_CONFIG.MysqlConfig.Dbname == "" {
		return nil
	}

	dsn := fmt.Sprintf(
		"%s:%s@tcp(%s:%d)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		global.APP_CONFIG.MysqlConfig.User,
		global.APP_CONFIG.MysqlConfig.Password,
		global.APP_CONFIG.MysqlConfig.Host,
		global.APP_CONFIG.MysqlConfig.Port,
		global.APP_CONFIG.MysqlConfig.Dbname,
	)

	if db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info),
	}); err != nil {
		return nil
	} else {
		sqlDB, _ := db.DB()
		sqlDB.SetMaxIdleConns(global.APP_CONFIG.MysqlConfig.MaxIdleConns)
		sqlDB.SetMaxOpenConns(global.APP_CONFIG.MysqlConfig.MaxOpenConns)
		return db
	}
}
