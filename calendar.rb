# encoding: UTF-8

require 'date'

class Calendar

  def initialize(lang='english')
    time = Time.new
    case lang
    when "french"
       @title = '<h3>Calendrier</h3>'
       @days_of_the_week = '<th>Dim</th><th>Lun</th><th>Mar</th><th>Mer</th><th>Jeu</th><th>Ven</th><th>Sam</th>'
       month = ['', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre']
       day   = ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi']
       @date_of_the_day = sprintf("%s  %2d %s  %s", day[time.wday], time.day, month[time.month], time.year)

#    when "german"
#       d = sprintf("%2d/%2d/%d", time.day, time.month, time.year)
    else
       @title = '<h3>Calendar</h3>'
       @days_of_the_week = '<th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri&nbsp;</th><th>Sat</th>'
       month = ['', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
       day   = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
       @date_of_the_day = sprintf("%s  %s %2d,    %s", day[time.wday], month[time.month], time.day, time.year)
    end
  end

  def date_of_the_day
    @date_of_the_day
  end

  def calendar(d='0000-00')
    y,m = d.split('-')
    y = y.to_i
    m = m.to_i
    if y==0 || m==0
      time = Time.new
      m = time.month
      y = time.year
    end
    current_m = sprintf('%04d-%02d', y, m)
    if m<=1
      prev_m = sprintf('%04d-%02d', y-1, 12)
    else
      prev_m = sprintf('%04d-%02d', y, m-1)
    end
    if m>=12
      next_m = sprintf('%04d-%02d', y+1, 1)
    else
      next_m = sprintf('%04d-%02d', y, m+1)
    end

    head = '<div class="content">' +
    '<script type="text/javascript">' +
    'cc=0;' +
    'function switchDate()' +
    '{' +
    'if (cc==0) {cc=1;} else {cc=0;}' +
    '}' +
    '</script>' +

    '<table cellpadding="2" cellspacing="0" border="1" width="100%" bgcolor="#F9F9F9">' +
    '<tr>' +
    '  <td colspan="7">' +
    '  <table cellpadding="0" cellspacing="0" border="0" width="100%">' +
    '    <tr>' +
    '      <th width="20"><a href="/?calendar=' + prev_m + '">&lt;&lt;</a></th>' +
    '   <th>'+ current_m + '</th>' +
    '   <th width="20"><a href="/?calendar=' + next_m + '">&gt;&gt;</a></th>' +
    '  </tr>' +
    '</table>' +
    '</td>' +
    '</tr>' +

    '<tr bgcolor="#CCCCCC" style="font-size:80%">' + 
    @days_of_the_week +
    '</tr>'

    # current month is y-m
    firstday = Date.new(y,m,1)
    lastday  = Date.new(y,m,-1)
    body = '<tr>'
    wday = firstday.cwday
    if wday < 7
      for i in 1..wday do
        body += '<td>&nbsp;</td>'
      end
    end
    # loop through all the days of the month
    for i in 1..lastday.day do
        body += '<tr>' if wday == 0

        #/*== check for event ==*/  
#        echo "<td><a href=\"#\" onClick=\"document.f.eventdate.value='$m-$d-$y';\">$d</a></td>";
        body += sprintf( '<td align="center"><a href="#" onClick="switchDate()">%02d</a></td>', i )
        # Saturday end week with </tr>
        body += '</tr>' if wday == 6
        wday = (wday+1) % 7;
    end
    while wday > 0 && wday < 7 do
      body += '<td>&nbsp;</td>'
      wday += 1
    end

    tail = '</tr></table></div>'
    return @title + head + body + tail
  end

end

