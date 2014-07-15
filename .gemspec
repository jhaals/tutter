# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = 'tutter'
  s.version     = '0.0.1'
  s.author      = 'Johan Haals'
  s.email       = ['johan.haals@gmail.com']
  s.homepage    = 'https://github.com/jhaals/tutter'
  s.summary     = 'Plugin based Github robot'
  s.description = 'Tutter is a web app that trigger actions based on Github events(push, pull_reqeust, release, issue, ...)'
  s.license     = 'Apache 2.0'

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files bin`.split("\n").map { |f| File.basename f }
  s.require_paths = ['lib', 'conf']

  s.required_ruby_version = '>= 1.8.7'
  s.add_runtime_dependency 'sinatra', '~> 1.4.4'
  s.add_runtime_dependency 'octokit', '~> 3.2.0'
end

