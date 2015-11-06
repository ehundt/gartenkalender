require 'rails_helper'

RSpec.describe Task do
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
    # first user
    let!(:user1){ create(:user) }
    let!(:active_plant1){ create(:plant,   user_id: user1.id, active: true) }
    let!(:inactive_plant1){ create(:plant, user_id: user1.id, active: false) }

    # second user
    let!(:user2){ create(:user) }
    let!(:active_plant2){ create(:plant,   user_id: user2.id, active: true) }
    let!(:inactive_plant2){ create(:plant, user_id: user2.id, active: false) }

    context "tasks exist for different users and active and inactive plants" do
      it "returns upcoming task only for this user" do
        active_task1 = create(:task,
                              plant_id: active_plant1.id,
                              user_id: user1.id,
                              begin_date: Date.today.change(year: 1) - 5.days,
                              end_date: Date.today.change(year: 1) + 5.days,
                              repeat: Task.repeats["einmalig"])

        active_task2 = create(:task,
                              plant_id: active_plant2.id,
                              user_id: user2.id,
                              begin_date: Date.today.change(year: 1) - 5.days,
                              end_date: Date.today.change(year: 1) + 5.days,
                              repeat: Task.repeats["einmalig"])

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
        current_task = create(:task,
                              plant_id: active_plant1.id,
                              user_id:  user1.id,
                              begin_date: Date.today.change(year: 1) - 5.days,
                              end_date: Date.today.change(year: 1) + 5.days )
        future_task  = create(:task,
                              plant_id: active_plant1.id,
                              user_id: user1.id,
                              begin_date: Date.today.change(year: 1) + 5.days,
                              end_date: Date.today.change(year: 1) + 15.days )


        expect(Task.upcoming_tasks_for_user(user1)).to contain_exactly(current_task)
      end
    end

    context "repeating daily tasks" do
      it "returns daily repeating tasks" do
        current_task = create(:task,
                              plant_id:   active_plant1.id,
                              user_id:    user1.id,
                              begin_date: Date.today.change(year: 1) - 5.days,
                              end_date:   Date.today.change(year: 1) + 15.days,
                              repeat:     Task.repeats[:täglich])
        future_task  = create(:task,
                              plant_id:   active_plant1.id,
                              user_id:    user1.id,
                              begin_date: Date.today.change(year: 1) + 5.days,
                              end_date:   Date.today.change(year: 1) + 15.days,
                              repeat:     Task.repeats[:täglich])
        expect(Task.upcoming_tasks_for_user(user1)).to contain_exactly(current_task)
      end
    end

    context "task done but on different day" do
      it "returns daily repeating tasks" do
        current_task = create(:task,
                              plant_id:   active_plant1.id,
                              user_id:    user1.id,
                              begin_date: Date.today.change(year: 1) - 5.days,
                              end_date:   Date.today.change(year: 1) + 15.days,
                              repeat:     Task.repeats[:täglich])
        done_task = create(:done_task, task_id: current_task.id, date: (Date.today - 2.days))

        expect(Task.upcoming_tasks_for_user(user1)).to contain_exactly(current_task)
      end
    end
  end
end
