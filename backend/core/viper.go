package core

import (
	"backend/global"
	"fmt"

	"github.com/fsnotify/fsnotify"
	"github.com/spf13/viper"
)

// LoadFileConfig 加载配置文件
func Viper() {
	// 加载配置文件, 配置文件路径: etc/config.yml
	viper.SetConfigFile("etc/config.yml")
	if err := viper.ReadInConfig(); err != nil {
		if _, ok := err.(viper.ConfigFileNotFoundError); ok {
			panic("Config file not found!")
		}
		panic(fmt.Sprintf("viper.ReadInConfig err: %s \n", err))
	}

	// 读取到的配置信息，反序列化到 Conf 结构体中
	if err := viper.Unmarshal(&global.APP_CONFIG); err != nil {
		panic(fmt.Sprintf("viper.Unmarshal err: %s \n", err))
	}

	// viper 热加载配置
	viper.WatchConfig()
	viper.OnConfigChange(func(event fsnotify.Event) {
		global.LOGGER.Info("Config File Changed: " + event.Name)
		if err := viper.Unmarshal(&global.APP_CONFIG); err != nil {
			panic(fmt.Sprintf("viper.Unmarshal err: %s \n", err))
		}
	})
}
