require 'rubygems'
require 'sinatra'

set :env,  :production
disable :run

require './cillitaccess.rb'

run Sinatra::Application
