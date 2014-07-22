# twitter fetcher
Fetch tweets from twitter on the client-side without oAuth.

Loosely based on http://jasonmayes.com/projects/twitterApi/

## Installation

Install with [component(1)](http://component.io):

  $ component install slang800/twitterFetcher

Make a widget id using the following steps:
- Go to [twitter](https://twitter.com) and sign in as normal, go to your settings page.
- Go to "Widgets" on the left hand side.
- Create a new widget for what you need eg "user timeline" or "search" etc.
- Feel free to check "exclude replies" if you don't want replies in results.
- Now go back to settings page, and then go back to widgets page, you should see the widget you just created. Click edit.
- Look at the URL in your web browser, you will see a long number like this: 345735908357048478. Use this as your `id`

## Example Usage

```javascript
TwitterFetcher = require('twitterFetcher/index.js')
twitterFetcher = new TwitterFetcher()

/*
 * How to use the fetch function:

 * @param {String} id - Your Twitter widget ID.

 * @param {Int} [opts.maxTweets=20] - The maximum number of tweets you want
 * returned. Must be a number between 0 and 20.

 * @param {Boolean} [opts.showUser=true] - Set false if you don't want user
 * photo / name for tweet to show.

 * @param {Boolean} [opts.showTime=true] - Set false if you don't want time of
 * tweet to show.

 * @param {Boolean} [opts.showRt=true] - Show retweets or not. Set false to not
 * show.

 * @param {Boolean} [opts.showInteraction=true] Show links for reply, retweet,
 * favorite.

 * @return {Promise} Promise for the HTML
 */

// A simple example to get my latest tweet and write to a HTML element with
// id "example1".
twitterFetcher.fetch('345170787868762112', {
  maxTweets: 1,
}).then(function(html) {
  document.getElementById('example1').innerHTML = html
})

// A simple example to get my latest 5 of my favorite tweets and write to a HTML
// element with id "example2". Also do not not display time of post.
twitterFetcher.fetch('347099293930377217', {
  maxTweets: 5,
  showUser: true,
  showTime: false
}).then(function(html) {
  document.getElementById('example2').innerHTML = html
})

// An example to get latest 3 posts using hashtag #API and write to a HTML
// element with id "example3" without showing user details and not showing
// retweets.
twitterFetcher.fetch('345690956013633536', {
  maxTweets: 3,
  showUser: false,
  showTime: true,
  showRt: false
}).then(function(html) {
  document.getElementById('example3').innerHTML = html
})

// Here we use the fetchRaw to get the 20 posts from the widget formatted as
// pure JSON. Looping over this, we are able to extract the authors of the last
// 20 Twitter posts using hastag #API
twitterFetcher
  .fetchRaw('345690956013633536')
  .then(function(tweets) {
    var authors, tweet, _i, _len;
    authors = [];
    for (_i = 0, _len = tweets.length; _i < _len; _i++) {
      tweet = tweets[_i];
      authors.push(tweet.author);
    }
    document.getElementById('example4').innerHTML = authors.join(', ');
  })
```
