class HomeController < ApplicationController
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token
  def index
  end
  # Create account API
  # POST: /api/v1/accounts/create
  # parameters:
    # email:          String *required
    # password:       String *required minimum 6
    # name:           String *required
    # user_type:      String *required
    # birthday:       Date *required ex: '1980-5-20'
    # diagnosis:      String *required
    # school:         String *required
    # photo:          File *required


  # results:
  #   return created user info

  def create
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'

    email         = params[:email].downcase
    password      = params[:password]
    name          = params[:name]
    user_type     = params[:user_type]
    # birthday      = params[:birthday]
    # diagnosis     = params[:diagnosis]
    # school        = params[:school]
    # photo         = params[:photo]

    if User.where(email:email).first.present?
      render json:{status: :failure, data: 'This email already exists. Please try another email'} and return
    end
    # user = User.new(email:email, password:params[:password], name:name, user_type:user_type, birthday:birthday, diagnosis: diagnosis, school: school, photo: photo)
    user = User.new(email:email, password:params[:password], name:name, user_type:user_type)
    if user.save
      if sign_in(:user, user)
        render :json => {status: :success, :data => user.authentication_token}
      else
        render json: {status: :failure, :data => 'Can not create account'}
      end
    else
      render :json => {status: :failure, :data => user.errors.messages}
    end
  end
  # Destroy account API
  # POST: /api/v1/accounts/destroy
  # parameters:
  #   token:      String *required
  # results:
  #   return success string
  def destroy
    user   = User.find_by_token params[:token]
    if user.present?
      if user.destroy
        sign_out(resource)
        render :json => {status: :success, data: 'deleted account'}
      else
        render :json => {status: :failure, data: "cannot delete this user"}
      end
    else
      render :json => {status: :failure, data: "cannot find user"}
    end
  end
  # Login API
  # POST: /api/v1/accounts/sign_in
  # parameters:
  #   email:      String *required
  #   password:   String *required
  # results:
  #   return user_info
  def create_session
    if params[:social]
      social_sign_in(params)
    end
    email    = params[:email]
    password = params[:password]

    resource = User.find_for_database_authentication( :email => email )
    if resource.nil?
      render :json => {status: :failure, data: 'No Such User'}
    else
      if resource.valid_password?( password )
        user = sign_in( :user, resource )
        render :json => {status: :success, :data => resource.info_by_json}
        else
          render :json => {status: :failure,  data: "Password is wrong"}
        end
      end
   end

   # LogOut API
   # POST: /api/v1/accounts/sign_out
   # parameters:
   #   email:      String *required
   # results:
   #   return user_info
   def delete_session
    if params[:email].present?
        resource = User.find_for_database_authentication(:email => params[:email])
    elsif params[:user_id].present?
      resource = User.find(params[:user_id])
    end

    if resource.nil?
       render :json => {status: :failure, data:'No Such User'}
    else
    sign_out(resource)
       render :json => {status: :success, :data => 'sign out'}
    end
  end


end
