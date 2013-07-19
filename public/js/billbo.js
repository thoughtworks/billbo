$(document).ready(function() {
  $('.gt_value').click(function() {
    $('ul#all-bills>li').tsort('p.total_amount',{order:'desc'});
  });

  $('.lt_value').click(function() {
    $('ul#all-bills>li').tsort('p.total_amount');
  });

  $('.due_date').click(function() {
    $('ul#all-bills>li').tsort('p.due_date');
  });

  $('.sort_list').on('click', 'a', function() {
    $("a").addClass("secondary");
    $(this).removeClass("secondary");
  });
});
