module Endpoints
  class Accounts < Grape::API

    resource :accounts do

      # Accounts API test
      # /api/v1/accounts/ping
      # results  'gwangming'
      get :ping do
        { :ping => 'gwangming' }
      end

      # User info Setup
      # POST: /api/v1/accounts/setup
      #   parameters accepted
      #     token:          String,      *required
      #     birthday:       Date *required ex: '1980-5-20'
      #     diagnosis:      String *required
      #     school:         String *required
      #     photo:          File *required
      #   results
      #     {status: :success, data: {client data}}

      post :setup do
        user = User.find_by_token(params[:token])
        if user.present?
          if user.update(birthday:params[:birthday],diagnosis:params[:diagnosis],school:params[:school], photo:params[:photo])
            {status: :success, data: user.info_by_json}
          else
            {status: :failure, data: user.errors.messages}
          end
        else
          {status: :failure, data: "Please sign in"}
        end
      end

    end
  end
end
