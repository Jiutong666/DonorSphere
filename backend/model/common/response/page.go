package commonresp

// PageResult 分页查询响应结构体
type PageResponse struct {
	PageNum  int   `json:"page_num"`
	PageSize int   `json:"page_size"`
	Total    int64 `json:"total"`
}
