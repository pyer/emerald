
class Error
  def initialize(status)
    @status=status
  end

  def content
    '<html>' + 
    File.read('public/head.html').to_s +
    '<body><div id="center">' +
    "<img src=\"images/custom-error-#{@status}.gif\" alt=\"Error #{@status}\"/>" +
    '</div></body></html>'
  end

end
