# Tutter - Plugin based Github robot
[![Build Status](https://travis-ci.org/JHaals/tutter.png?branch=master)](https://travis-ci.org/JHaals/tutter)

Tutter is a web app that trigger actions based on Github events(push, pull_reqeust, release, issue, ...)

# Features
* Pluggable with custom actions
* Supports multiple projects

# Installation

    gem install tutter

put a configuration file in `/etc/tutter.yaml`
an example can be found under `conf/tutter.yaml`

Let's install the `thanks` action that thank anyone that creates an issue in your project.

### tutter.yaml settings

* `name` - username/projectname
* `access_token` - github access token (can be generated [here](https://github.com/settings/applications))
* `github_site` - github website
* `github_api_enpoint` - github api endpint
* `action` - action you wish to use for the project
* `action_settings` - whatever settings your action require

### Create the Github webhook
Hooks can be configured just to send the event that you're interested in. The important part is that `Payload URL` points to the webserver running tutter

    https://github.com/ORG/PROJECT/settings/hooks/new

Example of how the `thanks` demo-action look like. Tutter listen for issue events and posts back with a greeting.
![img](http://f.cl.ly/items/1k111I3H1N0L3008301c/tutter.png)

## Build custom action

See [thanks action](https://github.com/jhaals/tutter/blob/master/lib/tutter/action/thanks.rb)

#####Required methods and their arguments

`initialize`

    settings - contains a hash of action specific settings
    client - Used to access the github api, all authentication is already done by tutter
    project - Project name, eg jhaals/tutter
    event - Event type
    data - POST data that github send when a hook is triggered

`run` - Run action

Tutter uses [octokit.rb](https://github.com/octokit/octokit.rb) to communicate with the Github [API](http://developer.github.com/v3/)

### Features to implement
* Support multiple actions per project
* Authenticate as a Github application
* Features your're missing (please contribute)
* Tests!
