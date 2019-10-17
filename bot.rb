require 'telegram/bot'
require './bot/initializer'
require './bot/message_responder'
require './bot/context'



Telegram::Bot::Client.run(App.telegram_token) do |bot|
  bot.listen do |message|
    options = {bot: bot, message: message, context: Context.new(message.from.id, App.redis)}

    App.logger.debug message
    App.logger.debug '------------------------------------------'

    case message
  #  when Telegram::Bot::Types::CallbackQuery
  #    logger.debug "@#{message.from.username}: #{message.data}"
  #    MessageResponder.new(options).callback
    when Telegram::Bot::Types::Message
      p "@#{message.from.username}: #{message.text}"
      MessageResponder.new(options).respond
    end
  end
end

