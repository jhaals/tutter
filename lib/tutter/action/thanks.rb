# Example action
# Thank the person who submit an issue

class Thanks
  def initialize(settings, client, project, data)
    @settings = settings # action specific settings
    @client = client # Octokit client
    @project = project # project name
    @data = data
  end

  def run
    # Only trigger if a new issue is created
    return unless @data['action'] == 'opened'

    issue = @data['issue']['number']
    submitter = @data['issue']['user']['login']
    comment = "@#{submitter} thanks for submitting this issue!"

    begin
      @client.add_comment(@project, issue, comment)
    rescue Octokit::Unauthorized
     return "Authorization to #{@project} failed, please verify your access token"
    rescue Octokit::TooManyLoginAttempts
     return "Account for #{@project} has been temporary locked down due to to many failed login attempts"
    rescue Exception => e
      return e.to_s
    end
  end

end