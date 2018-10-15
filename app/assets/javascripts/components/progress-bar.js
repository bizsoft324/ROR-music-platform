function moveBar() {
    var progress = document.getElementById('progressbar');
    var width = 8;
    var id = setInterval(frame, 40);

    function frame() {
        if (width < 100) {
            width++;
            progress.style.width = width + '%';
            progress.innerHTML = 'Uploading ' + width + '%';
        } else {
            progress.innerHTML = 'Uploading 100%'
            progress.style.backgroundColor = '#2BB673';
        }
    }

    function setToMax() {
        progress.value = 100
    }
}
