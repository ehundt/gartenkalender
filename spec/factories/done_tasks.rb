FactoryGirl.define do
  factory :done_task do
    task_id    1
#    season     2
#    year       Date.today.year
    skipped    false
    date       DateTime.now
  end
end
