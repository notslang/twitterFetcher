jsonp = require 'jsonp'

###
 * Twitter Post Fetcher v10.0
 * Coded by Jason Mayes 2013. A present to all the developers out there.
 * www.jasonmayes.com
 * Please keep this disclaimer with my code if you use it. Thanks. :-)
 * Got feedback or questions, ask here:
 * http://www.jasonmayes.com/projects/twitterApi/
###
class TwitterFetcher

  ###*
   * @param {string} text
   * @return {string}
  ###
  template: (text) ->
    text.replace(/<b[^>]*>(.*?)<\/b>/g, (dataAndEvents, match) ->
      match
    ).replace /class=".*?"|data-query-source=".*?"|dir=".*?"|rel=".*?"/g, ''

  ###*
   * @param {Element} list
   * @param {string} tweet
   * @return {Array}
  ###
  filter: (list, tweet) ->

    ###*
     * @type {Array}
    ###
    arr = []

    ###*
     * @type {RegExp}
    ###
    nocode = ///(^| )#{tweet}( |$)///
    els = list.getElementsByTagName('*')

    ###*
     * @type {number}
    ###
    i = 0
    len = els.length
    while i < len
      arr.push els[i] if nocode.test(els[i].className)
      i++
    arr

  ###*
   * [fetch description]
   * @param {String} opts.id - Your Twitter widget ID.

   * @param {String} opts.domId - The ID of the DOM element you want to write
   * results to.

   * @param {Int} [opts.maxTweets=20] - The maximum number of tweets you want
   * returned. Must be a number between 1 and 20.

   * @param {Boolean} [opts.enableLinks=true] - Set true if you want urls and
   * hash tags to be hyperlinked

   * @param {Boolean} [opts.showUser=true] - Set false if you dont want user
   * photo / name for tweet to show.

   * @param {Boolean} [opts.showTime=true] - Set false if you dont want time of
   * tweet to show.

   * @param {Function} [opts.dateFunction] - A function you can specify to
   * format tweet date/time however you like. This function takes a JavaScript
   * date as a parameter and returns a String representation of that date.
   * Alternatively you may specify the string 'default' to leave it with
   * Twitter's default renderings.

   * @param {Boolean} [opts.showRt=true] - Show retweets or not. Set false to
   * not show.

   * @param {Function} [opts.customCallback] A function to call when data is
   * ready. It also passes the data to this function should you wish to
   * manipulate it yourself before outputting. If you specify this parameter you
   * must output data yourself!

   * @param {Boolean} [opts.showInteraction=true] Show links for reply, retweet,
   * favourite.

   * @return {Boolean} [description]
  ###
  fetch: (opts) ->
    #opts.id
    #opts.domId
    opts.maxTweets ?= 20
    opts.enableLinks ?= true
    opts.showUser ?= true
    opts.showTime ?= true
    opts.dateFunction ?= (x) -> x
    opts.showRt ?= true
    opts.customCallback ?= null
    opts.showInteraction ?= true

    jsonp(
      "//cdn.syndication.twimg.com/widgets/timelines/#{opts.id}?&lang=en&suppress_response_codes=true&rnd=#{Math.random()}"
      {}
      @callback.bind(this, opts)
    )
    return

  ###*
   * @param {Array} data
   * @return {undefined}
  ###
  callback: (opts, err, data) ->
    if err then throw new Error(err)

    ###*
     * @type {Element}
    ###
    result = document.createElement('div')
    result.innerHTML = data.body

    ###*
     * @type {Array}
    ###
    data = []

    ###*
     * @type {Array}
    ###
    list = []

    ###*
     * @type {Array}
    ###
    tags = []

    ###*
     * @type {Array}
    ###
    i = []

    ###*
     * @type {Array}
    ###
    oSpace = []

    ###*
     * @type {number}
    ###
    x = 0
    result = result.getElementsByClassName('tweet')
    while x < result.length
      if 0 < result[x].getElementsByClassName('retweet-credit').length
        i.push true
      else
        i.push false
      if not i[x] or i[x] and opts.showRt
        data.push result[x].getElementsByClassName('e-entry-title')[0]
        oSpace.push result[x].getAttribute('data-tweet-id')
        list.push result[x].getElementsByClassName('p-author')[0]
        tags.push result[x].getElementsByClassName('dt-updated')[0]
      x++

    if data.length > opts.maxTweets
      data.splice opts.maxTweets, data.length - opts.maxTweets
      list.splice opts.maxTweets, list.length - opts.maxTweets
      tags.splice opts.maxTweets, tags.length - opts.maxTweets
      i.splice opts.maxTweets, i.length - opts.maxTweets

    ###*
     * @type {Array}
    ###
    result = []

    for i in [0...data.length]
      ###*
       * @type {Date}
      ###
      val = new Date(tags[i].getAttribute('datetime').replace(/-/g, '/').replace('T', ' ').split('+')[0])
      val = opts.dateFunction(val)
      tags[i].setAttribute 'aria-label', val
      tags[i].textContent = val

      ###*
       * @type {string}
      ###
      val = ''

      if opts.enableLinks
        if opts.showUser
          val += "<div class=\"user\">#{@template(list[i].innerHTML)}</div>"
        val += "<p class=\"tweet\">#{@template(data[i].innerHTML)}</p>"
        if opts.showTime
          val += "<p class=\"timePosted\">#{tags[i].getAttribute("aria-label")}</p>"
      else
        if data[i].innerText
          if opts.showUser
            val += "<p class=\"user\">#{list[i].innerText}</p>"
          val += "<p class=\"tweet\">#{data[i].innerText}</p>"
          if opts.showTime
            val += "<p class=\"timePosted\">#{tags[i].innerText}</p>"
        else
          if opts.showUser
            val += "<p class=\"user\">#{list[i].textContent}</p>"
          val += "<p class=\"tweet\">#{data[i].textContent}</p>"
          if opts.showTime
            val += "<p class=\"timePosted\">#{tags[i].textContent}</p>"
      if opts.showInteraction
        val += """
          <p class="interact">
            <a href="https://twitter.com/intent/tweet?in_reply_to=#{oSpace[i]}" class="twitter_reply_icon">Reply</a>
            <a href="https://twitter.com/intent/retweet?tweet_id=#{oSpace[i]}" class="twitter_retweet_icon">Retweet</a>
            <a href="https://twitter.com/intent/favorite?tweet_id=#{oSpace[i]}" class="twitter_fav_icon">Favorite</a>
          </p>
        """
      result.push val

    if not opts.customCallback
      data = result.length

      ###*
       * @type {number}
      ###
      list = 0

      ###*
       * @type {(HTMLElement|null)}
      ###
      tags = document.getElementById(opts.domId)

      ###*
       * @type {string}
      ###
      oSpace = '<ul>'
      while list < data
        oSpace += "<li>#{result[list]}</li>"
        list++

      tags.innerHTML = "#{oSpace}</ul>"
    else
      opts.customCallback result

    return

module.exports = TwitterFetcher
