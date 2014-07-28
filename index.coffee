jsonp = require 'jsonp-promise'

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
  stripGarbage: (text) ->
    text.replace(/<b[^>]*>(.*?)<\/b>/g, (dataAndEvents, match) ->
      match
    ).replace /(?:class|data-[a-z-]+|rel|target)=".*?"/g, ''

  ###*
   * @param {String} id - Your Twitter widget ID.
   * @return {Promise} Promise for the raw JSON
  ###
  fetchRaw: (id) ->
    jsonp("//cdn.syndication.twimg.com/widgets/timelines/#{id}?&lang=en&suppress_response_codes=true&rnd=#{Math.random()}").then((data) =>
      result = document.createElement('div')
      result.innerHTML = data.body
      tweets = []
      for tweetElement in result.getElementsByClassName('tweet')
        tweet =
          id: tweetElement.getAttribute('data-tweet-id')
          isRetweet: 0 < tweetElement.getElementsByClassName('retweet-credit').length
          content: @stripGarbage(tweetElement.getElementsByClassName('e-entry-title')[0].innerHTML)
          time: new Date(tweetElement.getElementsByClassName('dt-updated')[0].getAttribute('datetime').replace(/-/g, '/').replace('T', ' ').split('+')[0])

        authorHTML = tweetElement.getElementsByClassName('p-author')[0]
        tweet.authorURL = authorHTML.getElementsByClassName('u-url')[0].getAttribute('href')
        tweet.author = tweet.authorURL.match(/[^/]+$/)[0]
        tweet.authorFullName = authorHTML.getElementsByClassName('full-name')[0].textContent.trim()

        avatarHTML = authorHTML.getElementsByClassName('u-photo')[0]
        tweet.authorAvatar = """
          <img src="#{avatarHTML.getAttribute('src')}" data-src-2x="#{avatarHTML.getAttribute('data-src-2x')}">
        """

        tweets.push tweet
      return tweets
    )

  ###*
   * @param {String} id - Your Twitter widget ID.

   * @param {Int} [opts.maxTweets=20] - The maximum number of tweets you want
   * returned. Must be a number between 0 and 20.

   * @param {Boolean} [opts.showUser=true] - Set false if you don't want user
   * photo / name for tweet to show.

   * @param {Boolean} [opts.showTime=true] - Set false if you don't want time of
   * tweet to show.

   * @param {Boolean} [opts.showRt=true] - Show retweets or not. Set false to
   * not show.

   * @param {Boolean} [opts.showInteraction=true] Show links for reply, retweet,
   * favorite.

   * @return {Promise} Promise for the HTML
  ###
  fetch: (id, opts) ->
    opts.maxTweets ?= 20
    opts.showUser ?= true
    opts.showTime ?= true
    opts.showRt ?= true
    opts.showInteraction ?= true

    @fetchRaw(id).then(@formatData.bind(this, opts)).catch((e) -> console.error e)

  ###*
   * @param {Array} data
   * @return {undefined}
  ###
  formatData: (opts, tweets) ->
    tweets = tweets.slice(0, opts.maxTweets) # truncate to limit tweets

    result = ''
    for tweet in tweets
      result += '<li>'
      if opts.showUser
        result += """
          <div class=\"user\">
            <a href="#{tweet.authorURL}">
              #{tweet.authorAvatar}
              <span class="full-name">#{tweet.authorFullName}</span>
              <span class="screen-name">@#{tweet.author}</span>
            </a>
          </div>
        """

      result += "<p class=\"tweet\">#{tweet.content}</p>"

      if opts.showTime
        result += "<p class=\"timePosted\">#{tweet.time}</p>"

      if opts.showInteraction
        result += """
          <p class="interact">
            <a href="https://twitter.com/intent/tweet?in_reply_to=#{tweet.id}" class="twitter_reply_icon">Reply</a>
            <a href="https://twitter.com/intent/retweet?tweet_id=#{tweet.id}" class="twitter_retweet_icon">Retweet</a>
            <a href="https://twitter.com/intent/favorite?tweet_id=#{tweet.id}" class="twitter_fav_icon">Favorite</a>
          </p>
        """
      result += '</li>'

    return "<ul>#{result}</ul>"

module.exports = TwitterFetcher
