$(document).on('turbolinks:load', function() {
    Paloma.controller('Home', {
        index: function() {
            wait_and_run(waves.waveform_proc(), 500);
            $(document).on('turbolinks:load', function() {
                wait_and_run(waves.waveform_proc(), 500);
            })
        }
    });
});