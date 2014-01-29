class Validator
  def self.create(validator, settings, client)
    begin
      require "tutter/validator/#{validator.downcase}"
    rescue LoadError => e
      raise "Unsupported validator #{validator}: #{e}"
    end
    class_name = validator.split("_").map {|v| v.capitalize }.join
    const_get(class_name).new settings, client
  end
end
