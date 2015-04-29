FactoryGirl.define do
  factory :task do
    plant_id 1
    user_id 1
    title "Säen"
    start 1
    stop  3
    desc "Das geht so und so."
    repeat 1
    hide false
  end
end
