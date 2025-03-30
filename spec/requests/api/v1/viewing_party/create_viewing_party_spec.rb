require 'rails_helper'

RSpec.describe 'Create a Viewing Party', type: :request do
  it 'can create a new viewing_party' do
    
  end
  post '/api/v1/viewing_party',params: viewing_party_params 

end