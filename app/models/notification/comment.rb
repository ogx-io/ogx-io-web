class Notification::Comment < Notification::Base

  belongs_to :comment, class_name: "Comment"

end