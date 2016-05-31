Missing Kids in Slack
=====================

[![Build Status](https://travis-ci.org/dblock/slack-amber-alert.svg?branch=master)](https://travis-ci.org/dblock/slack-amber-alert)
[![Dependency Status](https://gemnasium.com/dblock/slack-amber-alert.svg)](https://gemnasium.com/dblock/slack-amber-alert)
[![Code Climate](https://codeclimate.com/github/dblock/slack-amber-alert.svg)](https://codeclimate.com/github/dblock/slack-amber-alert)

An amber alert bot that notifies your team of missing kids.

## Install

[![Add to Slack](https://platform.slack-edge.com/img/add_to_slack.png)](http://www.missingkidsbot.org/)

Invite *@missingkids* to a channel with `/invite @missingkids`. When an Amber Alert is issued, the bot will post a notification to that channel. You can also DM it to get the latest alerts.

![](public/img/slack_window@2x.png)

### Commands

#### missing kids [number]

Get the list of the most recent missing kids. The max number is 10 and the default is 3.

### API

The service provides a RESTful Hypermedia API wrapping the [www.missingkids.org RSS feed](http://www.missingkids.org/missingkids/servlet/XmlServlet?act=rss&LanguageCountry=en_US&orgPrefix=NCMC). Start [at the API root](http://www.missingkidsbot.org/api). The following examples retrieves a list of missing kids in Ruby with [Hyperclient](https://github.com/codegram/hyperclient).

```ruby
require 'hyperclient'

api = Hyperclient.new('http://www.missingkidsbot.org/api/missing_kids/')

api.missing_kids.each do |missing_kid|
  puts missing_kid.title
end
```

### Copyright & License

Copyright [Daniel Doubrovkine](http://code.dblock.org), [David Markovich](https://twitter.com/DavidMarkovich_) and Contributors, 2016

[MIT License](LICENSE)
