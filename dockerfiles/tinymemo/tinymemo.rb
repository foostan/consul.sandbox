require 'sinatra/base'
require 'yaml'
require 'redis'

class App < Sinatra::Base
  set :environment, :production
  set :port, 80

  get '/' do
    @memos = memos(sredis)
    erb :index
  end

  post '/' do
    store(mredis, params[:memo])
    @memos = memos(mredis)
    erb :index
  end

  def store(redis, value)
    redis.lpush("memos", value)
  end

  def memos(redis)
    memos = []
    redis.lrange("memos", 0, -1) do |v|
      memos << v
    end
  end

  private

  def conf
    @conf ||= YAML.load(File.read('config.yml'))
  end

  def mredis
    @mredis ||= Redis.new(conf['db']['master'])
  end

  def sredis
    @sredis ||= Redis.new(conf['db']['slave'])
  end
end

App.run!
