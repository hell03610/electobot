require 'redis'

class Context
  def initialize(user, redis)
    @id = user
    @redis = redis
  end

  def save_election_type(election_type)
    save(:election_type, election_type)
  end

  def get_election_type
    get(:election_type)
  end

  def save_political_party(political_party)
    save(:political_party, political_party)
  end

  def get_political_party
    get(:political_party)
  end

  def save_manifesto(id)
    save(:manifesto, id)
  end


  private

  def save(key, value)
    @redis.hset(@id, key, value)
  end

  def get(key)
    @redis.hget(@id, key)
  end
end
