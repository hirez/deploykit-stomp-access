#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'yaml'
require 'syslog'
require 'passgen'
require 'stomp'

enable :sessions
set :session_secret, 'Felle helle felle helle felle hola. Chris Waddle.'

$config = YAML.load_file("cillit-access.yaml")

def add_address
  @caddr = params[:cillitaddr] if params[:cillitaddr]
  @site = session[:site]

  @pword = Passgen::generate(:pronounceable => true, :length => 12, :lowercase => :only)

  @stompconnector = $config['stompconnector']
  @report_topic = $config["report-topic"]
  @user_topic = $config["user-topic"]
  @client = Stomp::Client.new(@stompconnector)
  
  @ssubject = "Allow access to #{@site} for #{@caddr}"
  @smessage = "Site: #{@site}\nUser: #{@caddr}\nPassword: #{@pword}\n"

  if @client
    @client.publish("/topic/#{@report_topic}",@ssubject, {:subject => "Talking to eventbot"})
    @client.publish("/topic/#{@user_topic}",@smessage, {:subject => @ssubject})
  end

  erb :results
end

def collect_address(rsite)
  @site = rsite
  session[:site] = @site

  erb :access
end

get '/' do
  erb :index
end

get '/site/:restsite' do
  @site = params[:restsite]

  if $config['sites'].include?(@site)
    collect_address(@site)
  else
    "Yer wot, pal?"
  end
end

post '/select' do
  @site = params[:cillitsite] if params[:cillitsite]

  if $config['sites'].include?(@site)
    collect_address(@site)
  else
    "Oh? Really?"
  end
end

post '/site/access' do
  add_address
end

post '/access' do
  add_address
end

