// // # Place all the behaviors and hooks related to the matching controller here.
// // # All this logic will automatically be available in application.js.
// // # You can use CoffeeScript in this file: http://coffeescript.org/
//

displayForm = function() {
  if($("#" + "new-payment-creation").length > 0) {
    $('.new_payment').hide();
    $('#payment_type').on('click', function() {
      switch($('input:radio[name=payment_type]:checked').val()) {
        case 'stripe':
          hideForm();
          $('.new_stripe').toggle();
          break;
        case 'check':
          hideForm();
          $('.new_check').toggle();
          break;
        case 'loan':
          hideForm();
          $('.new_loan').toggle();
          break;
        case 'wire':
          hideForm();
          $('.new_wire').toggle();
          break;
      }
    });
  }
}

hideForm = function() {
  $('.new_payment').hide();
}

formVisibility = function() {
  displayForm();
}

$(function() {
  $('#from-datepicker').datepicker();
  $('#to-datepicker').datepicker();
});

$(document).ready(formVisibility);
$(document).on('page:load', formVisibility);
