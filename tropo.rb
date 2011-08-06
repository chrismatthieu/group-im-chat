require 'rubygems'
require 'net/http'
require 'json'

module Couch

  class Server
    def initialize(host, port, options = nil)
      @host = host
      @port = port
      @options = options
    end

    def delete(uri)
      request(Net::HTTP::Delete.new(uri))
    end

    def get(uri)
      request(Net::HTTP::Get.new(uri))
    end

    def put(uri, json)
      req = Net::HTTP::Put.new(uri)
      req["content-type"] = "application/json"
      req.body = json
      request(req)
    end

    def post(uri, json)
      req = Net::HTTP::Post.new(uri)
      req["content-type"] = "application/json"
      req.body = json
      request(req)
    end

    def request(req)
      res = Net::HTTP.start(@host, @port) { |http|http.request(req) }
      unless res.kind_of?(Net::HTTPSuccess)
        handle_error(req, res)
      end
      res
    end

    private

    def handle_error(req, res)
      e = RuntimeError.new("#{res.code}:#{res.message}\nMETHOD:#{req.method}\nURI:#{req.path}\n#{res.body}")
      raise e
    end
  end
end

server = Couch::Server.new("tropo.couchone.com", "80")

data = $currentCall.initialText.split(':')
jid = data[0]
username = data[1]
chatroom = data[2]
msg = data[3]

# message username + ":" + msg, {
#    :to => jid,
#    :network => "JABBER"}

if jid.index("phono.com")
  begin
    res = server.get("/githubchat/" + chatroom)
    jsonresp = res.body
    dbdata = JSON.parse(jsonresp)
    jids = dbdata["jids"].to_s
    if msg == "joined"
      jids = jids + "," + jid
      res = server.put("/githubchat/" + chatroom, '{ "jids":"' + jids.to_s + '", "_rev":"' + dbdata["_rev"].to_s + '" }')
    end
  rescue # not found
    jids = jid
    res = server.post("/githubchat", '{ "_id":"' + chatroom + '", "jids":"' + jids.to_s + '" }')
  end
end

if msg and jids

  jidsarray = jids.split(",");
  jidsarray.each do |client|   
  
    message username + ":" + msg, {
       :to => client,
       :network => "JABBER"}

  end
  
end