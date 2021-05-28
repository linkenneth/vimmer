require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it 'shows the landing' do
      get '/'
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Welcome to Vimmer')
    end
  end
end
