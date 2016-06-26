window.onload = function() {
    var files = document.querySelectorAll("input[type=file]");
    files[0].addEventListener("change", function(e) {
        if(this.files && this.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
              var plant_image = document.getElementById("image_preview");
              plant_image.setAttribute("src", e.target.result);
              plant_image.style.display = 'block';
            }
            reader.readAsDataURL(this.files[0]);
        }
    });
}
