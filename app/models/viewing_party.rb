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
    unless top_rated_movies.any? { |movie| movie.id == movie_id.to_s }
      errors.add(:movie_id, "must be a valid movie from the top-rated list")
    end
  end

  def movie_duration
    top_rated_movies.each do |movie|
    end
  end
end