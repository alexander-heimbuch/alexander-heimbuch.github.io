# RSS Feed Framework
define ['jquery', 'render'], ($, render) ->

    feed = (config) ->

        storage = window.localStorage
        items = []

        init = (cb) ->
            _clearCache()

            _resolve (feedItems) ->
                $.each feedItems, (index, item) ->
                    item.visited = _checkStorage item
                    items.push item
                    cb()

        _onVisit = () ->
            $('li').on 'click', () ->
                link = $(this).data 'link'
                $(this).addClass 'visited'
                storage.setItem link, new Date().getTime()
                location.href = link

        _checkStorage = (item) ->
            if localStorage.getItem item.link
                return 'visited'
            return ''

        _clearCache = () ->
            $.each storage, (url, time) ->
                if (time + (60 * 1000 * 60 * 24)) < new Date().getTime()
                    storage.removeItem url

        _resolve = (cb) ->
            $.ajax
                url: document.location.protocol + '//ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=10&callback=?&q=' + (encodeURIComponent config.url),
                dataType : 'json',
                success : (data) ->
                    if !data.responseData.feed or !data.responseData.feed.entries
                        cb []

                    tmpItems = []

                    $.each data.responseData.feed.entries, (index, entry) ->
                        tmpItems.push
                            title: entry.title
                            link: entry.link

                    cb tmpItems

        return {
            title: config.title
            url: config.url
            items: items
            init: init,
            render: render(config.node, config.template, {items: items, title: config.title, logo: config.logo, color: config.color}, _onVisit)
        }

    return feed
