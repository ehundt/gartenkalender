require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

When /^(.+) creates (\d+) plants$/ do |first_name, count|
  user = User.find_by_first_name(first_name)
  @plants = []
  @plants[0] = FactoryGirl.create(:plant, creator: user)
end
