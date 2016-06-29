class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  mount_uploader :photo, PhotoUploader
  ## Database authenticatable
  field :name,                type: String, default: ""
  field :user_type,           type: String, default: ""
  field :birthday,            type: Date, default: ""
  field :diagnosis,           type: String, default: ""
  field :school,              type: String, default: ""
  field :photo,               type: String, default: ""

  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""


  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  field :from_social,               :type => String,    :default => ""     # Social login status


  #field :access_token,              :type => String
  field :user_auth_id,              :type => String

  acts_as_token_authenticatable
  field :authentication_token,      :type => String

  has_many :trials, dependent: :destroy
  has_many :clients, dependent: :destroy


  def self.find_by_token(token)
    User.where(:authentication_token=>token).first
  end

  field :name,                type: String, default: ""
  field :user_type,           type: String, default: ""
  field :birthday,            type: Date, default: ""
  field :diagnosis,           type: String, default: ""
  field :school,              type: String, default: ""
  field :photo,               type: String, default: ""


  def info_by_json
    user = self
    user_info={
      id:user.id.to_s,
      name:user.name == nil ? "" : user.name,
      user_type:user.user_type == nil ? "" : user.user_type,
      email:user.email,
      birthday:user.birthday,
      token:user.authentication_token,
      school:user.school == nil ? "" : user.school,
      photo:user.photo_url,
      trials: user.trials_by_json,
      clients: user.clients_by_json
    }
  end

  def trials_by_json
    json_data = []
    trials = self.trials
    trials.each do |trial|
      json_data << {
        id:trial.id.to_s,
        name: trial.name,
        number: trial.number,
        result: trial.result,
        level: trial.level,
        language: trial.language,
        prompt_type: trial.prompt_type
      }
    end
    json_data
  end

  def clients_by_json
    json_data = []
    clients = self.clients
    clients.each do |client|
      json_data << {
        id: client.id.to_s,
        first_name: client.first_name,
        last_name: client.last_name,
        birthday: client.birthday,
        diagnosis: client.diagnosis,
        school: client.school,
        photo: client.photo_url
      }
    end
    json_data
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def photo_url
  	if self.photo.url.nil?
  		""
  	else
      # if Rails.env.production?
      #   self.photo.url
      # else
    		self.photo.url.gsub("#{Rails.root.to_s}/public/album/", "/public/album/")
      # end
  	end
  end
end
