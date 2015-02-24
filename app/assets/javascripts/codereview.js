$(document).ready(function() {
  $(".iteration_select").change(function() {
    location = "code_review?problem_id=1&left_iteration=" + $("#left_iteration_select").val() + "&right_iteration=" + $("#right_iteration_select").val();
  });
  
  $('textarea').elastic();
  $('textarea').trigger('update');

  $(".comment_toggle").click(function () {
    $(this).prev().css("display", "block");
    $(this).css("display", "none");
  });

  $(".diff_file_path_link").click(function () {
    var diffFileId = '#' + this.id + '.diff_file';

    var toggleText = '';
    var displayValue = '';

    if ($(diffFileId).css('display') == 'none')
    {
      toggleText = 'Hide Code';
      displayValue = 'block';
    }
    else
    {
      toggleText = 'Show Code';
      displayValue = 'none';
    }

    $(diffFileId).css('display', displayValue);
    $(this).text(toggleText);
  });
});

