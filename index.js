/*********************************************************************
*  #### Twitter Post Fetcher v10.0 ####
*  Coded by Jason Mayes 2013. A present to all the developers out there.
*  www.jasonmayes.com
*  Please keep this disclaimer with my code if you use it. Thanks. :-)
*  Got feedback or questions, ask here:
*  http://www.jasonmayes.com/projects/twitterApi/
*  Updates will be posted to this site.
*********************************************************************/
var twitterFetcher = function() {
  /**
   * @param {string} text
   * @return {string}
   */
  function template(text) {
    return text.replace(/<b[^>]*>(.*?)<\/b>/gi, function(dataAndEvents, match) {
      return match;
    }).replace(/class=".*?"|data-query-source=".*?"|dir=".*?"|rel=".*?"/gi, "");
  }
  /**
   * @param {Element} list
   * @param {string} tweet
   * @return {?}
   */
  function filter(list, tweet) {
    /** @type {Array} */
    var arr = [];
    /** @type {RegExp} */
    var nocode = RegExp("(^| )" + tweet + "( |$)");
    var els = list.getElementsByTagName("*");
    /** @type {number} */
    var i = 0;
    var len = els.length;
    for (;i < len;i++) {
      if (nocode.test(els[i].className)) {
        arr.push(els[i]);
      }
    }
    return arr;
  }
  /** @type {string} */
  var field = "";
  /** @type {number} */
  var index = 20;
  /** @type {boolean} */
  var response = true;
  /** @type {Array} */
  var results = [];
  /** @type {boolean} */
  var t = false;
  /** @type {boolean} */
  var deep = true;
  /** @type {boolean} */
  var msg = true;
  /** @type {null} */
  var e = null;
  /** @type {boolean} */
  var v = true;
  /** @type {boolean} */
  var error = true;
  /** @type {null} */
  var win = null;
  /** @type {boolean} */
  var text = true;
  return{
    /*
     * How to use fetch function:
     * @param {string} Your Twitter widget ID.
     * @param {string} The ID of the DOM element you want to write results to.
     * @param {int} Optional - the maximum number of tweets you want returned. Must
     *     be a number between 1 and 20.
     * @param {boolean} Optional - set true if you want urls and hash
           tags to be hyperlinked!
     * @param {boolean} Optional - Set false if you dont want user photo /
     *     name for tweet to show.
     * @param {boolean} Optional - Set false if you dont want time of tweet
     *     to show.
     * @param {function/string} Optional - A function you can specify to format
     *     tweet date/time however you like. This function takes a JavaScript date
     *     as a parameter and returns a String representation of that date.
     *     Alternatively you may specify the string 'default' to leave it with
     *     Twitter's default renderings.
     * @param {boolean} Optional - Show retweets or not. Set false to not show.
     * @param {function/string} Optional - A function to call when data is ready. It
     *     also passes the data to this function should you wish to manipulate it
     *     yourself before outputting. If you specify this parameter you  must
     *     output data yourself!
     * @param {boolean} Optional - Show links for reply, retweet, favourite. Set false to not show.
     */
    fetch : function(query, element, options, res, type, target, parent, err, params, textAlt) {
      if (void 0 === options) {
        /** @type {number} */
        options = 20;
      }
      if (void 0 === res) {
        /** @type {boolean} */
        response = true;
      }
      if (void 0 === type) {
        /** @type {boolean} */
        type = true;
      }
      if (void 0 === target) {
        /** @type {boolean} */
        target = true;
      }
      if (void 0 === parent) {
        /** @type {string} */
        parent = "default";
      }
      if (void 0 === err) {
        /** @type {boolean} */
        err = true;
      }
      if (void 0 === params) {
        /** @type {null} */
        params = null;
      }
      if (void 0 === textAlt) {
        /** @type {boolean} */
        textAlt = true;
      }
      if (t) {
        results.push({
          id : query,
          domId : element,
          maxTweets : options,
          enableLinks : res,
          showUser : type,
          showTime : target,
          dateFunction : parent,
          showRt : err,
          customCallback : params,
          showInteraction : textAlt
        });
      } else {
        /** @type {boolean} */
        t = true;
        /** @type {string} */
        field = element;
        /** @type {number} */
        index = options;
        /** @type {boolean} */
        response = res;
        /** @type {boolean} */
        msg = type;
        /** @type {boolean} */
        deep = target;
        /** @type {boolean} */
        error = err;
        /** @type {string} */
        e = parent;
        win = params;
        /** @type {boolean} */
        text = textAlt;
        /** @type {Element} */
        element = document.createElement("script");
        /** @type {string} */
        element.type = "text/javascript";
        /** @type {string} */
        element.src = "//cdn.syndication.twimg.com/widgets/timelines/" + query + "?&lang=en&callback=twitterFetcher.callback&suppress_response_codes=true&rnd=" + Math.random();
        document.getElementsByTagName("head")[0].appendChild(element);
      }
    },
    /**
     * @param {Array} self
     * @return {undefined}
     */
    callback : function(self) {
      /** @type {Element} */
      var result = document.createElement("div");
      result.innerHTML = self.body;
      if ("undefined" === typeof result.getElementsByClassName) {
        /** @type {boolean} */
        v = false;
      }
      /** @type {Array} */
      self = [];
      /** @type {Array} */
      var list = [];
      /** @type {Array} */
      var tags = [];
      /** @type {Array} */
      var i = [];
      /** @type {Array} */
      var oSpace = [];
      /** @type {number} */
      var x = 0;
      if (v) {
        result = result.getElementsByClassName("tweet");
        for (;x < result.length;) {
          if (0 < result[x].getElementsByClassName("retweet-credit").length) {
            i.push(true);
          } else {
            i.push(false);
          }
          if (!i[x] || i[x] && error) {
            self.push(result[x].getElementsByClassName("e-entry-title")[0]);
            oSpace.push(result[x].getAttribute("data-tweet-id"));
            list.push(result[x].getElementsByClassName("p-author")[0]);
            tags.push(result[x].getElementsByClassName("dt-updated")[0]);
          }
          x++;
        }
      } else {
        result = filter(result, "tweet");
        for (;x < result.length;) {
          self.push(filter(result[x], "e-entry-title")[0]);
          oSpace.push(result[x].getAttribute("data-tweet-id"));
          list.push(filter(result[x], "p-author")[0]);
          tags.push(filter(result[x], "dt-updated")[0]);
          if (0 < filter(result[x], "retweet-credit").length) {
            i.push(true);
          } else {
            i.push(false);
          }
          x++;
        }
      }
      if (self.length > index) {
        self.splice(index, self.length - index);
        list.splice(index, list.length - index);
        tags.splice(index, tags.length - index);
        i.splice(index, i.length - index);
      }
      /** @type {Array} */
      result = [];
      /** @type {number} */
      x = self.length;
      /** @type {number} */
      i = 0;
      for (;i < x;) {
        if ("string" !== typeof e) {
          /** @type {Date} */
          var val = new Date(tags[i].getAttribute("datetime").replace(/-/g, "/").replace("T", " ").split("+")[0]);
          val = e(val);
          tags[i].setAttribute("aria-label", val);
          if (self[i].innerText) {
            if (v) {
              tags[i].innerText = val;
            } else {
              /** @type {Element} */
              var el = document.createElement("p");
              /** @type {Text} */
              var frag = document.createTextNode(val);
              el.appendChild(frag);
              el.setAttribute("aria-label", val);
              /** @type {Element} */
              tags[i] = el;
            }
          } else {
            tags[i].textContent = val;
          }
        }
        /** @type {string} */
        val = "";
        if (response) {
          if (msg) {
            val += '<div class="user">' + template(list[i].innerHTML) + "</div>";
          }
          val += '<p class="tweet">' + template(self[i].innerHTML) + "</p>";
          if (deep) {
            val += '<p class="timePosted">' + tags[i].getAttribute("aria-label") + "</p>";
          }
        } else {
          if (self[i].innerText) {
            if (msg) {
              val += '<p class="user">' + list[i].innerText + "</p>";
            }
            val += '<p class="tweet">' + self[i].innerText + "</p>";
            if (deep) {
              val += '<p class="timePosted">' + tags[i].innerText + "</p>";
            }
          } else {
            if (msg) {
              val += '<p class="user">' + list[i].textContent + "</p>";
            }
            val += '<p class="tweet">' + self[i].textContent + "</p>";
            if (deep) {
              val += '<p class="timePosted">' + tags[i].textContent + "</p>";
            }
          }
        }
        if (text) {
          val += '<p class="interact"><a href="https://twitter.com/intent/tweet?in_reply_to=' + oSpace[i] + '" class="twitter_reply_icon">Reply</a><a href="https://twitter.com/intent/retweet?tweet_id=' + oSpace[i] + '" class="twitter_retweet_icon">Retweet</a><a href="https://twitter.com/intent/favorite?tweet_id=' + oSpace[i] + '" class="twitter_fav_icon">Favorite</a></p>';
        }
        result.push(val);
        i++;
      }
      if (null == win) {
        self = result.length;
        /** @type {number} */
        list = 0;
        /** @type {(HTMLElement|null)} */
        tags = document.getElementById(field);
        /** @type {string} */
        oSpace = "<ul>";
        for (;list < self;) {
          oSpace += "<li>" + result[list] + "</li>";
          list++;
        }
        /** @type {string} */
        tags.innerHTML = oSpace + "</ul>";
      } else {
        win(result);
      }
      /** @type {boolean} */
      t = false;
      if (0 < results.length) {
        twitterFetcher.fetch(results[0].id, results[0].domId, results[0].maxTweets, results[0].enableLinks, results[0].showUser, results[0].showTime, results[0].dateFunction, results[0].showRt, results[0].customCallback, results[0].showInteraction);
        results.splice(0, 1);
      }
    }
  };
}();
