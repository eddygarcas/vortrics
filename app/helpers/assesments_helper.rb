module AssesmentsHelper

  def flash_display
    response = ""
    flash.each do |name, msg|
      msg=msg ###"<i class='fa fa-quote-left fa-border'></i>"+msg+"<i class='fa fa-quote-right fa-border'></i>"+"<button type='button' class='close' title='hide' data-dismiss='alert'><i class='fa-times-circle-o fa pull-right'></i></button>".html_safe
      response = response +
          content_tag(:div, msg, :id => "flash_#{name}", :class => "alert alert-danger") do
            "#{msg}".html_safe
          end
    end
    flash.discard
    response
  end

  def each_level index = 3
    ['info','success','danger','default'].at(index)
  end
end
