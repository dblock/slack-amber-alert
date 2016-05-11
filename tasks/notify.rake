task :app do
  require './slack-bot-server'
end

desc 'Update missing kids data and notify teams.'
task notify: :app do
  MissingKid.update!
  MissingKidsNotifier.notify!
end

desc 'Update missing kids data.'
task update: :app do
  MissingKid.update!
end
