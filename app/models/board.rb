class Board
  include DataBuilderHelper

  def initialize(json = {})
    json.keys.each do |k|
      self.send("#{k}=",nested_hash_value(json, k.to_s))
    end unless json.blank?
  end

  private

  def method_missing(name,*args)
    accesor_builder name.to_s.chop, args[0]
  end

end
