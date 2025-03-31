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
    
    if params[:viewing_party].blank? && params[:invitees].blank?
      return render json: { errors: ["At least one attribute must change"] }, status: :bad_request
    end
  
    if params[:viewing_party].present?
      viewing_party_params = params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title, :host_id)
      unless viewing_party.update(viewing_party_params)
        return render json: { errors: ["At least one attribute must change"] }, status: :bad_request
      end
    end
  
    if params[:invitees].present?
      new_invitee_ids = params[:invitees].map(&:to_i)
      existing_invitee_ids = viewing_party.invitees.pluck(:id)
      all_invitee_ids = (existing_invitee_ids + new_invitee_ids).uniq
      viewing_party.invitees = User.where(id: all_invitee_ids)
    end
  
    render json: ViewingPartySerializer.new(viewing_party), status: :ok
  end

  def show
    viewing_party = ViewingParty.find_by(id: params[:id])
    if viewing_party
      render json: ViewingPartySerializer.new(viewing_party), status: :ok
    else
      render json: { errors: ["Viewing Party not found"] }, status: :not_found
    end
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title, :host_id)
  end
end