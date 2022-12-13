require "logger"
require "faraday"
require 'telegram/bot'


@t_a = "5762905502:AAGI3lM_rjruotFcg6eUx2pud9-zpiCWWuM"

def send_log(chatid) 
    puts "file path"
    file = gets.chomp
    puts file
    puts
    url = "https://api.telegram.org"
    u = "#{url}/bot#{@t_a}"
    conn = Faraday.new(
        url: u
    )
    logger = Logger.new('test.log')
    #file = 'http://127.0.0.1:4567/'
    res = conn.post('sendDocument', {chat_id: chatid, document: file })
    logger.info("#{res.body}")
end

while true
    send_log('-898559194')
end