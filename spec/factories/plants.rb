FactoryGirl.define do
  factory :plant do
    name  "Erdbeere"
    image_url "url/erdbeere.jpg"
    desc      "Dies ist eine Pflanze"
    created_at "2015-04-28 14:24:59.65316"
    updated_at "2015-04-28 14:24:59.65316"
    main_image_file_name  "erdbeere.jpg"
    main_image_content_type "image/jpeg"
    main_image_file_size "10216"
    main_image_updated_at "2015-04-28 14:24:59.418618"
    subtitle   "Frühblühende Erdbeere"
    active     true
    user_id    1
    creator_id 1
  end
end
