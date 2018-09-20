class ArrayType < ActiveRecord::Type::Text
  def type_cast(value)
    Array.wrap(YAML::load(value || YAML.dump([])))
  end
end