Paloma.controller('Charts', {
    index: function() {
        initPlayers();

        $('#toggle-chart-menu').click(function() {
            $('#chart-menu').fadeToggle(200);
            $(this).toggleClass('is-active');
        });

        $('#chart-menu').children('li').click(function() {
            var $menuToggle = $('#toggle-chart-menu');

            $menuToggle.html($(this).children('a').html());
            $('#chart-menu').fadeToggle(200);
            $menuToggle.toggleClass('is-active');

            $(document).on('click', '#charts_period a', function(event) {
                event.preventDefault();
                $(this).parent().addClass('current');
                $(this).parent().siblings().removeClass('current');
            });
        });

        $('a[href="/charts?period=by_all_time_charts"]').click();
    }
});
