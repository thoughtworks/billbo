$(function() {

// Phone number
  $(".tel").setMask( {mask: "99 (99) 99999-9999"} );

// Search
  $('#search_field').keyup(function() {
    var val = $(this).val().toLowerCase();

    $('.ngo-wrapper').each(function() {
      var self = $(this);
      var name = self.data('name');

      if(name.indexOf(val) == -1) {
        self.hide(0);
      } else {
        self.show(0);
      }
    });

    if($(".ngo-wrapper:visible").length == 0) {
      $("#nothing-found").removeClass('hide');
    } else {
      $("#nothing-found").addClass('hide');
    }
  });

// Reserve Form
  $('.btn-reserve').click(function() {
    var self = $(this);
    var id = self.data('id');
    var sameElement = $('#form-reserve-'+id).is(':visible');

    $('.hidden-form').hide();

    if(!sameElement) {
      $('#form-reserve-'+id).toggle().find('input:first').focus();
    }
  });

// Upload Form
  $('.btn-upload').click(function() {
    var self = $(this);
    var id = self.data('id');
    var sameElement = $('#form-upload-'+id).is(':visible');

    $('.hidden-form').hide();

    if(!sameElement) {
      $('#form-upload-'+id).toggle().find('input:first').focus();
    }
  });

  $('[title]').tipsy({
    gravity: 'n'
  });

  $('#gt_value').click(function() {
    $('#all_bills > li').tsort('.total_amount', {order: 'desc'});
  });

  $('#lt_value').click(function() {
    $('#all_bills > li').tsort('.total_amount');
  });

  $('#due_date').click(function() {
    $('#all_bills > li').tsort('.due_date', {data: 'timestamp'});
  });

  $('#status').click(function() {
    $('#all_bills > li').tsort('.th', {attr:'class'}, '.due_date', {data: 'timestamp'});
  });

  $('.sort_list').on('click', 'a', function() {
    $(this).parent().addClass("active").siblings().removeClass("active");
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


function CustomErrorMessage() {
  this.REQUIRED = 'required_field';
  this.GT_ZERO = 'greater_than_zero';
  this.BEFORE_YESTERDAY = 'before_today';

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
    addValidation(formEl, this.BEFORE_YESTERDAY);
  }
}