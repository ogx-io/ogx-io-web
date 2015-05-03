class UserDetail
  include Mongoid::Document
  include Mongoid::Timestamps

  field :intro, type: String, default: ''
  field :intro_html, type: String, default: ''

  belongs_to :user

  before_save :set_intro_html

  def set_intro_html
    if self.intro_changed?
      self.intro_html = MarkdownTopicConverter.format(self.intro, nil)
    end
  end
end
