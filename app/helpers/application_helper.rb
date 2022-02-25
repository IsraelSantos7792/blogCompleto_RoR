module ApplicationHelper
  def render_if(conditon, template, record)
    render template, record if conditon
  end
end
