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
    unless @data['action'] == 'opened'
      return 200, "Web hook from GitHub for #{@project} does not have status opened. We don't thank people for closing issues"
    end
    issue = @data['issue']['number']
    submitter = @data['issue']['user']['login']
    comment = "@#{submitter} thanks for submitting this issue!"

    begin
      @client.add_comment(@project, issue, comment)
    rescue Octokit::Unauthorized
      return 401, "Authorization to #{@project} failed, please verify your access token"
    rescue Octokit::TooManyLoginAttempts
      return 429, "Account for #{@project} has been temporary locked down due to to many failed login attempts"
    end
    # TODO - Verify return data from @client.add_comment
  end

end