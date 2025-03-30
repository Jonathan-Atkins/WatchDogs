class Api::V1::ViewingPartiesController < ApplicationController
  def create
    require 'pry'; binding.pry
    viewing_party = ViewingParty.new(viewing_party_params)

    if viewing_party.save
      params[:invitees].each do |invitee_id|
        ViewingPartyUser.create!(viewing_party_id: viewing_party.id, user_id: invitee_id)
      end
      render json: ViewingPartySerializer.new(viewing_party), status: :created
    else
      render json: { errors: viewing_party.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title, :host_id)
  end
end