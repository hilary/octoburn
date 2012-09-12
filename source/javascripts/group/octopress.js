var octopress = (function(){
  return {
    /* Sky Slavin, Ludopoli. MIT license.  * based on JavaScript Pretty Date * Copyright (c) 2008 John Resig (jquery.com) * Licensed under the MIT license. Updated considerably by Brandon Mathis */
    prettyDate: function (time) {
      if (navigator.appName === 'Microsoft Internet Explorer') {
        return "<span>&infin;</span>"; // because IE date parsing isn't fun.
      }
      var say = {
        just_now:    " now",
        minute_ago:  "1m",
        minutes_ago: "m",
        hour_ago:    "1h",
        hours_ago:   "h",
        yesterday:   "1d",
        days_ago:    "d",
        last_week:   "1w",
        weeks_ago:   "w"
      };

      var current_date = new Date(),
          current_date_time = current_date.getTime(),
          current_date_full = current_date_time + (1 * 60000),
          date = new Date(time),
          diff = ((current_date_full - date.getTime()) / 1000),
          day_diff = Math.floor(diff / 86400);

      if (isNaN(day_diff) || day_diff < 0) { return "<span>&infin;</span>"; }

      return day_diff === 0 && (
        diff < 60 && say.just_now ||
        diff < 120 && say.minute_ago ||
        diff < 3600 && Math.floor(diff / 60) + say.minutes_ago ||
        diff < 7200 && say.hour_ago ||
        diff < 86400 && Math.floor(diff / 3600) + say.hours_ago) ||
        day_diff === 1 && say.yesterday ||
        day_diff < 7 && day_diff + say.days_ago ||
        day_diff === 7 && say.last_week ||
        day_diff > 7 && Math.ceil(day_diff / 7) + say.weeks_ago;
    }

    , renderDeliciousLinks: function (items) {
      var output = "<ul>";
      for (var i=0,l=items.length; i<l; i++) {
        output += '<li><a href="' + items[i].u + '" title="Tags: ' + (items[i].t == "" ? "" : items[i].t.join(', ')) + '">' + items[i].d + '</a></li>';
      }
      output += "</ul>";
      $('#delicious').html(output);
    }

    , github: (function(){

      htmlEscape = function (str) {
        return String(str)
          .replace(/&/g, '&amp;')
          .replace(/"/g, '&quot;')
          .replace(/'/g, '&#39;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;');
      }

      function render(target, data){
        var i = 0, repos = '';

        for(i = 0; i < data.length; i++) {
          repos += '<li><a href="'+data[i].html_url+'">'+htmlEscape(data[i].name)+'</a><p>'+htmlEscape(data[i].description)+'</p></li>';
        }
        target.html(repos);
      }
      return {
        showRepos: function(target){
          target = $(target);
          if (target.length == 0) return;
          var user = target.attr('data-user')
          var count = parseInt(target.attr('data-count'))
          var skip_forks = target.attr('data-skip') == 'true';
          $.ajax({
              url: "https://api.github.com/users/"+user+"/repos?callback=?"
            , dataType: 'jsonp'
            , error: function (err) { target.find('.loading').addClass('error').text("Error loading feed"); }
            , success: function(data) {
              var repos = [];
              if (!data.data) { return; }
              for (var i = 0; i < data.data.length; i++) {
                if (skip_forks && data.data[i].fork) { continue; }
                repos.push(data.data[i]);
              }
              repos.sort(function(a, b) {
                var aDate = new Date(a.pushed_at).valueOf(),
                    bDate = new Date(b.pushed_at).valueOf();

                if (aDate === bDate) { return 0; }
                return aDate > bDate ? -1 : 1;
              });

              if (count) { repos.splice(count); }
              render(target, repos);
            }
          });
        }
      };
    })()
  }
})();

$(document).ready(function() {
  octopress.github.showRepos('#gh_repos');
});

var htmlEncode = (function() {
  var entities = {
    '&' : '&amp;'
    , '<' : '&lt;'
    , '"' : '&quot;'
  };

  return function(value) {
    return value.replace(/[&<"]/g, function(c) {
      return entities[c];
    });
  };
})();

