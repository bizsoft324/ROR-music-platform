(function ($) {

    $.fn.sliderUi = function (options) {

        var settings = $.extend({
            autoPlay: true,
            delay: 3000,
            responsive: true,
            controlShow: true,
            arrowsShow: true,
            caption: false,
            speed: 300,
            cssEasing: 'ease-out'
        }, options || {});

        function supportCSS3(prop) {
            var prefix = ['-webkit-', '-moz-', ''];
            var root = document.documentElement;

            function camelCase(str) {
                return str.replace(/\-([a-z])/gi, function (match, $1) {
                    return $1.toUpperCase();
                })
            }

            for (var i = prefix.length - 1; i >= 0; i--) {
                var css3prop = camelCase(prefix[i] + prop);
                if (css3prop in root.style) {
                    return css3prop;
                }
            }
            return false;
        }

        function transitionEnd() {
            var transitions = {
                'transition': 'transitionend',
                'WebkitTransition': 'webkitTransitionEnd',
                'MozTransition': 'mozTransitionEnd'
            };

            var root = document.documentElement;
            for (var name in transitions) {
                if (root.style[name] !== undefined) {
                    return transitions[name];
                }
            }
            return false;
        }

        function support3d() {
            if (!window.getComputedStyle) {
                return false;
            }
            var el = document.createElement('div'),
                has3d,
                transform = supportCSS3('transform');

            document.body.insertBefore(el, null);

            el.style[transform] = 'translate3d(1px,1px,1px)';
            has3d = getComputedStyle(el)[transform];

            document.body.removeChild(el);

            return (has3d !== undefined && has3d.length > 0 && has3d !== "none");
        }

        var transformProperty = supportCSS3('transform');
        var transitionProperty = supportCSS3('transition');
        var has3d = support3d();

        return this.each(function () {
            var
                container = $(this),
                slider = container.find('.slider'),
                sliderStyle = slider.get(0).style,
                arrows = container.find('.switch'),
                caption = slider.find('.caption'),
                slide = slider.find('.slide'),
                slideLen = slide.length,
                slideWidth = container.outerWidth(),
                sliderWidth = slideLen * slideWidth,
                controlPanel = null,
                current = 0,
                offset = null,
                busy = false,
                timer = null;

            // console.log(1);
            sliderStyle['width'] = sliderWidth + 'px';
            slide.css('width', slideWidth);

            if (settings.responsive) {
                $(window).on('resize', function () {
                    if (transitionProperty) {
                        sliderStyle[transitionProperty] = 'none';
                    }
                    busy = false;
                    slideWidth = container.outerWidth();
                    sliderWidth = slideLen * slideWidth;
                    slide.css('width', slideWidth);

                    if (transitionProperty && transformProperty) {
                        sliderStyle['width'] = sliderWidth + 'px';

                        (has3d)
                            ? sliderStyle[transformProperty] = 'translate3d(' + -(slideWidth * current) + 'px, 0, 0)'
                            : sliderStyle[transformProperty] = 'translate(' + -(slideWidth * current) + 'px, 0)';

                    } else {
                        slider.css({
                            width: sliderWidth + 'px',
                            'margin-left': -(slideWidth * current) + 'px'
                        });
                    }

                })
            }

            !settings.caption && caption.remove();

            if (settings.controlShow) {
                controlPanel = $('<div/>', {
                    'class': 'slider-nav'
                })
                    .appendTo(container);

                // Control links
                var links = [];

                for (var i = 0; slideLen > i; i++) {
                    var act = (current === i) ? 'active' : '';
                    links.push('<a class="' + act + '" data-id="' + i + '"></a>');
                }
                controlPanel.get(0).innerHTML = links.join('');

                var navControl = controlPanel.find('a');
                navControl.on('click', function (e) {
                    e.preventDefault();
                    if ($(this).hasClass('active')) return;
                    current = parseInt(this.getAttribute('data-id'), 10);
                    show('current');
                })
            }

            var show = function (side) {
                if (busy) return;

                if (side === 'next') {
                    if (current < slideLen - 1) {
                        offset = -(slideWidth * (++current)) + 'px';
                    }
                    else {
                        offset = 0;
                        current = 0;
                    }
                }
                else if (side === 'current') {
                    offset = -(slideWidth * current) + 'px';
                }
                else {
                    if (current > 0) {
                        offset = -(slideWidth * (--current)) + 'px';
                    }
                    else {
                        offset = -(slideWidth * (slideLen - 1)) + 'px';
                        current = slideLen - 1;
                    }
                }
                if (settings.controlShow) {
                    navControl.removeClass('active');
                    navControl.eq(current).addClass('active');
                }
                busy = true;
                if (transitionProperty && transformProperty) {
                    sliderStyle[transitionProperty] = transformProperty + ' ' + settings.speed + 'ms ' + settings.cssEasing;

                    (has3d)
                        ? sliderStyle[transformProperty] = 'translate3d(' + offset + ', 0, 0)'
                        : sliderStyle[transformProperty] = 'translate(' + offset + ', 0)';

                    slider.one(transitionEnd(), function (e) {
                        busy = false;
                    })
                }
                else {
                    slider.animate({'margin-left': offset}, settings.speed, 'linear', function () {
                        busy = false;
                    })
                }
            }

            if (settings.arrowsShow) {
                arrows.on('click', function (e) {
                    e.preventDefault();
                    var side = this.id;
                    show(side);
                })
            }
            else {
                arrows.remove();
            }

            var auto = function () {
                if (timer) clearInterval(timer);

                timer = setInterval(function () {
                    show('next');
                }, settings.delay);
            };

            if (settings.autoPlay) {
                auto();
                container.hover(function () {
                    clearInterval(timer);
                }, function () {
                    auto();
                });
            }

        });

    }

})(jQuery);