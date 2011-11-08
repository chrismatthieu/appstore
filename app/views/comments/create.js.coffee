$('#comments').append('
<div class="bubble"><blockquote><p><%=@comment.comment%></p><br /><br /></blockquote><cite>
<a href="/<%= @current_user.username%>">
<% if @current_user.photo %>	
	<img src="<%= @current_user.photo %>" width="100" height="100" />
<% else %>
	<%= gravatar_image_tag @current_user.email, :class => "gravatar" rescue ""%>
<% end %>
<%= @current_user.username.capitalize%></a>

Updated <%= time_ago_in_words @comment.created_at %> ago</cite>

</div>') 
  .hide()
  .fadeIn()


