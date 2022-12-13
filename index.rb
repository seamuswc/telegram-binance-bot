require 'sinatra'
require_relative 'telegram.rb'

q = Telegram_.new
q.start

get '/' do
    send_file 'trades.log'
end

get '/error' do
    send_file 'logs.log'
end
