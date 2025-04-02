module Tasks
  class Setup
    class << self
      def create_admin
        email = ENV["ADMIN_EMAIL"]
        password = ENV["ADMIN_PASSWORD"]
        if email.blank? || password.blank?
          puts "ADMIN_EMAIL and ADMIN_PASSWORD must both be set"
          return
        end

        user = User.find_by(email: email)
        if user.present?
          puts "Admin user for #{email} already exists"
          return
        end

        user = User.new(
          email: email,
          password: password,
          password_confirmation: password,
          permission_sets: [ "AdminPermissions" ]
        )
        if user.save
          puts "Admin user for #{email} created"
        else
          puts "Admin user for #{email} creation failed"
          puts user.errors.full_messages.join(", ")
        end
      end
    end
  end
end

namespace :setup do
  desc "Create an admin user from environment variables one doesn't exist"
  task create_admin: :environment do
    Tasks::Setup.create_admin
  end
end
