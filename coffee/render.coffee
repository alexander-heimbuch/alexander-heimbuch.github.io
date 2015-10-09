define ['jquery'], ($) ->

    render = (selector, templateFile, data, afterRender) ->

        _loadTemplate = (cb) ->
            if dust.cache[templateFile] != undefined
                return cb()
            $.get templateFile, (tmpl) ->
                dust.loadSource dust.compile(tmpl, templateFile)
                cb()

        _write = (template) ->
            $(selector).html(template)
            afterRender()

        return ->
            _loadTemplate () ->
                dust.render templateFile, data, (err, out) ->
                    _write out unless err

    return render
