class Hash
  def method_missing(name,*args)
    attribute = name.to_s
    if attribute =~ /=$/
      self[attribute.chop.to_sym] = args[0]
    else
      return self[attribute.to_sym]
    end
  end
end
