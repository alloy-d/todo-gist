# todo-gist

A todo list persisted in a Gist.

## Usage

    $ gem install todo-gist
    $ cat > ~/.github_credentials.json
    { "username": "YOU", "password": "YOUR SECRET" }
    ^D
    $ task enqueue Add something to the end of the list.
    $ task push Add something to the beginning of the list.
    $ task list
    Add something to the beginning of the list.
    Add something to the end of the lest.
    $ task push Finish a task, already.
    $ task next
    Finish a task, already.
    $ task pop
    FINISHED: Finish a task, already.

## Meta

    $ task push Make the CLI not suck.
    $ task enqueue Add documentation.
    $ task enqueue Add tests.

## Contributing to todo-gist
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Adam Lloyd. See LICENSE.txt for
further details.

