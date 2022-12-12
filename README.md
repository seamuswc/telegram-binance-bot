
## Telegram Binance.us Bot

Buy and sell inside of telegram

## Need a Binance US account for API KEYS.

Create API Keys. Don't allow withdraws

## Need a Telegram Bot for API KEYS.

Telegrams docs Botfather

## Server Setup: Recommend DigitalOcean & Ubuntu

    apt install ruby

    apt install build-essentials  *Literally why Ubuntu is recommended*

    git clone https://github.com/seamuswc/telegram-binance-bot.git

    touch .env

        TELEGRAM_API_KEY = 
        BINANCE_SECRET = 
        BINANCE_PUBLIC = 

    gem install bundle

    bundle install

    nohup ruby telegram.rb &

## License

This project is licensed under the MIT License
