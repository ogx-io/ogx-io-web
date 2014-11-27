namespace :user do
  desc "Resend confirmations to all unactivated users"
  task resend_confirmation: :environment do
    users = User.where(confirmation_token: {'$ne' => NULL})
    users.each do |user|
      user.send_confirmation_instructions
    end
  end

end
