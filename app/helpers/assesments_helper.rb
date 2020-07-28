module AssesmentsHelper
  def each_level index = 3
    ['info','success','danger','default'].at(index)
  end
end
