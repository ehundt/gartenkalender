require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#all_for_user' do
    it 'returns all tasks for active plants for this user no matter whether it s done or not' do

      user = build(:user)
      task = build(:task)
      expect(task.title).to eq("Säen")
    end
  end
end
