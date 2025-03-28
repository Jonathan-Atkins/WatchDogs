FactoryBot.define do
  factory :user do
    name { "John Doe" }
    username { "johndoe" }
    password { "password123" }  
    password_confirmation { "password123" }  
  end
end