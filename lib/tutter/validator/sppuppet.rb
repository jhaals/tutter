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
      puts "NOT TESTED IN JENKINS mergable status #{pr.mergeable_state}"
      return false
    end

    # Don't care about code we can't merge
    return false unless pr.mergeable

    comments = @client.issue_comments(project, pull_request_id)
    # Check each comment for +1 and merge comments
    comments.each do |i|

      if i.body == '+1'
        # pull request submitter cant +1

        unless pr.user.login == i.attrs[:user].attrs[:login]
          plus_one[i.attrs[:user].attrs[:login]] = 1
        end
      end

      # TODO it should calculate the +1's - the -1's
      # Never merge if someone says -1
      if i.body == '-1'
        puts 'This PR has a -1. I will not take the blame'
        return false
      end
    end

    merge = true if comments.last.body == 'merge this please'

    if plus_one.count >= @settings['plus_ones_required'] and merge
      puts 'LOOKS GOOD TO ME'
      return true
    end
  end

  def merge project, pull_request_id
    puts 'merging'
    @client.merge_pull_request(project, pull_request_id, 'SHIPPING!!')
  end

end
