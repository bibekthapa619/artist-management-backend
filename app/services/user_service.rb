class UserService

    def create_user(params)
        user = User.new(params)
        return user
    end

    def find_user(id)
        User.find(id)
    rescue ActiveRecord::RecordNotFound
        nil
    end

    def list_users(page = 1, per_page = 10, search = nil)
        users = User.all
        
        if search.present?
            users = users.where("CONCAT(first_name, ' ', last_name) LIKE :search OR email LIKE :search OR phone LIKE :search", search: "%#{search}%")
        end

        users.page(page).per(per_page)
    end

    def update_user(user_id, params)
        user = find_user(user_id)
        if user && user.update(params)
            { success: true, user: user }
        else
            { success: false, user: user }
        end
    end

    def delete_user(user_id)
        user = find_user(user_id)
        user.destroy if user
    end
end
