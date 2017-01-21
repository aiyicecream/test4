module ApplicationHelper
  def sortable(klass, column, title = nil)
    title ||= klass.human_attribute_name(column)
    if (column == params[:sort].to_sym)
      link_to title, params.merge({:sort => column, :direction => params[:direction] == 'asc' ? 'desc' : 'asc'}), {:class => "current #{params[:direction]}"}
    else
      link_to title, params.merge({:sort => column, :direction => klass.default_direction(column.to_s)})
    end
  end
end
