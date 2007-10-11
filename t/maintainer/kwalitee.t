#!/usr/bin/perl -w

use strict;
use Test::More;

# eval "use Test::Kwalitee";

         eval { require Test::Kwalitee; Test::Kwalitee->import() };


plan( skip_all => 'Test::Kwalitee not installed; skipping' ) if $@;

