class Project
  include DataBuilderHelper

  def initialize json = {}
    parse json unless json.blank?
  end

  private

  def parse json
    json.keys.each {|key|
      v = nested_hash_value(json, key.to_s)
      accesor_builder key, v
    }
  end

end