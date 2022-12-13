#require 'sinatra'
#require 'puma'
require_relative 'telegram.rb'


q = Telegram_.new
q.start

=begin
get '/' do
    send_file 'trades.log'
end

get '/error' do
    send_file 'logs.log'
end
=end