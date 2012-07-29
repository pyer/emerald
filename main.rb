# Rack application


require './page.rb'
require './authorization.rb'
require './error.rb'

#This is the main class of the Emerald server which is a Rack application.
#config.ru is
#  require './main.rb'
#  use Rack::Static, :urls => ["/css", "/images"], :root => "./"
#  run Main.new
class Main

  # This is call back by Rack
  def call(env)
    request  = Rack::Request.new(env)
    lang = request.cookies['lang']
    if lang.nil?
       lang='english'
    end

    cal = '0000-00'

    case request.query_string
    when 'lang=french'
       lang='french'
    when 'lang=german'
       lang='german'
    when 'lang=english'
       lang='english'
    else
       #calendar needed: 'calendar=yyyy-mm
       if request.query_string.start_with?("calendar=") 
          cal = request.query_string.slice!(9,16)
       end
    end

    case request.path_info
    when '/'
      status = '200'
      body = Page.new(lang,cal).content
    when '/admin'
      auth = Authorization.new(request)
      if auth.authorized?
        status = '200'
        body = Page.new(lang,cal).content
      else
        status = '401'
        body = Error.new(status).content
      end
    else # not found: error 404
      status = '404'
      body = Error.new(status).content
    end

    headers = {"Content-Type" => "text/html" }
    response = Rack::Response.new( [body], status, headers )
    response.set_cookie('lang', {:value => lang, :path => "/", :expires => Time.now+24*60*60})
    response.finish # finish writes out the response in the expected format.
  end

end
