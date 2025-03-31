class ViewingParty < ApplicationRecord
  has_many :viewing_party_users, dependent: :destroy
  has_many :users, through: :viewing_party_users
  belongs_to :host, class_name: "User"

  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :movie_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :movie_title, presence: true
  validate :end_time_after_start_time
  validate :movie_id_in_top_rated
  validate :movie_duration
  validate :validate_invitees

  private

  def top_rated_movies
    @top_rated_movies ||= MovieGateway.get_top_rated
  end

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after the start time")
    end
  end

  def movie_id_in_top_rated
    unless top_rated_movies.any? { |movie| movie.id.to_i == movie_id }
      errors.add(:movie_id, "must be a valid movie from the top-rated list")
    end
  end

  def movie_duration
    return if start_time.nil? || end_time.nil? || movie_id.nil?
    movie = MovieGateway.find_movie_details(movie_id)
    duration = movie.runtime
    if ((end_time - start_time) / 60).to_i < duration
      errors.add(:end_time, "#{self.name} party must be at least as long as #{self.movie_title} film")
    end
  end

  def validate_invitees
    return if start_time.nil? || end_time.nil? || movie_id.nil?
    invalid_user_ids = viewing_party_users.map(&:user_id).reject { |user_id| User.exists?(user_id) }
    if invalid_user_ids.any?
      errors.add(:invitees, "contains invalid users")
    end
  end
end