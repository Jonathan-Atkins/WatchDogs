class Api::V1::ViewingPartiesController < ApplicationController
  def create
    viewing_party = ViewingParty.new(viewing_party_params)

    if viewing_party.save
      if params[:invitees].present?
        params[:invitees].each do |invitee_id|
          ViewingPartyUser.create!(viewing_party_id: viewing_party.id, user_id: invitee_id)
        end
      else
        return render json: { errors: ["Invitees can't be blank"] }, status: :unprocessable_entity
      end
      
      render json: ViewingPartySerializer.new(viewing_party), status: :created
    else
      render json: { errors: viewing_party.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    viewing_party = ViewingParty.find_by(id: params[:id].to_i)
    return render json: { errors: ["Viewing Party #{params[:id]} Not Found"] }, status: :not_found unless viewing_party
  
    unless params[:viewing_party] && params[:invitees]
      return render json: { errors: ["At least one attribute must change"] }, status: :bad_request
    end
  
    viewing_party.update!(viewing_party_params) if viewing_party_params.present?
  
    if params[:invitees].present?
      params[:invitees].each do |invitee_id|
        viewing_party.invitees << User.find(invitee_id) unless viewing_party.invitees.exists?(id: invitee_id)
      end
    end
  
    render json: ViewingPartySerializer.new(viewing_party), status: :ok
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title, :host_id)
  end
end