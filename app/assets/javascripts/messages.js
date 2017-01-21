$(document).ready(function(){
  // Handle autocomplete and maxlength
  $('textarea').sew({values: values}).textarea();

  $wmd = $('#wmd-input');
  if ($wmd.length) {
    var converter = Markdown.getSanitizingConverter();
    var editor = new Markdown.Editor(converter);
    $wmd.keyup(function() {
      $('.preview').show('fast');
    });
    editor.run();
    $('.wmd-button').tooltip();
  }

  $('a.delete_notification').bind('click', function(){
    $(this).parents('tr').hide('slow');
  });

  $('tr.folded .message, tr.foldable .message').bind('click', function() {
    $this = $(this);
    $tr = $this.parents('tr');
    if ($tr.hasClass('unread')) {
      $tr.find('.read_notification').click();
      $tr.removeClass('unread');
    }
    $this.parents('tr').toggleClass('folded').toggleClass('foldable');
  });

  $('.quote-that').click(function(){
    $this = $(this)
    text = $this.data('content').split("\n");
    for(i = 0; i < text.length; i++) {
      text[i] = '> ' + text[i];
    }
    quote = '@' + $this.data('user') + ":\n" + text.join("\n");
    val = $wmd.val();
    if (val) {
      $wmd.val(val + "\n\n" + quote + "\n\n");
    } else {
      $wmd.val(quote + "\n\n");
    }
  });

  $('.use-that').click(function(){
    $wmd.val($(this).data('content'));
  });
});
