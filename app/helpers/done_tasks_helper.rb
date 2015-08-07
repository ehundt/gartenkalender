module DoneTasksHelper

  def link_label(skipped)
    if skipped
      link_label = "doch nicht überspringen"
    else
      link_label = "doch nicht erledigt"
    end
  end

  def done_task_modal(task, done_task)
    if done_task.nil?
      form_for :done_task, method: :post,
          url: plant_task_done_tasks_path(task.plant, task) do |f|
        render partial: "done_tasks/modal",
                 locals: { task: task, done_task: nil, f: f, skipped: 0 }
      end
    else
      skipped = done_task.skipped? ? 1 : 0
      form_for done_task, method: :patch,
          url: plant_task_done_task_path(task.plant, task, done_task) do |f|
        render partial: "done_tasks/modal",
                 locals: { task: task, done_task: done_task, f: f, skipped: skipped }
      end
    end
  end
end
