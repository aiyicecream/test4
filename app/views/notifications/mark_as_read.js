$notifications = $('#faye-notifications');
$notifications.html('<%= current_user.notifications_count %>');
<% if current_user.notifications_count == 0 %>
  $notifications.addClass('hidden');
<% end %>
