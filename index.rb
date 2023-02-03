require_relative 'telegram.rb'

pid = fork do
 q = Telegram_.new
 q.start
end

Process.detach(pid)
