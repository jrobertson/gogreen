# Introducing the GoGreen gem

Usage:

    require 'gogreen'

    a = %w(http://a0.jamesrobertson.eu/qbx/r/mia-aliases.txt $1)
    gg = GoGreen.new(a.first)
    puts gg.execute(a[1], a[2..-1]).to_s


Shell script usage:

    #!/bin/bash

    # file: gg2.sh

    ruby -r gogreen -e "a = %w(http://a0.jamesrobertson.eu/qbx/r/mia-aliases.txt $1); gg = GoGreen.new(a.first); puts gg.execute(a[1], a[2..-1]).to_s"


Note: I use the latter form when I need to run a script from within a Docker container for example.

## Resources

* gogreen https://rubygems.org/gems/gogreen

gogreen
