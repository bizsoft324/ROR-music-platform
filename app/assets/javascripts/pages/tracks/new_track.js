Paloma.controller('Tracks', {
    before: ['edit new -> bindEvents'],
    edit: function () {
        if ($('.edit-beat__slider input').val() == 0) {
            $('[data-edit-left] span').addClass('bold-text');
            $('[data-edit-right] span').removeClass('bold-text');
        } else {
            $('[data-edit-right] span').addClass('bold-text');
            $('[data-edit-left] span').removeClass('bold-text');
        }
    },
    new: function () {
        var hideOptions = function () {
            var $select = $('select#select_choose_subgenre');
            $select.find('option').show();
            $select.each(function (index, select) {
                if (select.value) {
                    $('select#select_choose_subgenre option[value=\'' + select.value + '\']').hide();
                }
            });
        };

        // this is intentionally - duplicated code to circumvent the "You must bind Parsley on an existing element." error
        $('.form-track').parsley().on('form:validate', function (formInstance) {
            var gif_test = $('#image_upload_preview').attr("src");
            var tags_test = $('#track_tag_list').val();
            var val_failed = false;
            if (gif_test.length == 0) {
                $('#fake_image_error').css("opacity", 1);
                val_failed = true;
            } else {
                $('#fake_image_error').css("opacity", 0);
            }
            if (tags_test.length == 0) {
                if ($('#fake_tags_error').length == 0) {
                    $('.selectize-control').prepend("<p id='fake_tags_error'>Beat tags required</p>");
                }
                val_failed = true;
            } else {
                $('#fake_tags_error').remove();
            }
            if (val_failed == true) {
                formInstance.validationResult = false;
            }
        });

        $(document).on('change', 'span.select#first-subgenre', function () {
            if ($(this).find('option:selected').val() === '') {
                $('span.select#second-subgenre').hide();
            } else {
                $('span.select#second-subgenre').show();
            }
        });

        $(document).on('change', 'select#select_choose_subgenre', function () {
            hideOptions();
        });
    },
    bindEvents: function () {
        if ($('select#select_choose_subgenre:first').find('option').length == 1) {
            $.ajax({
                url: '/tracks/new',
                dataType: 'json',
                type: 'GET',
                data: {
                    genre_id: $('select#genre-select option:selected').val()
                },
                success: function (data) {
                    if (data) {
                        data.forEach(function (item) {
                            var option = new Option(item.name, item.id);
                            $('select#select_choose_subgenre').append(option);
                        });
                    }
                }
            });
        }
        $('#track_tag_list').selectize({
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
                // return confirm(values.length > 1 ? 'Are you sure you want to remove these ' + values.length + ' items?' : 'Are you sure you want to remove "' + values[0] + '"?');
            }
        });
        // clickable links that generate tags

        $(document).on('click', 'a#add-track-tag', function(e) {
            e.preventDefault();
            e.stopPropagation();

            var selectizeTags   = $('#track_tag_list')[0].selectize;
            var tagValue        = $(this).data('tag-name');

            selectizeTags.addOption({ text: tagValue, value: tagValue });
            selectizeTags.addItem(tagValue);
            selectizeTags.refreshItems();
        });


        $('.public-btn:first').click(function (event) {
            var selectize_tags = $('#track_tag_list')[0].selectize;
            selectize_tags.removeItem("private");
            selectize_tags.addOption({
                text: 'public',
                value: 'public'
            });
            selectize_tags.addItem('public');
            selectize_tags.refreshItems();
            event.preventDefault();
            event.stopPropagation();
        });

        $('.private-btn:first').click(function (event) {
            var selectize_tags = $('#track_tag_list')[0].selectize
            selectize_tags.removeItem("public")
            selectize_tags.addOption({
                text: 'private',
                value: 'private'
            });
            selectize_tags.addItem('private');
            selectize_tags.refreshItems();

            event.preventDefault();
            event.stopPropagation();
        });

        $('.temp5-gif:first').click(function (event) {
            $('.gif-area').toggleClass('hidden');
            event.preventDefault();
            event.stopPropagation();
        });

        $('#get_gif_btn').on('click', function (event) {
            if ($('input#gif-search').val.length > 0) {
                GrabGif();
            }
            event.preventDefault();
            event.stopPropagation();
        });

        $('#gif_cancel').on('click', function (event) {
            $('input#gif-search').val('');
            $('.gif-area').toggleClass('hidden');
            event.preventDefault();
            event.stopPropagation();
        });

        $('input#gif-search').keydown(function (event) {
            if (event.which == 13) {
                GrabGif();
                event.preventDefault();
                event.stopPropagation();
            }
        });

        // get a random gif based on input input#gif-search
        function GrabGif() {
            var productionKey = 'kp9kNwDGJGi2Y';   // [TODO] We need to move this someplace safe
            var limit = 1;
            var search = $('input#gif-search');
            var userInput = search.val().trim();
            userInput = userInput.replace(RegExp(' ', 'g'), '+');
            var queryURL = 'https://api.giphy.com/v1/gifs/random?' + '&api_key=' + productionKey + '&tag=' + userInput;
            $.getJSON(queryURL, function (object) {
                var imageSource = object.data.image_original_url;
                var image = $('<img src=' + imageSource + ' + id="image_upload_preview" />');
                $('#image_upload_preview').remove();
                image.prependTo($('.beat-uploading__left'));
                $('#hiddenGif').val(imageSource);
                var gif_test = $('#image_upload_preview').attr("src");
                if (gif_test.length == 0) {
                    $('#fake_image_error').css("opacity", 1);
                } else {
                    $('#fake_image_error').css("opacity", 0);
                }
            });
        }

        window.initSlider = function () {
            $('#new_upload_track').find('[data-edit-slider]').slider({
                min: 0,
                max: 1,
                animate: 'slow',
                create: function (event, ui) {
                    var streamable = $('input[id=\'track_streamable\']').prop('checked');
                    if (streamable)
                        event.target.lastChild.style.left = '100%';

                    if (ui.value === '0') {
                        return $('[data-edit-left] span').addClass('bold-text');
                    } else {
                        return $('[data-edit-right] span').addClass('bold-text');
                    }
                },
                slide: function (event, ui) {
                    if (ui.value > 0) {
                        var selectize_tags = $('#track_tag_list')[0].selectize
                        selectize_tags.removeItem("private")
                        selectize_tags.addOption({
                            text: 'public',
                            value: 'public'
                        });
                        selectize_tags.addItem('public');
                        selectize_tags.refreshItems();
                        return $('input[id=\'track_streamable\']').prop('checked', true);
                    } else {
                        var selectize_tags = $('#track_tag_list')[0].selectize
                        selectize_tags.removeItem("public")
                        selectize_tags.addOption({
                            text: 'private',
                            value: 'private'
                        });
                        selectize_tags.addItem('private');
                        selectize_tags.refreshItems();
                        return $('input[id=\'track_streamable\']').prop('checked', false);
                    }
                }
            });
        };
        $(document).on('slidechange', '[data-edit-slider]', function (e, ui) {
            if (ui.value === 0) {
                $('[data-edit-left] span').addClass('bold-text');
                $('[data-edit-right] span').removeClass('bold-text');
            } else {
                $('[data-edit-right] span').addClass('bold-text');
                $('[data-edit-left] span').removeClass('bold-text');
            }
        });

        initSlider();

        var $form = $('.form-track');

        if ($form.length > 0) {
            $form.parsley({
                successClass: 'has-success',
                errorClass: 'has-error',
                trigger: "submit"
            });

            // this is intentionally - duplicated code to circumvent the "You must bind Parsley on an existing element." error
            $('.form-track').parsley().on('form:validate', function (formInstance) {
                var gif_test = $('#image_upload_preview').attr("src");
                var tags_test = $('#track_tag_list').val();
                var val_failed = false;
                if (gif_test.length == 0) {
                    $('#fake_image_error').css("opacity", 1);
                    val_failed = true;
                } else {
                    $('#fake_image_error').css("opacity", 0);
                }
                if (tags_test.length == 0) {
                    if ($('#fake_tags_error').length == 0) {
                        $('.selectize-control').prepend("<p id='fake_tags_error'>Beat tags required</p>");
                    }
                    val_failed = true;
                } else {
                    $('#fake_tags_error').remove();
                }
                if (val_failed == true) {
                    formInstance.validationResult = false;
                }
            });
        }


        $('#track_tag_list').on("change", function () {
            var tags_test = $('#track_tag_list').val();
            if (tags_test.length == 0) {
                if ($('#fake_tags_error').length == 0) {
                    $('.selectize-control').prepend("<p id='fake_tags_error'>Beat tags required</p>");
                }
            } else {
                $('#fake_tags_error').remove();
            }
        });


        $(document).on('dragenter', function (e) {
            $('[data-dragover]').addClass('beat-uploading__dragover');
        });

        $(document).on('mouseout', function (e) {
            $('[data-dragover]').removeClass('beat-uploading__dragover');
        });

        $(document).on('click', '.found-gifs__items__gif', function () {
            var $preview = $('#image_upload_preview');
            var fixedGif = this.src.replace(RegExp('200w.gif', 'g'), '200.gif');

            $('#inputFile').parsley().reset();
            $('[data-found-gifs]').hide();
            $preview.attr('src', fixedGif);
            $('#hiddenGif').val(fixedGif);
            $preview.css('height', 'auto');
        });

        $(document).on('click', '#close-form', function () {
            $('#beat_uploading_content').toggle();
            $('.form-track')[0].reset();
            $('#image_upload_preview').attr('src', '');
            $('[data-upload-content]').toggle();
            $('span.select#second-subgenre').hide();

        });

        $(document).on('click', 'body.tracks-new', function (e) {
            if (!$(e.target).is('[data-found-gifs]')) {
                $('[data-found-gifs]').hide();
            }
        });

        $(document).on('submit', 'form#new_upload_track', function () {
            var $input = $('#inputFile');
            $input.removeAttr('required');
            $input.prop('required', $('img#image_upload_preview').attr('src') === '');
        });

        $(document).on('submit', '#new_upload_track', function () {
            moveBar();
        });

        $(document).on('change', '#upload-audio', function () {
            if (this.value && ($('.beat-uploading__choose').length == 0)) {
                $('[data-upload-content]').toggle();
                $('#beat_uploading_content').toggle();
                return $('span.select#second-subgenre').toggle();
            } else {
                $('[data-upload-content]').hide();
                $('#beat_uploading_content').show();
                return $('span.select#second-subgenre').show();
            }
        });
    }
});
