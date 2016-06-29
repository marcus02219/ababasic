class Trial
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user
  
  field :name,              :type => String
  field :number,         		:type => String
  field :result,         		:type => String

  field :level,         		:type => String
  field :language,          :type => String

  field :prompt_type,       :type => String


end
