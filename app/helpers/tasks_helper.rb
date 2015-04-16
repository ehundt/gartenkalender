module TasksHelper

  def select_options_for(task, attribute=:starts)
    options = []
    if attribute == :starts
      seasons = Season::seasons_with_mean_dates
      Task.starts.each do |season, index|
        start_date = Date.parse(seasons[season].start.to_s).strftime("%d.%b")
        options.push([season.humanize.titleize + " (ab #{start_date})",
                     season])
      end
      selected = task.start if defined? task
    elsif attribute == :stops
      seasons = Season::seasons_with_mean_dates
      Task.starts.each do |season, index|
        end_date   = Date.parse(seasons[season].stop.to_s).strftime("%d.%b")
        options.push([season.humanize.titleize + " (bis #{end_date})",
                     ("ende_" + season.to_s).to_sym])
      end
      selected = task.stop if defined? task
    elsif attribute == :repeats
      options = Task.repeats.collect { |s| [s[0].humanize.titleize, s[0]] }
      selected = task.repeat if defined? task
    end

    options_for_select(options, selected)
  end
end

