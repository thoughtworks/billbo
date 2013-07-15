$(document).foundation();

var hideAllBillDetails = function() {
  $(".bill-details").removeClass("active-box");
}

$(document).ready(function() {
  $(".bill-box").on("click", function(event) {
    event.preventDefault();
    hideAllBillDetails();

    var container = $(this).closest(".bill-container");
    container.find(".bill-details").addClass("active-box");
  });

  $(".close-bill-details").on("click", function() {
    hideAllBillDetails();
  });
});
