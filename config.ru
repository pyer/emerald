require './main.rb'
use Rack::Static, :urls => ["/css", "/images"], :root => "./"
run Main.new
