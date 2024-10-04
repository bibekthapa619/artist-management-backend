module PaginationMeta
    extend ActiveSupport::Concern

    def get_pagination_meta(model)
        {
            total: model.total_count,
            total_pages: model.total_pages, 
            current_page: model.current_page,
        } 
    end
end