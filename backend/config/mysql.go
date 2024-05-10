package config

type MysqlConfig struct {
	Host         string `mapstructure:"host"`
	Dbname       string `mapstructure:"dbname"`
	User         string `mapstructure:"user"`
	Password     string `mapstructure:"password"`
	Port         int    `mapstructure:"port"`
	MaxOpenConns int    `mapstructure:"max_open_conns"`
	MaxIdleConns int    `mapstructure:"max_idle_conns"`
}
