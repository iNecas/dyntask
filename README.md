Dyntask
=======

Tasks management Rails engine. Gives you and overview of what's
happening/happened in your Rails app.

Installation
------------

Put the following to your Gemfile

```ruby
gem 'dynflow', :git => 'git@github.com:iNecas/dynflow.git'
gem 'sinatra' # we use the dynflow web console
gem 'sequel'  # we use the dynflow default Dynflow persistence adapter
gem 'foreman-tasks', :git => 'git@github.com:iNecas/dyntask.git'
```

Run:

```bash
bundle install
rake db:migrate
```

Usage
-----

In the UI, go to `/dyntask/tasks`. This should give a list of
tasks that were run in the system.

Dynflow Integration
-------------------

This engine is agnostic on background processing tool and can be used
with anything that supports some kind of execution hooks.

On the other side, it's already integrated with Dynflow and uses
that by defaults for running tasks.

The Dynflow console is accessible on `/dyntask/dynflow` path.

Status
------

This gem is in early stages of development and it's not recommended to
use it in production environment just yet, unless you know what you're
doing.

However, it should already be useful enough to start playing with it
(see examples). It also serves as an incubator and testing environment
for Dynflow changes.

Examples
--------

[Sysflow](https://www.github.com/iNecas/sysflow) - simple Rails app
for running system commands in parallel.

Documentation
-------------

TBD - dig into the code for now (happy hacking:)

Tests
-----

TBD

License
-------

MIT

Author
------

Ivan Nečas
