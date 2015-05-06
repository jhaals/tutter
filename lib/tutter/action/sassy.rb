# Example action
# Thank the person who submit an issue
# The comment text is configurabe using the 'comment' setting.

class Sassy
  def initialize(settings, client, project, data, event)
    @settings = settings # action specific settings
    @client = client # Octokit client
    @project = project # project name
    @event = event # Github event
    @data = data
  end

  def run
    # Only trigger if a new issue is created
    unless @data['action'] == 'created'
      return 200, "Web hook from GitHub for #{@project} does not have status created. Dont know what to do."
    end
    issue = @data['issue']['number']
    submitter = @data['issue']['user']['login']
    comment = @settings['sassy_comment'] || "@#{submitter} Oh! big man eh? knowlage and shit"

    begin
      @client.add_comment(@project, issue, comment)
      return 200, "Commented!"
    rescue Octokit::NotFound
      return 404, "Octokit returned 404, this could be an issue with your access token"
    rescue Octokit::Unauthorized
      return 401, "Authorization to #{@project} failed, please verify your access token"
    rescue Octokit::TooManyLoginAttempts
      return 429, "Account for #{@project} has been temporary locked down due to to many failed login attempts"
    end
    # TODO - Verify return data from @client.add_comment
  end

end
