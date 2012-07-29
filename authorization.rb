
class Authorization
  def initialize(req)
    @req=req
  end

    # Redefine this method on your helpers block to actually contain
    # your authorization logic.
    def authorize(username, password)
p username
p password
      username == settings.username && password == settings.password
    end

    # Call in any event that requires authentication
    def login_required
      return if authorized?
      unauthorized! unless auth.provided?
      bad_request!  unless auth.basic?
      unauthorized! unless authorize(*auth.credentials)
      @req.env['REMOTE_USER'] = auth.username
    end

    # Convenience method to determine if a user is logged in
    def authorized?
      !!@req.env['REMOTE_USER']
    end

    # Name provided by the current user to log in
    def current_user
      @req.env['REMOTE_USER']
    end

    private
      def auth
        @auth ||= Rack::Auth::Basic::Request.new(@req.env)
      end

      def unauthorized!(realm="Secure Area")
        response["WWW-Authenticate"] = %(Basic realm="#{realm}")
        throw :halt, [ 401, 'Authorization Required' ]
      end

      def bad_request!
        throw :halt, [ 400, 'Bad Request' ]
      end
end
