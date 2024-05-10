package core

import (
	"os"

	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

// Zap 初始化 zap 日志
func Zap() (logger *zap.Logger) {
	writeSyncer := getLogWriter()
	encoder := getEncoder()

	zapCore := zapcore.NewCore(encoder, writeSyncer, zapcore.DebugLevel)
	logger = zap.New(zapCore)

	return
}

func getEncoder() zapcore.Encoder {
	return zapcore.NewJSONEncoder(zap.NewProductionEncoderConfig())
}

func getLogWriter() zapcore.WriteSyncer {
	file, _ := os.Create("./logs/server.log")
	return zapcore.AddSync(file)
}
