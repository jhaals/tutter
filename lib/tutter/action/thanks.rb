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

    puts comment # just for debug purpose
    @client.add_comment(@project, issue, comment)
  end

end