class SiteInfo
  include Mongoid::Document
  field :about, type: String, default: ''
  field :about_html, type: String, default: ''

  before_save :set_about_html

  def set_about_html
    if self.about_changed?
      self.about_html = MarkdownTopicConverter.format(self.about, nil)
    end
  end

  def self.get_instance
    site_info = self.all.first
    unless site_info
      site_info = self.create
    end
    site_info
  end
end
