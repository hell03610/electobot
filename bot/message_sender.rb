class MessageSender
  attr_reader :bot
  attr_reader :text
  attr_reader :chat
  attr_reader :answers

  def initialize(options)
    @bot = options[:bot]
    @text = options[:text]
    @chat = options[:chat]
    @answers = options[:answers]
  end

  def send
    if reply_markup
      bot.api.send_message(chat_id: chat.id, text: text, reply_markup: reply_markup)
    else
      bot.api.send_message(chat_id: chat.id, text: text)
    end
  end

  private

  def reply_markup
    if answers
      Telegram::Bot::Types::ReplyKeyboardMarkup
          .new(keyboard: answers.each_slice(2).to_a, one_time_keyboard: false, resize_keyboard: true)
    end
  end
end
