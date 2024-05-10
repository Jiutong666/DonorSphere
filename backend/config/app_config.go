package config

type AppConfig struct {
	*Server      `mapstructure:"server"`
	*ZapConfig   `mapstructure:"zap"`
	*MysqlConfig `mapstructure:"mysql"`
	*RedisConfig `mapstructure:"redis"`
}
