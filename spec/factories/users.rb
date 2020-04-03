FactoryBot.define do
  factory :user do
    email { "user@mail.com" }
    password { "password" }
    password_confirmation { "password" }
    premium_user { false }
    role { 'user' }
    factory :journalist do
      role { 'journalist' } 
    end
  end
end
