module Endpoints
  class Clients < Grape::API

    resource :clients do

      # Events API test
      # /api/v1/clients/ping
      # results  'clients endpoints'
      get :ping do
        { :ping => 'clients endpoints' }
      end

      # POST: /api/v1/clients
      #   parameters accepted
      #     'token'         String,      *required
      #     'first_name'    String,      *required
      #     'last_name'     String,      *required
      #     'birthday'      String,      *required
      #     'diagnosis'     String,      *required
      #     'school'        String,      *required
      #     'photo'         File,        *required
      #   results
      #     {status: :success, data: {client data}}
      post do
        user = User.find_by_token params[:token]
        if user.present?
          client = user.clients.new(first_name: params[:first_name], last_name: params[:last_name], birthday: params[:birthday], diagnosis: params[:diagnosis], school: params[:school], photo: params[:photo])
          if client.save()
            {status: :success, data: client.info_by_json}
          else
            {status: :failure, data: client.errors.messages}
          end
        else
          {status: :failure, data: "Please sign in"}
        end
      end

      # Get client by client_id
      # GET: /api/v1/clients
      #   parameters accepted
      #     'token'         String,       *required
      #     'client_id'     String,       * required
      #   results
      #     {status: :success, data: {client data}}
      get do
        user = User.find_by_token params[:token]
        if user.present?
          client = user.clients.find(params[:client_id])
          if client.present?
            {status: :success, data: client.info_by_json}
          else
            {status: :failure, data: "Can not find client"}
          end
        else
          {status: :failure, data: "Please sign in"}
        end
      end

    end
  end
end
