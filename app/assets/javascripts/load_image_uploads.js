window.onload = function () {
    var files = document.querySelectorAll("input[type=file]");
    if (files && files[0]) {
        files[0].addEventListener("change", function (e) {
            if (this.files && this.files[0]) {
                var reader = new FileReader();
                reader.readAsDataURL(this.files[0]);
            }
        });
    }
}
