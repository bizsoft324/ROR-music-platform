$(document).on('turbolinks:load', function() {
    $(document).on('change', 'select#critiques_sort', function() {
        var url = $('#critiques_items').find('li.current a').attr('href');
        $.ajax({
            url: url,
            method: 'GET',
            dataType: 'script',
            data: {
                sort: this.value
            }
        });
    });

    $(document).on('click', '#critiques_items a', function() {
        $(this).parent().addClass('current');
        $(this).parent().siblings().removeClass('current');
        var val = $('select#critiques_sort option:selected').val();
        this.href = this.href + '&sort=' + val;
    });
});
