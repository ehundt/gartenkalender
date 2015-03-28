$(document).ready(function(){
  $('.info').on('click', function(){
    $(this).next('.task-desc').fadeToggle();
    $(this).find('.glyphicon').first().toggleClass('glyphicon-eye-open');
  });
});
