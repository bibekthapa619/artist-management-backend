module PaginationMeta
    extend ActiveSupport::Concern

    def get_pagination_meta(model)
        {
            total: model.total_count,
            last_page: model.total_pages, 
            current_page: model.current_page,
            page_size: model.limit_value,
            from: model.offset_value + 1,                
            to: [model.offset_value + model.limit_value, model.total_count].min
        } 
    end
end