class DashboardController < ApplicationController
    before_action :authenticate_request

    before_action only: [:get_music_stats] do
        has_role(roles:['super_admin'])
    end

    before_action only: [:get_user_stats] do
        has_role(roles:['super_admin'])
    end

    def get_user_stats
        stats = {
          user_count:{
            artist_manager: 0,
            artist: 0,
          },
          artist_count: {
            male: 0,
            female: 0,
            other: 0
          }
        }
      
        stats[:user_count][:artist_manager] = User.artist_managers_only.where(super_admin_id: @current_user.id).count
      
        stats[:user_count][:artist] = User.artists_only.where(super_admin_id: @current_user.id).count
      
        gender_counts = User.artists_only.where(super_admin_id: @current_user.id).group(:gender).count
      
        stats[:artist_count][:male] = gender_counts['m'] || 0
        stats[:artist_count][:female] = gender_counts['f'] || 0
        stats[:artist_count][:other] = gender_counts['o'] || 0
      
        render_success(stats, "")
    end

    def get_music_stats
        genres = Music.genres.keys
        music_counts = Music.joins(artist: :user)
            .where(users: { super_admin_id: @current_user.id })
            .group(:genre)
            .count
      
        stats = genres.each_with_object({}) do |genre, hash|
          hash[genre] = music_counts[genre] || 0
        end
      
        render_success({music_count: stats}, "")
    end

end
