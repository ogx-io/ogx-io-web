module BodyConvertable
  extend ActiveSupport::Concern

  included do
    field :bh, as: :body_html, type: String
    before_save :set_body_html
  end

  def set_body_html
    convert_body if self.body_changed?
  end

  def convert_body
    self.body_html = MarkdownTopicConverter.format(self.body, self.topic)
  end
end