require 'binance'
require 'dotenv/load'

class Exchange

    def initialize()
        b_p = ENV['BINANCE_PUBLIC']
        b_s = ENV['BINANCE_SECRET']
        @client = Binance::Spot.new(base_url: 'https://api.binance.us', key: b_p, secret: b_s)
        @base = "USD"
    end
 
    def purchase(ticker, quantity) 
    
        begin
            ticker.upcase!
            ticker = "#{ticker}"+@base
            params = {
                side: 'BUY',
                symbol: ticker,
                type: 'MARKET',
                quoteOrderQty: quantity
            }

            @client.new_order(**params)  
            return true
        rescue => e
            return false
        end
        

    end

    def sell(ticker) 
        begin
            ticker.upcase!
            rounder = 2
            rounder = 9 if ( (ticker == "BTC") or (ticker == "ETH") )
            quantity = get_balance(ticker)
            ticker = "#{ticker}"+@base
            quantity = (quantity.to_f).floor(rounder)

            params = {
                side: 'SELL',
                symbol: ticker,
                type: 'MARKET',
                quantity: quantity
                }

            @client.new_order(**params)  
            return [true, quantity]
        rescue => e
            puts e
            return false
        end
        

    end

    def get_balance(ticker = nil)
        begin
            balance = { }
            balances =  @client.account[:balances]
            balances.each do |i|
                return i[:free] if i[:asset] == ticker
                if i[:free].to_f > 0
                    balance[i[:asset]] = i[:free]
                end
            end
            #this is a hash
            return balance
        rescue
            return false
        end
    end

    def get_usd
        begin
            usd_balance = 0;
            balances =  @client.account[:balances]
            balances.each do |i|
                if i[:asset] == @base
                    usd_balance = i[:free]
                end
            end
            #this is a string
            return [usd_balance, @base]
        rescue
            return false
        end
    end

    def deposit
        begin
            usdc = @client.deposit_address(coin: 'USDC')
            usdt = @client.deposit_address(coin: 'USDT')
            return [usdc, usdt]
        rescue
            return false
        end
    end

    def change_base
        if @base == "USD"
            @base = "USDT"
            return "USDT"
        else
            @base = "USD"
            return "USD"
        end
    end




end #class end
