Paloma.controller('Waitlists', {
    index: function () {
        attachButtonEvent();
        attachEmailEvent();
        activateButton();

        function attachEmailEvent() {
            var form = document.querySelector('[data-wait-list-form] form#waitlist_form');
            var input = document.querySelector('[data-wait-list-form] input#email-capture');

            input.addEventListener('keydown', function (e) {
                var key = e.keyCode || e.which;

                if (key == 13) {
                    e.preventDefault();
                    deactivateButton();
                    onFormValid(form);
                }
            }, false);
        }

        function attachButtonEvent() {
            var form = document.querySelector('[data-wait-list-form] form#waitlist_form');
            var button = document.querySelector('[data-wait-list-form] a#button_next');
            var input = document.querySelector('[data-wait-list-form] input#email-capture');

            button.addEventListener('click', function (e) {
                console.log("join clicked!");
                e.preventDefault();
                deactivateButton();
                onFormValid(form);
            }, false);
        }

        function activateButton() {
            var $input = $('[data-wait-list-form] input#email-capture');
            var button = document.querySelector('[data-wait-list-form] a#button_next');

            $input.on('change paste', function () {
                if ($input.parsley().isValid()) {
                    button.classList.remove('inactive');
                }
            });

            $input.on('keyup', function (e) {
                if (e.which != 13) {
                    if ($input.parsley().isValid()) {
                        button.classList.remove('inactive');
                    }
                }
            });
        }

        function deactivateButton() {
            var button = document.querySelector('[data-wait-list-form] a#button_next');
            button.classList.add('inactive');
        }

        function onFormValid(form) {
            var parsleyForm = $(form).parsley();

            if (parsleyForm.isValid()) {
                var input = form.querySelector('#email-capture');
                var button = form.querySelector('a#button_next');

                button.classList.add('inactive');
                createWaitlistedUser(input.value);
            }
        }

        function createWaitlistedUser(email) {
            var data = {user: {email: email}, user_agent: navigator.userAgent};

            $.ajax({
                type: 'POST',
                url: '/waitlist',
                dataType: 'JSON',
                contentType: 'application/json',
                data: JSON.stringify(data),
                success: function (data) {
                    window.location = data.url;
                }
            });
        }

        var _pfy = _pfy || [];
        (function () {
            function pfy_load() {
                var pfys = document.createElement('script');
                pfys.type = 'text/javascript';
                pfys.async = true;
                pfys.src = 'https://beatthread.prefinery.com/widget/v2/86b8338l.js';
                var pfy = document.getElementsByTagName('script')[0];
                pfy.parentNode.insertBefore(pfys, pfy);
            }

            if (window.attachEvent) {
                window.attachEvent('onload', pfy_load);
            } else {
                window.addEventListener('load', pfy_load, false);
            }
        })();
    }
});