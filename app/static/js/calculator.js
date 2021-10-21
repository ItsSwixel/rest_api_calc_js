$(function() {
  $('#calcForm').submit(function(e) {
    var action = "/calculate2"
    var x = Number(document.forms['calcForm']['number1'].value);
    var y = Number(document.forms['calcForm']['number2'].value);
    if (isNaN(x) || isNaN(y)) {
      alert('Please only enter numbers')
    } else {
    $.ajax({
      type: 'POST',
      url: action,
      processData: false,
      dataType: 'json',
      async: false,
      headers: {},
      data: $('#calcForm').serialize(),

      success: function(response) {
        result = response.data
        $('#resultInput').html('')
        $('#resultInput').append(result)
      },
      error: function(error) {
        alert(error)
      },
      complete: function() {

      }
    });
    e.preventDefault();
  }
  });
});
