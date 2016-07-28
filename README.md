# Tutter - Plugin based Github robot
[![Build Status](https://travis-ci.org/jhaals/tutter.png?branch=master)](https://travis-ci.org/JHaals/tutter)

Tutter is a robot that can trigger customizable actions based on Github [events]((https://developer.github.com/v3/activity/events/types/)(push, pull_request, release, issue, ..)


# Installation

    gem install tutter

Place configuration file in `/etc/tutter.yaml`, example can be found in the conf/ directory.

### tutter.yaml settings

* `name` - username/project_name
* `access_token` - Github access token (can be generated [here](https://github.com/settings/applications))
* `github_site` - github website
* `github_api_endpoint` - github api endpoint
* `hook_secret` - (Optional) validate hook data based on known secret([more](https://developer.github.com/webhooks/securing/)).
* `action` - action you wish to use for the project
* `action_settings` - whatever settings your action require

### Configure Tutter action
Hooks can be configured just to send the event that you're interested in. The important part is that `Payload URL` points to the webserver running Tutter

    https://github.com/ORG/PROJECT/settings/hooks/new

Example on how the `thanks` action looks like. Tutter listens for `issue` events and posts back with a greeting.
![img](http://f.cl.ly/items/1k111I3H1N0L3008301c/tutter.png)

## Build custom action

A simple action for getting started is the built in [thanks](https://github.com/jhaals/tutter/blob/master/lib/tutter/action/thanks.rb) action.
More advanced usage can be seen in the [tutter-sppuppet](https://github.com/jhaals/tutter-sppuppet) action that allows non-collaborators to merge pull requests

##### Required methods and their arguments

`initialize`

    settings - contains a hash of action specific settings
    client - Used to access the github api, all authentication is already done by tutter
    project - Project name, eg jhaals/tutter
    event - Event type
    data - POST data that github send when a hook is triggered

`run` - Run action

Tutter uses [octokit.rb](https://github.com/octokit/octokit.rb) to communicate with the Github [API](http://developer.github.com/v3/)

### Features to implement
* Authenticate as a Github application
