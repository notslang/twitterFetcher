# twitter fetcher
Fetch tweets from twitter on the client-side without oAuth.

Based on http://jasonmayes.com/projects/twitterApi/

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
 */

// Simple example 1
// A simple example to get my latest tweet and write to a HTML element with
// id "tweets". Also automatically hyperlinks URLS and user mentions and
// hashtags.
twitterFetcher.fetch({
  id: '345170787868762112',
  domId: 'example1',
  maxTweets: 1,
  enableLinks: true
});

// Simple example 2
// A simple example to get my latest 5 of my favourite tweets and write to a HTML
// element with id "talk". Also automatically hyperlinks URLS and user mentions and
// hashtags but does not display time of post.
twitterFetcher.fetch({
  id: '347099293930377217',
  domId: 'example2',
  maxTweets: 5,
  enableLinks: true,
  showUser: true,
  showTime: false
});


// Advanced example
// An advance example to get latest 5 posts using hashtag #API and write to a
// HTML element with id "tweets2" without showing user details and using a
// custom format to display the date/time of the post, and does not show
// retweets.
twitterFetcher.fetch({
  id: '345690956013633536',
  domId: 'example3',
  maxTweets: 3,
  enableLinks: true,
  showUser: false,
  showTime: true,
  dateFunction: dateFormatter,
  showRt: false
});

// For advanced example which allows you to customize how tweet time is
// formatted you simply define a function which takes a JavaScript date as a
// parameter and returns a string.
function dateFormatter(date) {
  return date.toTimeString();
}


// Advanced example 2
// Similar as previous, except this time we pass a custom function to render the
// tweets ourself! Useful if you need to know exactly when data has returned or
// if you need full control over the output.
twitterFetcher.fetch({
  id: '345690956013633536',
  domId: 'example4',
  maxTweets: 3,
  enableLinks: true,
  showUser: true,
  showTime: true,
  showRt: false,
  customCallback: handleTweets
});

function handleTweets(tweets){
  var x = tweets.length;
  var n = 0;
  var element = document.getElementById('example4');
  var html = '<ul>';
  while(n < x) {
    html += '<li>' + tweets[n] + '</li>';
    n++;
  }
  html += '</ul>';
  element.innerHTML = html;
}
```
