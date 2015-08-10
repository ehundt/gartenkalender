module TasksHelper

  def select_options_for(task, attribute=:starts)
    options = []
    if attribute == :repeats
      options = Task.repeats.collect { |s| [s[0].humanize.titleize, s[0]] }
      selected = task.repeat.blank? ? "jährlich" : task.repeat
    end

    options_for_select(options, selected)
  end

  def task_time_frame(task)
    time_frame = ""
    unless task.begin_date.blank? || task.end_date.blank?
      time_frame = humanize_date(task.begin_date.day, task.begin_date.month)
      time_frame += " bis #{humanize_date(task.end_date.day, task.end_date.month)}"
    end
    time_frame
  end

  def humanize_date(day, month)
    case day
    when 1
      humanized_date = "Anfang "
    when 10
      humanized_date = "Mitte "
    when 20
      humanized_date = "Ende "
    else
      humanized_date = ""
    end

    humanized_date += I18n.t("date.month_names")[month.to_i]
    humanized_date
  end

  def day_options
   [["Anfang", 1], ["Mitte", 10], ["Ende", 20]]
  end

  def month_options
    [ ["Januar", 1], ["Februar", 2], ["März", 3],
      ["April", 4], ["Mai", 5], ["Juni", 6],["Juli", 7],
      ["August", 8],["September", 9], ["Oktober", 10],
      ["November", 11],["Dezember", 12] ]
  end
end

