
## Telegram Binance.us Bot

Buy and sell inside of telegram

## Need a Binance US account for API KEYS.

Create API Keys. Don't allow withdraws

## Need a Telegram Bot for API KEYS.

Telegrams docs Botfather

## Server Setup: Recommend DigitalOcean & Ubuntu

    apt install ruby

    apt install build-essential  *Literally why Ubuntu is recommended*
    apt install ruby-dev
    
    git clone https://github.com/seamuswc/telegram-binance-bot.git

    touch .env

        TELEGRAM_API_KEY = 
        BINANCE_SECRET = 
        BINANCE_PUBLIC = 

    gem install bundle

    bundle install

    ruby index.rb

## NOTE!!

    This creates a FORK and then detaches it.
    The process will run in the background until you manually kill the process using it's PID number, or shutdown the machine.


## License


This project is licensed under the MIT License
