package sevice

import (
	"backend/global"
	"backend/model"
	commonreq "backend/model/common/request"
	"time"
)

func AddProject(project *commonreq.Project) (err error) {
	record := &model.TbProject{
		NgoId:        project.NgoId,
		NgoName:      project.NgoName,
		Name:         project.Name,
		Description:  project.Description,
		Founder:      project.Founder,
		Beneficiary:  project.Beneficiary,
		TargetAmount: project.TargetAmount,
		RaisedAmount: project.RaisedAmount,
		CreatTime:    time.Now().Format("2006-01-02 15:04:05"),
		EndTime:      project.EndTime.Format("2006-01-02 15:04:05"),
		Picture:      project.Picture,
	}
	result := global.DB.Save(record)
	err = result.Error
	if err != nil {
		return err
	}
	return
}
