require 'json'
require 'octokit'
require 'sinatra'
require 'thin'
require 'tutter/action'
require 'yaml'

# Modular sinatra app Tutter
class Tutter < Sinatra::Base
  enable :logging

  configure do
    set :config_path, ENV['TUTTER_CONFIG_PATH'] || 'conf/tutter.yaml'
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

  def verify_signature(payload_body, secret_token)
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret_token, payload_body)
    return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end

  # Return project settings from config
  def project_settings(project)
    settings.config['projects'].each do |p|
      return p if p['name'] == project
    end
    error(404, 'Project does not exist in tutter.conf')
  end

  # Return actions for event from config
  def actions_for_event(event, config)
    config['actions'][event] || error(404,
                                      "No Actions for #{event} in tutter.conf"
                                     )
  end

  def octokit_client(config)
    Octokit.configure do |c|
      c.api_endpoint = config['github_api_endpoint']
      c.web_endpoint = config['github_site']
    end

    if config['access_token_env_var']
      access_token = ENV[config['access_token_env_var']] || ''
    else
      access_token = config['access_token'] || ''
    end

    Octokit::Client.new access_token: access_token
  end

  def prepare_actions(project, event, data, config)
    client = octokit_client(config)
    actions_for_event(event, config).each do |a|
      yield Action.create(a,
                          config['action_settings'],
                          client,
                          project,
                          event,
                          data), a
    end
  end

  def try_actions(event, data, project, config)
    responses = { event: event, responses: {} }
    prepare_actions(project, event, data, config) do |action, name|
      status_code, message = action.run
      responses[:responses][name] = { status_code: status_code,
                                      message: message
                                    }
      break if status_code != 200
    end
    [responses[:responses].values.last[:status_code], responses.to_json]
  end

  post '/' do
    event = env['HTTP_X_GITHUB_EVENT'] || error(500, 'Invalid request')

    # Get a 200 OK message in the Github webhook history
    # Previously this showed an error.
    return 200, 'Tutter likes this hook!' if event == 'ping'

    # Github send data in JSON format, parse it!
    request_body = request.body.read
    begin
      data = JSON.parse request_body
    rescue JSON::ParserError
      error(400, 'POST data is not JSON')
    end

    project = data['repository']['full_name'] || error(400, 'Bad request')
    config = project_settings(project)
    verify_signature(request_body, config['hook_secret']) if config['hook_secret']

    return try_actions(event, data, project, config) if data['repository']
  end

  get '/' do
    'Source code and documentation at https://github.com/jhaals/tutter'
  end

  run! if app_file == $PROGRAM_NAME
end
