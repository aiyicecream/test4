//= require latinise
//= require jquery
//= require jquery_ujs
//= require jquery.caretposition
//= require jquery.sew
//= require jquery.tablednd
//= require jquery.tokeninput
//= require textarea.jquery
//= require detect_timezone
//= require garlic
//= require bootstrap
//= require markdown.converter
//= require markdown.sanitizer
//= require markdown.editor
//= require gritter
//= require users
//= require topics
//= require forums
//= require messages
//= require highcharts
//= require modernizr
//= require private_pub
//
// Troubles with require_tree which includes scripts twice
// require_tree .

document.cookie = 'time_zone='+jstz.determine_timezone().timezone.olson_tz+';';

var values = [];
$(document).ready(function() {
  // Does not submit forms twice
  $('form:not([data-remote])').submit(function(){
    $this = $(this);
    if ($this.data('submitted')) {
      return false;
    } else {
      $this.find('input[type=submit]').addClass('disabled');
      $this.data('submitted', true);
    }
  });

  $("input[data-token]").each(function(index){
    $this = $(this);
    $this.tokenInput("/users/tokens.json", {
      theme: 'facebook',
      hintText: null,
      noResultsText: null,
      searchingText: null,
      animateDropdown: false,
      prePopulate: $this.data('prepopulate'),
      preventDuplicates: true
    });
  });

  $("input[data-users]").each(function(index){
    $this = $(this);
    $this.tokenInput("/users/ajax.json", {
      theme: 'facebook',
      hintText: null,
      noResultsText: null,
      searchingText: null,
      animateDropdown: false,
      prePopulate: $this.data('prepopulate'),
      preventDuplicates: true
    });
  });

  // small messages

  $(document).on('ajax:beforeSend', 'a.delete_small_message', function(){
    $(this).css('visibility', 'hidden');
  }).on('ajax:complete', 'a.delete_small_message', function(){
    $(this).parent().hide('slow');
  });

  $('form.new_small_message').bind('ajax:beforeSend', function(e, data){
    $(this).find('#small_message_content').blur().attr('value', '').attr('disabled', 'disabled').css('visibility', 'hidden');
  })
});
