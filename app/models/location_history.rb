class LocationHistory < ApplicationRecord
    belongs_to :user, optional: true

    validates :latitude, presence: true
    validates :longitude, presence: true

    after_commit :deleteOldest, on: :create

    private
    
    def deleteOldest
      if user 
        if LocationHistory.where(user_id: user.id).count > 2880 # Assuming 2880 is the limit for 2 days of data at 1 minute intervals
          logger.info "LocationHistory: User #{user.username} has more than 100 entries, deleting oldest."
          oldest = LocationHistory.where(user_id: user.id).order(created_at: :asc).first
          oldest.destroy if oldest
          logger.info "LocationHistory: Oldest location history entry deleted for user #{user.username}."
        end
      end
    end

end
