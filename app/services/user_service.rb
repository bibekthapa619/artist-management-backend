class UserService
    include PaginationMeta

    def create_user(params)
        user = User.new(params)
        user.save!
        return user
    end

    def find_user(id)
        User.find(id)
    end

    def list_users(page = 1, per_page = 10,super_admin_id = nil, search = nil, sort = nil)
        users = User.all
        if super_admin_id.present?
            users = users.where("super_admin_id = ?",super_admin_id)
        end
        if search.present?
            users = users.where("CONCAT(first_name, ' ', last_name) LIKE :search OR email LIKE :search OR phone LIKE :search", search: "%#{search}%")
        end

        if sort.present?
            users = users.order(sort)
        end

        users = users.page(page).per(per_page)
        { 
            users: users, 
            meta: get_pagination_meta(users)
        }
    end

    def update_user(user_id, params)
        user = find_user(user_id)
        user.update!(params)
        return user
    end

    def delete_user(user_id)
        user = find_user(user_id)
        user.destroy!
    end
end
