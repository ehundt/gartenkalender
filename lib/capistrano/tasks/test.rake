desc "Ask for breakfast"
task :breakfast do
  on roles(:all) do |h|
    set :breakfast, ask("welches Broetchen?", echo: true)
    execute "echo \"Frühstück mit #{fetch(:breakfast)}\""
  end
end
