module Builder

  def initialize(json = nil)
    @attributes = {}
    json.each do |k, v|
      self.send("#{k}=", v)
    end unless json.blank?
  end

  def method_missing(name, *args)
    attribute = name.to_s.start_with?(/\d/) ? "_#{name.to_s}" : name.to_s
    if attribute =~ /=$/
      if args[0].respond_to?(:key?) || args[0].is_a?(Hash)
        @attributes[attribute.chop] = self.class.new(args[0])
      else
        @attributes[attribute.chop] = args[0]
      end
    else
      @attributes[attribute]
    end
  end

end
