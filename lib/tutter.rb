require 'octokit'
require 'yaml'
require 'sinatra'
require 'tutter/action'
require 'json'

class Tutter < Sinatra::Base
  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    set :config, YAML.load_file('conf/tutter.yaml')
    set :bind, '0.0.0.0'
  end

  configure :production do
    set :config, YAML.load_file('/etc/tutter.yaml')
  end

  def get_project_settings project
    settings.config['projects'].each do |p|
      return p if p['name'] == project
    end
    false
  end

  post '/' do
    data = JSON.parse request.body.read
    project = data['repository']['full_name']
    issue = data['issue']['number']
    conf = get_project_settings(project)

    return 'Project does not exist in tutter.conf' unless conf

    Octokit.configure do |c|
      c.api_endpoint = conf['github_api_endpoint']
      c.web_endpoint = conf['github_site']
    end

    begin
      client = Octokit::Client.new :access_token => conf['access_token']
    rescue Octokit::Unauthorized
      return "Authorization to #{project} failed, please verify your access token"
    rescue Octokit::TooManyLoginAttempts
      return "Account for #{project} has been temporary locked down due to to many failed login attempts"
    end


    action = Action.create(conf['action'],
                                 conf['action_settings'],
                                 client,
                                 project,
                                 data)

    action.run

    return 'Source code and documentation at https://github.com/jhaals/tutter'
  end
  run! if app_file == $0
end
