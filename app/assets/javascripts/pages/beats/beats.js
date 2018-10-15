Paloma.controller('Beats', {
    index: function () {
        initPlayers();

        $('[data-beat-main-right]').scroll(function () {
            var nextPage = $(this).find('nav a[rel=next]')[0];
            if (nextPage && $(this).scrollTop() > $('#beats-list').height() - $(this).height() - 50) {
                nextPage.click();
                $(this).find('nav').text('Fetching more tracks...');
            }
        });
        $('#beats_search').selectize({
            plugins: ['remove_button'],
            persist: false,
            create: true,
            render: {
                item: function (data, escape) {
                    return '<div>#' + escape(data.text) + '</div>';
                }
            },
            onDelete: function (values) {
                return true;
            },
            onEnterKeypress: function (el) {
                $('form#beats_filter').submit();
            }
        });


        $(document).on('click', 'input[name=sort_by]', function (e) {
            e.stopImmediatePropagation();
            var label = $("label[for='" + $(this).attr('id') + "']");
            $('button#sorting_button').text(label.text());
            filter("&filters[sort_by]=" + ($(this).val()));
        });

        $(document).on('click', '.search-trigger a', function (e) {
            e.stopImmediatePropagation();
            $(this).toggleClass('active');
            $('.beat-select').toggleClass('hide');
            $('.search-filter').toggleClass('hide');
        });

        $(document).on('change paste keyup', 'input#beats_search', function (e) {
            e.stopImmediatePropagation();
            filter('&q=' + e.target.value);
        });

        $(document).on('submit', 'form#beats_filter', function (e) {
            e.stopImmediatePropagation();
            e.preventDefault();
        });


        var filter = function (moreParams) {
            $.ajax({
                url: '/beats',
                method: 'GET',
                data: $('form#beats_filter').serialize(),
                dataType: 'script',
                beforeSend: function () {
                    $("#spinner").removeClass('hide').show();
                    $('[data-beat-main-right]').addClass('loading-state');
                },
                success: function () {
                    $('#spinner').addClass('hide');
                    $('[data-beat-main-right]').removeClass('loading-state');
                    initPlayers();
                },
                error: function () {
                    console.log('error');
                    $("#spinner").addClass('hide');
                    $('[data-beat-main-right]').removeClass('loading-state');
                }
            });
        };

        var height_change_beat_main = function () {
            var $right = $(document).find('[data-beat-main-right]');
            var $topNavHeader = $('#navbar').innerHeight();
            var $topBeatHeader = $('#beats_header').innerHeight();
            $(document).find('html').css('overflow', 'hidden');
            $right.innerHeight($(window).height() - ($topNavHeader + $topBeatHeader));
        };

    }
});


