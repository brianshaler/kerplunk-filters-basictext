_ = require 'lodash'
Promise = require 'when'

module.exports = (System) ->

  containsText = (data) ->
    {item, parameter} = data
    message = item?.messageFull ? item.message
    unless message?.length > 0
      data.match = false
      return data

    words = message.toLowerCase().split ' '
    words = _ words
      .map (word) ->
        word
        .replace /^[^a-z]+/, ''
        .replace /[^a-z]+$/, ''
      .filter (word) ->
        word.length > 0
      .value()

    data.match = words.indexOf(parameter) != -1
    data

  doesNotContainText = (data) ->
    {item, parameter} = data
    data = !containsText item, parameter
    data.match = !data.match
    data

  globals:
    public:
      filters:
        conditions:
          containsText:
            description: 'contains text'
            parameterRequired: true
          doesNotContainText:
            description: 'does not contain text'
            parameterRequired: true

  events:
    filters:
      conditions:
        containsText:
          do: containsText
        doesNotContainText:
          do: doesNotContainText
