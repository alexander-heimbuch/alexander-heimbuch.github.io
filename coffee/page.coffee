# RSS Feed Framework
define ['jquery', 'render'], ($, render) ->

    header = (node, template, data) ->
        render node, template, data, () ->

    return {
        header: header
    }
