# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = 'tutter'
  s.version     = '0.0.1'
  s.author      = 'Johan Haals'
  s.email       = ['johan.haals@gmail.com']
  s.homepage    = 'https://github.com/jhaals/tutter'
  s.summary     = 'Github merge robot'
  s.description = 'Tutter is a pluggable merge bot for github. Tutter can merge code automatically based on your criterias'
  s.license     = 'Apache 2.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*_spec.rb`.split("\n")
  s.require_paths = ['lib', 'conf']

  s.required_ruby_version = '>= 1.8.7'
  s.add_runtime_dependency 'sinatra'
  s.add_runtime_dependency 'octokit'
end

