# Tutter - Plugin based Github robot
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

### Create the Github hook
Github has no UI for creating hooks other then hooks triggered on push.

Let's create one that triggers on issues

    $ tutter --project jhaals/testing \
    --url https://tutter.jhaals.se \
    --access-token <github_api_token> \
    --github-web-url https://github.com \
    --github-api-endpoint https://api.github.com \
    --events issues

## Build custom action

Another example action [github.com/jhaals/tutter-sppuppet](https://github.com/jhaals/tutter-sppuppet)

#####Required methods and their arguments

`initialize`

    settings - contains a hash of action specific settings
    client - Used to access the github api, all authentication is already done by tutter
    project - Project name, eg jhaals/tutter
    data - POST data that github send when a hook is triggered

`run` - Run action

Tutter uses [octokit.rb](https://github.com/octokit/octokit.rb) to communicate with the Github [API](http://developer.github.com/v3/)

### Features to implement
* Add web hooks in Github automatically
* Support multiple actions per project
* Authenticate as a Github application
* Features your're missing (please contribute)