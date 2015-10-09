require.config
    baseUrl: './'
    paths:
        jquery: 'bower_components/jquery/dist/jquery.min'
        feed: 'js/feed'
        page: 'js/page'
        lodash: 'bower_components/lodash/dist/lodash.min'
        render: 'js/render'

require ['jquery', 'feed', 'page'], ($, feed, page) ->
    feeds = {}
    applicationStart = new Date().getTime()

    $.get 'config.json', (config) ->
        $.each config.feeds, (index, item) ->
            feeds[item.url] = feed(item)
            feeds[item.url].init ->
                feeds[item.url].render()

        page.header('#startpage-header', './templates/header.dust', config.header, () ->)()
