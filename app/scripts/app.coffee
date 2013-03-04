define ['jquery'], ($) ->

  # Helper function that returns a random color hash value. The color
  # value is always >= 64.
  randomColor = ->
    product = '#'
    product += (64  + Math.floor Math.random() * 192).toString 16
    product += (64  + Math.floor Math.random() * 192).toString 16
    product += (128 + Math.floor Math.random() * 128).toString 16

        for i in [0..2]
      v = 64 + Math.floor Math.random() * 192
      v = v.toString 16
      # not needed when we have v is at least 0x10 (16)
      # v = '0' + v if v.length == 1
      product += v

    product

  # Set a radial gradient using CSS3 properties. Only the `element`
  # argument is required. If missed, the inner and outher colors will
  # be randomly generated.
  radialGradient = (element, innerColor, outerColor) ->
    $e = $ element
    innerColor = randomColor() if not innerColor
    outerColor = randomColor() if not outerColor

    # console.log "innerColor=#{innerColor}"
    # console.log "outerColor=#{outerColor}"

    $e.css "background-color", outerColor

    $e.css "background-image",
      "-webkit-gradient(radial, center center, 0, center center, 460, "
      + "from(#{innerColor}), to(#{outerColor}))"

    $e.css "background-image",
      "-webkit-radial-gradient(circle, #{innerColor}, #{outerColor})"

    $e.css "background-image",
      "-moz-radial-gradient(circle, #{innerColor}, #{outerColor})"

    $e.css "background-image",
      "-o-radial-gradient(circle, #{innerColor}, #{outerColor})"

    $e.css "background-repeat", "no-repeat"

  # A single keep for page element selectors
  selectors =
    gridItems: '.grid .item'
    homeItems: '.home .grid .item'
    navigation: ['.nav-home', '.nav-work', '.nav-about', '.nav-contact']
    pageContainer: '#page-container'

  # Shuffle an array
  # https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
  shuffle = (array) ->
    i = array.length
    return array if i == 0
    while --i
      j = Math.floor Math.random() * (i + 1)
      tmp = array[i]
      array[i] = array[j]
      array[j] = tmp
    array

  pageHashToPos = (hash) ->
    id = if hash.startsWith '#' then hash.substr(1) else hash
    ret = selectors.navigation.indexOf ".nav-#{id}"
    if ret != -1 then ret else 0

  pagePosToHash = (pos) ->
    nav = selectors.navigation[pos]
    '#' + nav.split('-')[1]

  # This function navigates to another page that is identified by its
  # position in the `pageContainer` wrapper element.
  # 
  # It depends on the global `selectors.pageContainer` and presumes
  # the size of a pane is exactly 960px.
  navigateToPage = (pagePos=0, pushState=true) ->
    $page = $ "#{selectors.pageContainer} .page:nth(#{pagePos})"

    # Resize content wrapper
    # $('.content').animate height: $page.height()
    $('.content').css height: $page.height()

    # Show page
    # $(selectors.pageContainer).animate marginLeft: "#{-960 * pagePos}px"
    $(selectors.pageContainer).css marginLeft: "#{-960 * pagePos}px"

    hash = pagePosToHash pagePos
    if pushState
      history.pushState {pagePosition: pagePos}, hash.substr(1), hash

  # Register on back button click listener
  window.onpopstate = (e) ->
    pos = pageHashToPos location.hash
    navigateToPage pos, false

  $ ->
    # initial navigation
    pos = pageHashToPos location.hash
    navigateToPage pos, pos != 0

  $ ->
    # y: Here and forward I use the `do` keyword often just to wrap
    # inner variables inside a scope.  In the case below I have to do
    # that since I work with an interval.  If something outside
    # changes the value of `i` while the interval is still running,
    # shit will happen. That's why `i` is encapsulated inside a scope.

    # Fade in front items in random order
    do ->
      i = 0
      items = shuffle $ selectors.homeItems
      interval = setInterval ->
        clearInterval interval if i >= items.length
        $(items[i]).css opacity: 1
        i += 1
      , 120

    # Random overlay colors
    console.log selectors.homeItems
    do ->
      for own item in $ selectors.gridItems
        radialGradient $(item).find '.overlay .background'

    $(selectors.gridItems)
    .mouseenter (e) ->
      # TODO: selector
      $(this).children('.overlay').css opacity: 0.8
    .mouseleave (e) ->
      $(this).children('.overlay').css opacity: 0

    # Navigation between pages
    do ->
      for selector, i in selectors.navigation
        do (selector, i) ->
          $(selector).click (e) ->
            e.preventDefault()
            navigateToPage i
