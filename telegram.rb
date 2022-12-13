require 'telegram/bot'
require_relative 'binance.rb'
require 'dotenv/load'
require "logger"

class Telegram_

    def initialize()
        @t_a = ENV['TELEGRAM_API_KEY']
        @trades = Logger.new('trades.log')
        @logger = Logger.new('logs.log')
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
                    when '/balance'
                        hash = q.get_balance
                        hash.each do |k,v|
                            bot.api.send_message(chat_id: message.chat.id, text: "#{k} #{v}")
                        end
                    when '/usd'
                        usd = q.get_usd
                        bot.api.send_message(chat_id: message.chat.id, text: "#{usd} in account")

                    when '/deposit'
                        res = q.deposit
                        if !res
                            bot.api.send_message(chat_id: message.chat.id, text: "Error, no error checking yet")
                        else
                            bot.api.send_message(chat_id: message.chat.id, text: "USDC account #{res[0][:address]}")
                            bot.api.send_message(chat_id: message.chat.id, text: "USDT account #{res[1][:address]}")
                            bot.api.send_message(chat_id: message.chat.id, text: "Sell into USD afterwards with /sell command. TEST FIRST!")
                        end

                    when '/help'
                        bot.api.send_message(chat_id: message.chat.id, text: " Binance US exchange\n Min order size if $10\n /buy ticker usd-amount\n /sell ticker :SELLS IT ALL\n /usd :SHOWS USD BALANCE\n /balance :SHOWS ALL BALANCES\n /deposit :LISTS DEPOSIT ADDRESSES")
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