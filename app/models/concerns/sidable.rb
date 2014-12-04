module Sidable
  extend ActiveSupport::Concern

  def sid
    r = ''
    id = self.id
    dict = "abcdefghijklmnopqrstuvwxyz"
    while id > 0 do
      i = id % 26
      r = dict[i] + r
      id = id / 26
    end
    r
  end

  module ClassMethods
    def find_by_sid(sid)
      id = 0
      sid.each_byte { |b| id = id * 26 + (b - 97) }
      self.find(id)
    end
  end
end