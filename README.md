# Tutter (WIP)
Tutter is a "pluggable" Github robot. Use it to trigger actions based on merges, issues or pull requests added to your project.

The default action that's shipped with tutter allow anyone to merge a commit that has a _+1_ comment by more then two people. The commit can be merged by adding a comment that says _!merge_

The default action that's shipped with tutter. You can create your own.

    Trigger on pull requests ->
    Wait until github says build is clean(eg when jenkins says tests passed) ->
    Require a +1 comment by two users ->
    Require !merge comment by one user ->
    Merge pull request

#  Features
* Pluggable with custom actions
* Supports multiple projects

# Installation
    gem install tutter

put a configuration file in /etc/tutter.yaml
an example can be found under conf/tutter.yaml

Configuration settings

* `name` - username/projectname
* `access_token` - github access token
* `github_site` - github website
* `github_api_enpoint` - github api endpint
* `action` - action you wish to use for this project
* `action_settings` - whatever settings your action require. All action settings will be available in the action.

### Build a custom action

An example action can be found in lib/tutter/action/sppuppet.rb

#####Required methods and their arguments

`initialize`

    settings - contains a hash of action specific settings
    client - Used to access the github api, all authentication is already done by tutter
    project - Project name, eg jhaals/tutter
    data - POST data from Github
`run` - Run action

Tutter uses [octokit.rb](https://github.com/octokit/octokit.rb) to communicate with the Github [API](http://developer.github.com/v3/)

## Features to implement
* Add Web hooks in Github automatically