class Api::V1::InviteesController < ApplicationController
  def create
    # Find the viewing party and user
    viewing_party = ViewingParty.find_by(id: params[:viewing_party_id])
    user = User.find_by(id: params[:invitees_user_id])

    if viewing_party.nil?
      render json: { error: "Viewing party not found" }, status: :not_found
    elsif user.nil?
      render json: { error: "User not found" }, status: :not_found
    else
      # Add the user to the viewing party's invitees (using the join table)
      viewing_party.invitees << user

      # Respond with success
      render json: { message: "User added as an invitee" }, status: :ok
    end
  end
end