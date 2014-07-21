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
   * @type {string}
  ###
  field: ''

  ###*
   * @type {number}
  ###
  index: 20

  ###*
   * @type {boolean}
  ###
  response: true

  ###*
   * @type {Array}
  ###
  results: []

  ###*
   * @type {boolean}
  ###
  t: false

  ###*
   * @type {boolean}
  ###
  deep: true

  ###*
   * @type {boolean}
  ###
  msg: true

  ###*
   * @type {null}
  ###
  e: null

  ###*
   * @type {boolean}
  ###
  v: true

  ###*
   * @type {boolean}
  ###
  error: true

  ###*
   * @type {null}
  ###
  win: null

  ###*
   * @type {boolean}
  ###
  text: true

  ###*
   * @param {string} text
   * @return {string}
  ###
  template: (text) ->
    if text?
      text.replace(/<b[^>]*>(.*?)<\/b>/g, (dataAndEvents, match) ->
        match
      ).replace /class=".*?"|data-query-source=".*?"|dir=".*?"|rel=".*?"/g, ''
    else
      ''

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
   * How to use fetch function:

   * @param {string} Your Twitter widget ID.

   * @param {string} The ID of the DOM element you want to write results to.

   * @param {int} Optional - the maximum number of tweets you want returned.
   * Must be a number between 1 and 20.

   * @param {boolean} Optional - set true if you want urls and hash
   * tags to be hyperlinked!

   * @param {boolean} Optional - Set false if you dont want user photo /
   * name for tweet to show.

   * @param {boolean} Optional - Set false if you dont want time of tweet
   * to show.

   * @param {function/string} Optional - A function you can specify to format
   * tweet date/time however you like. This function takes a JavaScript date
   * as a parameter and returns a String representation of that date.
   * Alternatively you may specify the string 'default' to leave it with
   * Twitter's default renderings.

   * @param {boolean} Optional - Show retweets or not. Set false to not show.

   * @param {function/string} Optional - A function to call when data is ready.
   * It also passes the data to this function should you wish to manipulate
   * it yourself before outputting. If you specify this parameter you  must
   * output data yourself!

   * @param {boolean} Optional - Show links for reply, retweet, favourite. Set
   * false to not show.
  ###
  fetch: (query, element, options = 20, res, type = true, target = true, dateFunction = 'default', showRt = true, params = null, textAlt = true) ->

    ###*
     * @type {boolean}
    ###
    @response = true if not res?

    if @t
      @results.push
        id: query
        domId: element
        maxTweets: options
        enableLinks: res
        showUser: type
        showTime: target
        dateFunction: dateFunction
        showRt: showRt
        customCallback: params
        showInteraction: textAlt
    else

      ###*
       * @type {boolean}
      ###
      @t = true

      ###*
       * @type {string}
      ###
      @field = element

      ###*
       * @type {number}
      ###
      @index = options

      ###*
       * @type {boolean}
      ###
      @response = res

      ###*
       * @type {boolean}
      ###
      @msg = type

      ###*
       * @type {boolean}
      ###
      @deep = target

      ###*
       * @type {boolean}
      ###
      @error = showRt

      ###*
       * @type {string}
      ###
      @e = dateFunction
      @win = params

      ###*
       * @type {boolean}
      ###
      @text = textAlt

      jsonp("//cdn.syndication.twimg.com/widgets/timelines/#{query}?&lang=en&suppress_response_codes=true&rnd=#{Math.random()}", {}, @callback)
    return

  ###*
   * @param {Array} data
   * @return {undefined}
  ###
  callback: (err, data) =>

    ###*
     * @type {Element}
    ###
    result = document.createElement('div')
    result.innerHTML = data.body

    ###*
     * @type {boolean}
    ###
    @v = false if not result.getElementsByClassName?

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
    if @v
      result = result.getElementsByClassName('tweet')
      while x < result.length
        if 0 < result[x].getElementsByClassName('retweet-credit').length
          i.push true
        else
          i.push false
        if not i[x] or i[x] and @error
          data.push result[x].getElementsByClassName('e-entry-title')[0]
          oSpace.push result[x].getAttribute('data-tweet-id')
          list.push result[x].getElementsByClassName('p-author')[0]
          tags.push result[x].getElementsByClassName('dt-updated')[0]
        x++
    else
      result = @filter(result, 'tweet')
      while x < result.length
        data.push @filter(result[x], 'e-entry-title')[0]
        oSpace.push result[x].getAttribute('data-tweet-id')
        list.push @filter(result[x], 'p-author')[0]
        tags.push @filter(result[x], 'dt-updated')[0]
        if 0 < @filter(result[x], 'retweet-credit').length
          i.push true
        else
          i.push false
        x++
    if data.length > @index
      data.splice @index, data.length - @index
      list.splice @index, list.length - @index
      tags.splice @index, tags.length - @index
      i.splice @index, i.length - @index

    ###*
     * @type {Array}
    ###
    result = []

    ###*
     * @type {number}
    ###
    x = data.length

    ###*
     * @type {number}
    ###
    i = 0
    while i < x
      if 'string' isnt typeof @e

        ###*
         * @type {Date}
        ###
        val = new Date(tags[i]?.getAttribute('datetime').replace(/-/g, '/').replace('T', ' ').split('+')[0])
        val = @e(val)
        tags[i].setAttribute 'aria-label', val
        if data[i].innerText
          if @v
            tags[i].innerText = val
          else

            ###*
             * @type {Element}
            ###
            el = document.createElement('p')

            ###*
             * @type {Text}
            ###
            frag = document.createTextNode(val)
            el.appendChild frag
            el.setAttribute 'aria-label', val

            ###*
             * @type {Element}
            ###
            tags[i] = el
        else
          tags[i].textContent = val

      ###*
       * @type {string}
      ###

      val = ''
      if @response
        val += "<div class=\"user\">#{@template(list[i]?.innerHTML)}</div>" if @msg
        val += "<p class=\"tweet\">#{@template(data[i]?.innerHTML)}</p>"
        val += "<p class=\"timePosted\">#{tags[i]?.getAttribute("aria-label")}</p>" if @deep
      else
        if data[i].innerText
          val += "<p class=\"user\">#{list[i]?.innerText}</p>" if @msg
          val += "<p class=\"tweet\">#{data[i]?.innerText}</p>"
          val += "<p class=\"timePosted\">#{tags[i]?.innerText}</p>" if @deep
        else
          val += "<p class=\"user\">#{list[i]?.textContent}</p>" if @msg
          val += "<p class=\"tweet\">#{data[i]?.textContent}</p>"
          val += "<p class=\"timePosted\">#{tags[i]?.textContent}</p>" if @deep
      val += "<p class=\"interact\"><a href=\"https://twitter.com/intent/tweet?in_reply_to=#{oSpace[i]}\" class=\"twitter_reply_icon\">Reply</a><a href=\"https://twitter.com/intent/retweet?tweet_id=#{oSpace[i]}\" class=\"twitter_retweet_icon\">Retweet</a><a href=\"https://twitter.com/intent/favorite?tweet_id=#{oSpace[i]}\" class=\"twitter_fav_icon\">Favorite</a></p>" if @text
      result.push val
      i++
    if null is @win
      data = result.length

      ###*
       * @type {number}
      ###
      list = 0

      ###*
       * @type {(HTMLElement|null)}
      ###
      tags = document.getElementById(@field)

      ###*
       * @type {string}
      ###
      oSpace = '<ul>'
      while list < data
        oSpace += "<li>#{result[list]}</li>"
        list++

      ###*
       * @type {string}
      ###
      tags.innerHTML = "#{oSpace}</ul>"
    else
      @win result

    ###*
     * @typ{boolean}
    ###
    @t = false
    if 0 < @results.length
      @fetch @results[0].id, @results[0].domId, @results[0].maxTweets, @results[0].enableLinks, @results[0].showUser, @results[0].showTime, @results[0].dateFunction, @results[0].showRt, @results[0].customCallback, @results[0].showInteraction
      @results.splice 0, 1
    return

module.exports = TwitterFetcher
