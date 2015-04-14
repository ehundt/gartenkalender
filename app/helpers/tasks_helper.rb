module TasksHelper

  def select_options_for(task, attribute=:starts)
    if attribute == :starts
      options = Task.starts.collect { |w| [w[0].humanize.titleize, w[0]] }
      selected = task.start if defined? task
    elsif attribute == :stops
      options = Task.stops.collect { |w| [w[0].humanize.titleize, w[0]] }
      selected = task.stop if defined? task
    elsif attribute == :repeats
      options = Task.repeats.collect { |w| [w[0].humanize.titleize, w[0]] }
      selected = task.repeat if defined? task
    end

    options_for_select(options, selected)
  end
end
