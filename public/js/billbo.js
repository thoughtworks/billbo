var today = function() {
  this.now = new Date();
  this.dd = now.getDate();
  this.mm = now.getMonth()+1; //January is 0!
  this.yyyy = now.getFullYear();

  if (dd < 10) {
    dd = '0' + dd;
  }
  if (mm < 10) {
    mm = '0' + mm;
  }
  return yyyy+'-'+mm+'-'+dd;
};

// Someone help me to refactor that? =)
function CustomErrorMessage() {
  this.required = function(formEl) {
    this.formEl = formEl;

    this.formEl.on('change invalid', function() {
      var textfield = $(this).get(0);
      textfield.setCustomValidity('');

      if (!textfield.validity.valid) {
        textfield.setCustomValidity(window.i18n["required_field"]);
      }
    });
  }
  this.greaterThanZero = function(formEl) {
    this.formEl = formEl;

    this.formEl.on('change invalid', function() {
      var textfield = $(this).get(0);
      textfield.setCustomValidity('');

      if (!textfield.validity.valid) {
        textfield.setCustomValidity(window.i18n["greater_than_zero"]);
      }
    });
  }

  this.afterToday = function(formEl) {
    this.formEl = formEl;

    this.formEl.on('change invalid', function() {
      var textfield = $(this).get(0);
      textfield.setCustomValidity('');

      if (!textfield.validity.valid) {
        textfield.setCustomValidity(window.i18n["after_yesterday"]);
      }
    });
  }
}

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

  $('input[name="due_date"]').attr('min', today());

  var customize = new CustomErrorMessage();
  customize.required($('section.new-bill').find($('input')));
  customize.greaterThanZero($('section.new-bill').find($('input[type="number"]')));
  customize.afterToday($('section.new-bill').find($('input[type="date"]')));
});
