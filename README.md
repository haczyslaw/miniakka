# MiniAkka

[![Build Status](https://travis-ci.org/haczyslaw/miniakka.svg?branch=master)](https://travis-ci.org/haczyslaw/miniakka)

## Description

MiniAkka is a minimal wrapper around Akka Actors.
The main goal of project is to allow easly create actor router with supervisor.

More info about akka: http://akka.io

### Requirements

MiniAkka requires JRuby 9.x.x running on Java 8+.
The code has only been tested on JRuby 9.x.x but should work on earlier versions.

### Wrappers

* SimpleActor
* RoundRobinActor
* SmallestMailboxActor
* MasterActor (compatible with all)

### Libraries

scala-library, version 2.11.8

config, version 1.3.0

akka-actor, version 2.11-2.4.14

## Installation

Add this line to your application's Gemfile:

```
gem 'miniakka', git: 'git://github.com/haczyslaw/miniakka.git'
```

## Usage

```ruby
#! /usr/bin/env ruby

require 'mini_akka'
require 'matrix'

class KeanuActor < MiniAkka::SmallestMailboxActor
  # wrapper for response
  Response = Struct.new(:id, :start, :finish)

  def first(i)
    Matrix.columns([
      [Math.sin(i + rand(300)), Math.cos( i + rand(500)), Math.sqrt(i + rand(600))],
      [Math.cos(i + rand(600)), Math.sqrt( i + rand(2000)), Math.sqrt(i + rand(4000))]
    ])
  end

  def second(i)
    Matrix.columns([
      [Math.sin(Math.sqrt(i**2)), Math.cos(i + 500)],
      [Math.cos(i + rand(300)), (Math.sqrt(15000) - i)],
      [Math.sin(389), (Math.sqrt(15000) - i)]
    ])
  end

  def long_task
    10_000.times { |i| first(i) * second(i) }
  end

  def on_receive(message)
    start = Time.now
    long_task
    finish = Time.now
    res = Response.new(message, start, finish)
    get_sender.tell(res, get_self)
  end
end

class StressTestMaster < MiniAkka::MasterActor
  attr_reader :counter

  def on_receive(message)
    if message.is_a? MiniAkka::Msg
      puts "Started at: #{Time.now}"

      message.body.times do |id|
        actor_router.tell(id, get_self)
      end
    elsif message.is_a? KeanuActor::Response
      inc_counter
      puts message.inspect
      MiniAkka.system_shutdown if counter == 100
    end
  end

  def inc_counter
    @counter ||= 0
    @counter += 1
  end
end

module StressTestService
  module_function

  def start
    master = system.actor_of(StressTestMaster.props(KeanuActor), 'stress_test_master')

    master.tell(MiniAkka::Msg.new(100), no_sender)
  end

  def system
    MiniAkka.system
  end

  def no_sender
    MiniAkka::ActorRef.no_sender
  end
end

StressTestService.start
```

## Inspiration

A special thanks to Rocky Jaiswal and Maurício Szabo for inspiring this project.
Rocky wrote an excellent blog post about calculating PI using actors.
From Maurício's gist I borrow concept of Creator.

http://rockyj.in/2012/09/15/akka_with_jruby.html

https://gist.github.com/mauricioszabo/6a713fd416c512e49f70

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
