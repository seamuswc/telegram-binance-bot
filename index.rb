require 'sinatra'
require 'puma'
require_relative 'telegram.rb'

get '/' do
    send_file 'trades.log'
end

get '/error' do
    send_file 'logs.log'
end

get '/start' do
    q = Telegram_.new
    q.start
end