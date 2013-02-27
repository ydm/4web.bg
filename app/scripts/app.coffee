define ['jquery'], ($) ->
  selectors =
    navigation: ['#nav-home', '#nav-work', '#nav-about', '#nav-contact']
    pageContainer: '#page-container'
    page: '.page'
    item: '.page .item'
    overlay: '.page .item .overlay'

  # https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
  shuffle = (array) ->
    len = array.length
    return array if len == 0
    while --len
      j = Math.floor Math.random() * (len + 1)
      a = array[len]
      b = array[j]
      array[len] = b
      array[j] = a
    array

  $ ->
    do ->
      i = 0
      items = shuffle $ selectors.item
      interval = setInterval ->
        clearInterval interval if i >= items.length
        $(items[i]).animate opacity: 1
        i += 1
      , 150

    $(selectors.item)
    .mouseenter (e) ->
      $(this).children('.overlay').animate opacity: 0.8, 'fast'
    .mouseleave (e) ->
      $(this).children('.overlay').animate opacity: 0, 'fast'

    for selector, i in selectors.navigation
      do (selector, i) ->
        $(selector).click (e) ->
          e.preventDefault()

          # resize container
          height = $("#{selectors.pageContainer} \
            #{selectors.page}:nth-child(#{i + 1})").height()
          $('.content').animate
            height: height

          # show page
          $(selectors.pageContainer).animate
            "margin-left": "#{-960 * i}px"
