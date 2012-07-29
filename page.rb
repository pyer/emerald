# encoding: UTF-8

require './calendar.rb'

class Page
  def initialize(lang,cal)
    @lang=lang
    @calendar=cal
  end

  def href(n,s)
    return '<li><a href="'+n+'">'+s+'</a></li>'
  end

  def flags
    name = {
        'english' => 'English',
        'french'  => 'Français'
        # 'german'  => 'Deutsche'
    }
    f = ''
    name.each { |k,n|
        f += "<li class=flags><a href=\"/?lang=#{k}\" title=\"#{n}\">" +
        "<img src=\"/images/#{k}.png\" width=\"24\" height=\"18\"/></a></li>"
    }
    return f
  end

  def header(date)
    '<div id="header"><h1><span>Pierre </span>BAZONNARD<sup>1.0</sup></h1>' +
                     '<h2>My personal web site</h2></div>' +
    '<div id="date">' + date + '</div>' +
    '<div id="splash"></div>' +
    '<div id="menu"><ul>' +
	href('/','Home') +
	href('/album','Album') +
	href('/wiki','Wiki') +
	href('/admin','Administration') +
	href('/','Contact') +
     flags +
    '</ul></div>'
  end

  def footer
    '&copy; My Website. All rights reserved. Design by <a href="http://www.nodethirtythree.com/">NodeThirtyThree</a>.'
  end

  def content
    c = Calendar.new(@lang)
    '<html>' + 
    File.read('public/head.html').to_s +
    '<body>' +
    '<div id="main">' + header(c.date_of_the_day) +
     '<div id="primarycontent">' +
     File.read("public/#{@lang}content.html").to_s +
     '</div>' +
     '<div id="secondarycontent">' +
     File.read("public/#{@lang}about.html").to_s +
     c.calendar(@calendar) +
     File.read("public/#{@lang}topics.html").to_s +
     '</div>' +
    '</div>' +
    '<div id="footer">' + footer + '</div>' +
    '</body>' +
    '</html>'
  end

end
