FactoryGirl.define do
  factory :task do
    plant_id   1
    user_id    1
    title      "Säen"
    begin_date "0001-02-10 14:24:59.65316"
    end_date   "0001-08-28 14:24:59.65316"
    desc       "Das geht so und so."
    repeat     0
    hide       false
  end
end
