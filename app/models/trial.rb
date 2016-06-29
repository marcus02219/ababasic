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

  def info_by_json
    {id: self.id.to_s, name: self.name, number: self.number, result: self.result, level: self.level, language: self.language, prompt_type: self.prompt_type}
  end

end
