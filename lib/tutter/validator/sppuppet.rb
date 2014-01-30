class Sppuppet

  def initialize(settings, client)
    @settings = settings
    @client = client
  end

  def validate project, pull_request_id
    pr = @client.pull_request project, pull_request_id
    plus_one = {}
    merge = false

    if pr.mergeable_state != 'clean'
      puts "merge state for #{project} #{pull_request_id} is not clean. Current state: #{pr.mergeable_state}"
      return false
    end

    # Don't care about code we can't merge
    return false unless pr.mergeable

    comments = @client.issue_comments(project, pull_request_id)

    # Check each comment for +1 and merge comments
    comments.each do |i|

      if /^\+1/.match i.body
        # pull request submitter cant +1

        unless pr.user.login == i.attrs[:user].attrs[:login]
          plus_one[i.attrs[:user].attrs[:login]] = 1
        end
      end

      # TODO it should calculate the +1's - the -1's
      # Never merge if someone says -1
      if /^\-1/.match i.body
        puts "#{project} #{pull_request_id} has a -1. I will not take the blame"
        return false
      end
    end

    merge = true if comments.last.body == '!merge'

    if plus_one.count >= @settings['plus_ones_required'] and merge
      return true
    end
  end

  def merge project, pull_request_id
    puts "merging #{pull_request_id} in #{project}"
    @client.merge_pull_request(project, pull_request_id, 'SHIPPING!!')
  end

end
