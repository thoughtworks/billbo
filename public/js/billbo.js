function CustomErrorMessage() {
  this.REQUIRED = 'required_field';
  this.GT_ZERO = 'greater_than_zero';
  this.AFTER_YESTERDAY = 'after_yesterday';

  function addValidation(formEl, validationName) {
    formEl.on('change invalid', function() {
      var textfield = $(this).get(0);
      textfield.setCustomValidity('');

      if (!textfield.validity.valid) {
        textfield.setCustomValidity(window.i18n[validationName]);
      }
    });
  }

  this.required = function(formEl) {
    addValidation(formEl, this.REQUIRED);
  }
  this.greaterThanZero = function(formEl) {
    addValidation(formEl, this.GT_ZERO);
  }
  this.afterToday = function(formEl) {
    addValidation(formEl, this.AFTER_YESTERDAY);
  }
}

$(document).ready(function() {
  $('.gt_value').click(function() {
      .sort('p.total_amount',{order:'desc'});
  });

  $('.lt_value').click(function() {
    $('ul#all-bills>li').sort('p.total_amount');
  });

  $('.due_date').click(function() {
    $('ul#all-bills>li').sort('p.due_date');
  });

  $('.sort_list').on('click', 'a', function() {
    $("a").addClass("secondary");
    $(this).removeClass("secondary");
  });

  var customize = new CustomErrorMessage(),
      newBillSection = $('section.new-bill');

  customize.required(newBillSection.find($('input')));
  customize.greaterThanZero(newBillSection.find($('input[type="number"]')));
  customize.afterToday(newBillSection.find($('input[type="date"]')));

  $("#datepicker").datepicker({
    dateFormat: "dd/mm/yy",
    minDate: 0 // disable days before today
  });
});
