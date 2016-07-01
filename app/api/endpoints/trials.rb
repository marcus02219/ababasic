module Endpoints
  class Trials < Grape::API

    resource :trials do

      # Events API test
      # /api/v1/trials/ping
      # results  'trials endpoints'
      get :ping do
        { :ping => 'trials endpoints' }
      end

      # Create trial
      # POST: /api/v1/trials
      #   parameters accepted
      #     'token'         String,      *required
      #     'name'          String,      *required
      #     'number'        String,      *required
      #     'result'        String,      *required
      #     'level'         String,      *required
      #     'language'      String,      *required
      #     'prompt_type'   String,        *required
      #   results
      #     {status: :success, data: {trial data}}
      post do
        user = User.find_by_token params[:token]
        if user.present?
          trial = user.trials.new(name: params[:name], number: params[:number], result: params[:result], level: params[:level], language: params[:language], prompt_type: params[:prompt_type])
          if trial.save()
            {status: :success, data: trial.info_by_json}
          else
            {status: :failure, data: trial.errors.messages}
          end
        else
          {status: :failure, data: "Please sign in"}
        end
      end

      # Get triby by trial_id
      # GET: /api/v1/trials
      #   parameters accepted
      #     'token'         String,       *required
      #     'trial_id'     String,       * required
      #   results
      #     {status: :success, data: {trial data}}
      get do
        user = User.find_by_token params[:token]
        if user.present?
          if params[:trial_id].present?
            trial = user.trials.find(params[:trial_id])
            if trial.present?
              {status: :success, data: trial.info_by_json}
            else
              {status: :failure, data: "Can not find trial"}
            end
          else
            {status: :success, data: user.trials_by_json}
          end
        else
          {status: :failure, data: "Please sign in"}
        end
      end

    end
  end
end
