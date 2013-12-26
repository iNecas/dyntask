# -*- coding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dyntask/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dyntask"
  s.version     = Dyntask::VERSION
  s.authors     = ["Ivan Nečas"]
  s.email       = ["necasik@gmail.com"]
  s.homepage    = "https://github.com/iNecas/dyntask"
  s.summary     = "Rails engine integrating Dynflow as a general task-management solution"
  s.description = <<DESC
This engine brings Dynflow to your Rails project. It provides the basic setup of
the runtime as well as models for tasks and resources associations. The associations
are modeled with locks that also serve as a way how to prevent conflicts between
more tasks running against some resource at the same time.
DESC

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "dynflow"
  s.add_dependency "rabl"
  s.add_dependency "uuidtools"
  s.add_dependency "will_paginate"
end
