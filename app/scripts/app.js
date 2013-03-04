// Generated by CoffeeScript 1.5.0
(function() {

  define(['jquery'], function($) {
    var navigateToPage, pageHashToPos, pagePosToHash, radialGradient, randomColor, selectors, shuffle;
    randomColor = function() {
      var i, product, v, _i;
      product = '#';
      for (i = _i = 0; _i <= 2; i = ++_i) {
        v = 64 + Math.floor(Math.random() * 192);
        v = v.toString(16);
        product += v;
      }
      return product;
    };
    radialGradient = function(element, innerColor, outerColor) {
      var $e;
      $e = $(element);
      if (!innerColor) {
        innerColor = randomColor();
      }
      if (!outerColor) {
        outerColor = randomColor();
      }
      $e.css("background-color", outerColor);
      $e.css("background-image", "-webkit-gradient(radial, center center, 0, center center, 460, ", +("from(" + innerColor + "), to(" + outerColor + "))"));
      $e.css("background-image", "-webkit-radial-gradient(circle, " + innerColor + ", " + outerColor + ")");
      $e.css("background-image", "-moz-radial-gradient(circle, " + innerColor + ", " + outerColor + ")");
      $e.css("background-image", "-o-radial-gradient(circle, " + innerColor + ", " + outerColor + ")");
      return $e.css("background-repeat", "no-repeat");
    };
    selectors = {
      gridItems: '.grid .item',
      homeItems: '.home .grid .item',
      navigation: ['.nav-home', '.nav-work', '.nav-about', '.nav-contact'],
      pageContainer: '#page-container'
    };
    shuffle = function(array) {
      var i, j, tmp;
      i = array.length;
      if (i === 0) {
        return array;
      }
      while (--i) {
        j = Math.floor(Math.random() * (i + 1));
        tmp = array[i];
        array[i] = array[j];
        array[j] = tmp;
      }
      return array;
    };
    pageHashToPos = function(hash) {
      var id, ret;
      id = hash.startsWith('#') ? hash.substr(1) : hash;
      ret = selectors.navigation.indexOf(".nav-" + id);
      if (ret !== -1) {
        return ret;
      } else {
        return 0;
      }
    };
    pagePosToHash = function(pos) {
      var nav;
      nav = selectors.navigation[pos];
      return '#' + nav.split('-')[1];
    };
    navigateToPage = function(pagePos, pushState) {
      var $page, hash;
      if (pagePos == null) {
        pagePos = 0;
      }
      if (pushState == null) {
        pushState = true;
      }
      $page = $("" + selectors.pageContainer + " .page:nth(" + pagePos + ")");
      $('.content').css({
        height: $page.height()
      });
      $(selectors.pageContainer).css({
        marginLeft: "" + (-960 * pagePos) + "px"
      });
      hash = pagePosToHash(pagePos);
      if (pushState) {
        return history.pushState({
          pagePosition: pagePos
        }, hash.substr(1), hash);
      }
    };
    window.onpopstate = function(e) {
      var pos;
      pos = pageHashToPos(location.hash);
      return navigateToPage(pos, false);
    };
    $(function() {
      var pos;
      pos = pageHashToPos(location.hash);
      return navigateToPage(pos, pos !== 0);
    });
    return $(function() {
      (function() {
        var i, interval, items;
        i = 0;
        items = shuffle($(selectors.homeItems));
        return interval = setInterval(function() {
          if (i >= items.length) {
            clearInterval(interval);
          }
          $(items[i]).css({
            opacity: 1
          });
          return i += 1;
        }, 120);
      })();
      console.log(selectors.homeItems);
      (function() {
        var item, _i, _len, _ref, _results;
        _ref = $(selectors.gridItems);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          _results.push(radialGradient($(item).find('.overlay .background')));
        }
        return _results;
      })();
      $(selectors.gridItems).mouseenter(function(e) {
        return $(this).children('.overlay').css({
          opacity: 0.8
        });
      }).mouseleave(function(e) {
        return $(this).children('.overlay').css({
          opacity: 0
        });
      });
      return (function() {
        var i, selector, _i, _len, _ref, _results;
        _ref = selectors.navigation;
        _results = [];
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          selector = _ref[i];
          _results.push((function(selector, i) {
            return $(selector).click(function(e) {
              e.preventDefault();
              return navigateToPage(i);
            });
          })(selector, i));
        }
        return _results;
      })();
    });
  });

}).call(this);
