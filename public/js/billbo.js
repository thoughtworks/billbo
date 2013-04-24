$(document).ready(function() {
  $(".bill-box").on("click", function(event) {
    event.preventDefault();
    $(".bill-details").removeClass("active-box");
    $(".bill-container").removeClass("after-active-box");

    var container = $(this).closest(".bill-container");
    $(".thumbnails").prepend(container);
    container.find(".bill-details").addClass("active-box");
    container.next().addClass("after-active-box");
  });
});
