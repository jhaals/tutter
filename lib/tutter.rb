require 'rubygems'
require 'octokit'
require 'yaml'
require 'sinatra'
require 'tutter/action'
require 'json'

class Tutter < Sinatra::Base

  configure do
    set :config_path, ENV['TUTTER_CONFIG_PATH'] || "conf/tutter.yaml"
    set :config, YAML.load_file(settings.config_path)
  end

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    set :bind, '0.0.0.0'
  end

  configure :test do
    set :bind, '0.0.0.0'
  end

  # Return project settings from config
  def get_project_settings project
    settings.config['projects'].each do |p|
      return p if p['name'] == project
    end
    false
  end

  post '/' do
    # Github send data in JSON format, parse it!
    begin
      data = JSON.parse request.body.read
    rescue JSON::ParserError
      error(400, 'POST data is not JSON')
    end
    project = data['repository']['full_name'] || error(400, 'Bad request')

    conf = get_project_settings(project) || error(404, 'Project does not exist in tutter.conf')

    # Setup octokit endpoints
    Octokit.configure do |c|
      c.api_endpoint = conf['github_api_endpoint']
      c.web_endpoint = conf['github_site']
    end

    client = Octokit::Client.new :access_token => conf['access_token']

    # Load action
    action = Action.create(conf['action'],
                                 conf['action_settings'],
                                 client,
                                 project,
                                 data)

    status_code, message = action.run
    return status_code, message
  end

  get '/' do
    'Source code and documentation at https://github.com/jhaals/tutter'
  end

  run! if app_file == $0
end
