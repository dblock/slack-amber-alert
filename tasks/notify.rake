task :app do
  require './slack-bot-server'
end

desc 'Update missing children data and notify teams.'
task notify: :app do
  MissingChild.update!
  MissingChildrenNotifier.notify!
end
