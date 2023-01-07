require 'telegram/bot'
require_relative 'binance.rb'
require 'dotenv/load'
require "logger"

class Telegram_

    def initialize()
        @t_a = ENV['TELEGRAM_API_KEY']
        if ENV['NGINX'] == 1
            @trades = Logger.new('../var/www/html/trades.log')
            @logger = Logger.new('../var/www/html/logs.log')
        else
            @trades = Logger.new('trades.log')
            @logger = Logger.new('logs.log')
        end
    end


    def start
        Telegram::Bot::Client.run(@t_a) do |bot|
            q = Exchange.new
            bot.listen do |message|
            begin
                if message.nil?
                    puts 'message nil'
                    m = [nil]
                else
                    m = message.text&.split
                    m = [nil] if m.nil?
                end
                m[0].downcase! unless m[0].nil?
                case m[0]
                    when '/buy'
                        if m.count == 3 then
                            if q.purchase(m[1], m[2]) 
                                bot.api.send_message(chat_id: message.chat.id, text: "Bought $#{m[2]} of #{m[1]}")
                                @trades.info("#{message.from.first_name} bought $#{m[2]} of #{m[1]}\n")
                            else
                                bot.api.send_message(chat_id: message.chat.id, text: "Purchase unsuccesul, no error checking yet, most common error is coin ticker not on binance exchange")
                            end
                        else
                            bot.api.send_message(chat_id: message.chat.id, text: "Wrong number of commands, #{message.from.first_name}")
                        end
                    when '/custombuy'
                        if m.count == 3 then
                            if q.custom_purchase(m[1], m[2]) 
                                bot.api.send_message(chat_id: message.chat.id, text: "Bought $#{m[2]} of #{m[1]}")
                                @trades.info("#{message.from.first_name} bought $#{m[2]} of #{m[1]}\n")
                            else
                                bot.api.send_message(chat_id: message.chat.id, text: "Purchase unsuccesul, no error checking yet, most common error is coin ticker not on binance exchange")
                            end
                        else
                            bot.api.send_message(chat_id: message.chat.id, text: "Wrong number of commands, #{message.from.first_name}")
                        end
                    when '/sell'
                        if m.count == 2 then
                            res = q.sell(m[1])
                            if !res 
                                bot.api.send_message(chat_id: message.chat.id, text: "selling unsuccesul, no error checking yet, most common error is sell order min is $10")
                            else
                                bot.api.send_message(chat_id: message.chat.id, text: "sold #{res[1]} #{m[1]}")
                                @trades.info("#{message.from.first_name} sold #{res[1]} #{m[1]}\n")

                            end
                        else
                            bot.api.send_message(chat_id: message.chat.id, text: "Wrong number of commands #{m.count} #{m}, #{message.from.first_name}")
                        end
                    when '/customsell'
                        if m.count == 2 then
                            res = q.custom_sell(m[1])
                            if !res 
                                bot.api.send_message(chat_id: message.chat.id, text: "selling unsuccesul, no error checking yet, most common error is sell order min is $10")
                            else
                                bot.api.send_message(chat_id: message.chat.id, text: "sold #{res[1]} #{m[1]}")
                                @trades.info("#{message.from.first_name} sold #{res[1]} #{m[1]}\n")

                            end
                        else
                            bot.api.send_message(chat_id: message.chat.id, text: "Wrong number of commands #{m.count} #{m}, #{message.from.first_name}")
                        end
                    when '/balance'
                        hash = q.get_balance
                        hash.each do |k,v|
                            bot.api.send_message(chat_id: message.chat.id, text: "#{k} #{v}")
                        end
                    when '/usd'
                        res = q.get_usd
                        bot.api.send_message(chat_id: message.chat.id, text: "#{res[0]} #{res[1]} in account")

                    when '/deposit'
                        res = q.deposit
                        if !res
                            bot.api.send_message(chat_id: message.chat.id, text: "Error, no error checking yet")
                        else
                            bot.api.send_message(chat_id: message.chat.id, text: "USDC account #{res[0][:address]}")
                            bot.api.send_message(chat_id: message.chat.id, text: "USDT account #{res[1][:address]}")
                            bot.api.send_message(chat_id: message.chat.id, text: "Sell into USD afterwards with /sell command. TEST FIRST!")
                        end
                    when '/base'
                        res = q.change_base
                        bot.api.send_message(chat_id: message.chat.id, text: "Base currency is switched to #{res}")
                    when '/help'
                        a = []
                        a << "Binance US exchange" 
                        a << "Min order size if $10" 
                        a << "/buy ticker usd-amount" 
                        a << "/sell ticker :SELLS IT ALL" 
                        a << "/usd :SHOWS USD BALANCE" 
                        a << "/balance :SHOWS ALL BALANCES" 
                        a << "/deposit :LISTS DEPOSIT ADDRESSES"
                        a << "/base :switches base currency between USD and USDT"
                        a << "/chat_id :gets the chat if of current group"
                        a << "/logs :IP address with trade logs"

                        text = ""
                        a.each { |q| text << q + "\n"}

                        bot.api.send_message(chat_id: message.chat.id, text: text)
                    when '/logs'
                        bot.api.send_message(chat_id: message.chat.id, text: "#{ENV['IP']}")
                    when '/chat_id'
                        bot.api.send_message(chat_id: message.chat.id, text: "#{message.chat.id}")
                    else
                        bot.api.send_message(chat_id: message.chat.id, text: "Command not found")
                    end

                rescue=>e
                    puts "error"
                    @logger.error("#{e}")
                    next
                end

            end #2nd do block
        end #1st do block
    end

end