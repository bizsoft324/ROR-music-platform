Paloma.controller('Critiques', {
    index: function () {
        var select = new Select({
            el: document.querySelector('select'),
            className: 'select-theme-default'
        })
    },
    show: function() {
        initPlayers();
    }
});
