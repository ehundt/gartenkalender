require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#all_for_user' do
    context "tasks for active and inactive plants" do
      let!(:user){ create(:user) }
      let!(:active_plant){ create(:plant, user_id: user.id, active: true) }
      let!(:task1){ create(:task, plant_id: active_plant.id, user_id: user.id) }

      let!(:inactive_plant){ create(:plant, user_id: user.id, active: false) }
      let!(:task2){ create(:task, plant_id: inactive_plant.id, user_id: user.id, start: 8, stop: 9) }

      it 'returns only tasks for active plants' do
        expect(Task.all_for_user(user)).to contain_exactly(task1)
      end
    end
  end

  describe '#upcoming_tasks_for_user' do
    let!(:user1){ create(:user) }
    let!(:user2){ create(:user) }
    # first user
    let!(:active_plant1){ create(:plant, user_id: user1.id, active: true) }
    let!(:active_task1){ create(:task, plant_id: active_plant1.id, user_id: user1.id, start: 1, stop: 3) }

    let!(:inactive_plant){ create(:plant, user_id: user1.id, active: false) }
    let!(:inactive_task){ create(:task, plant_id: inactive_plant.id, user_id: user1.id) }

    # second user
    let!(:active_plant2){ create(:plant, user_id: user2.id, active: true) }
    let!(:active_task2){ create(:task, plant_id: active_plant2.id, user_id: user2.id) }

    context "tasks exist for different users and active and inactive plants" do
      it "returns only upcoming tasks for this user" do
        expect(Task.upcoming_tasks_for_user(user1)).to contain_exactly(active_task1)
      end
    end

    # context "hidden and visible tasks" do
    #   hidden_task1 = create(:task, user_id: user1.id, plant_id: active_plant.id, hide: true)
    #   it "returns only visible tasks" do
    #     expect(Task.upcoming_tasks_for_user(user1)).to contain_exactly(active_task1)
    #   end
    # end


    context "tasks out of season" do
      it "returns only upcoming tasks" do
        allow(Season).to receive(:current).and_return(2)
        current_task2 = create(:task, plant_id: active_plant1.id, user_id: user1.id, start: 1, stop: 3)
        future_task = create(:task, plant_id: active_plant1.id, user_id: user1.id, start: 6, stop: 8)

        expect(Task.upcoming_tasks_for_user(user1)).to contain_exactly(active_task1, current_task2)
      end
    end

    context "repeating tasks" do
      context "daily" do
        it "returns daily repeating tasks" do
          allow(Season).to receive(:current).and_return(2)
          current_task2 = create(:task, plant_id: active_plant1.id, user_id: user1.id, start: 1, stop: 3, repeat: 4)
          future_task = create(:task, plant_id: active_plant1.id, user_id: user1.id, start: 6, stop: 8, repeat: 4)

          expect(Task.upcoming_tasks_for_user(user1)).to contain_exactly(active_task1, current_task2)
        end

        it "returns daily repeating tasks even when task has been done within this season once" do
          allow(Season).to receive(:current).and_return(2)
          current_task2 = create(:task, plant_id: active_plant1.id, user_id: user1.id, start: 1, stop: 3, repeat: 4)
          done_task = create(:done_task, task_id: current_task2.id, created_at: (Date.today - 2.days))

          expect(Task.upcoming_tasks_for_user(user1)).to contain_exactly(active_task1, current_task2)
        end
      end

      context "yearly" do

      end
    end
  end
end
