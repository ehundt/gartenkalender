FactoryGirl.define do
  factory :user do
    first_name            "Heinz"
    last_name             "Mustermann"
    admin                 false
    password              "password"
    password_confirmation "password"
    email                 { Faker::Internet.email }
  end

  # factory :admin, class: :user do
  #   first_name         "Susi"
  #   last_name          "Müller"
  #   admin              true
  #   created_at         "2015-04-28 14:24:59.65316"
  #   updated_at         "2015-04-28 14:24:59.65316"
  #   email              "susi.mueller@gmail.bla"
  #   encrypted_password "$2a$10$R0dHUpo0.b.Wfy31QFdExe.AlieTQU/2So3Lo8/ZN2.UqmI0PtLpS"
  #   sign_in_count      3
  # end

end
