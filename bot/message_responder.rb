require './bot/message_sender'
require 'httparty'
require 'json'

class MessageResponder
  attr_reader :message
  attr_reader :bot
  attr_reader :context

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @user = message.from.id
    @context = options[:context]
  end

  def callback
  end

  def respond
    on /^\/start/ do
      answer_with_greeting_message
    end

    on /^\/stop/ do
      answer_with_farewell_message
    end

    on /^Europeas/ do
      save_election_type(message.text)
      answer_with_political_parties
    end

    on /^Ciudadanos|Partido Popular|PSOE|Unidas Podemos/ do
      save_political_party(message.text)
      answer_with_manifesto
    end

    on /^Generales|Autonómicas/ do
      answer_with_message 'Aun no las tengo listas :('
    end
  end

  private

  def answer_with_greeting_message
    question = "Hola #{message.from.first_name}. En qué elecciones estás interesada?"
    answers = %w(Europeas Generales Autonómicas)
    answer_with_message question, answers
  end

  def answer_with_political_parties
   question = "Ah, te interesan las elecciones #{message.text.downcase}. De qué partido quieres saber sus propuestas electorales?"
   answers = %w(Ciudadanos Partido\ Popular PSOE Unidas\ Podemos Otros\ partidos)
   answer_with_message question, answers
  end

  def answer_with_manifesto
    answer_with_message "Consultado!"

    manifesto = fetch_manifesto
    save_manifesto(manifesto['id'])
    message = "#{manifesto['political_party']} tiene #{manifesto['num_proposals']} en su programa \"#{manifesto['title']}\"."
    answer_with_message message

    question = 'Quieres ver las propuestas?'
    answers = ["Vamos a ver esas propuestas!", "Ahora no me viene bien"]
    answer_with_message question, answers
  end


  def answer_with_farewell_message
    answer_with_message 'Adios :('
  end

  def save_election_type(election_type)
    context.save_election_type(election_type)
  end

  def save_political_party(political_party)
    context.save_political_party(political_party)
  end

  def save_manifesto(id)
    context.save_manifesto(id)
  end

  def fetch_manifesto
    political_party = context.get_political_party
    election_type = context.get_election_type
    url = "https://api.openmanifestoproject.org/manifestos?political_party=#{political_party}&election_type=#{election_type}"
    response = HTTParty.get(url)
    JSON.parse(response.body).first
  end

  def answer_with_message(text, answers=nil)
    MessageSender.new(bot: bot, chat: message.chat, text: text, answers: answers).send
  end

  def on regex, &block
    regex =~ message.text

    if $~
      case block.arity
      when 0
        yield
      when 1
        yield $1
      when 2
        yield $1, $2
      end
    end
  end
end
