class Action
  def self.create(action, settings, client, project, event, data)
    begin
      require "tutter/action/#{action.downcase}"
    rescue LoadError => e
      raise "Unsupported action #{action}: #{e}"
    end
    class_name = action.split("_").map {|v| v.capitalize }.join
    const_get(class_name).new settings, client, project, event, data
  end
end
