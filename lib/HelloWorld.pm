use strict;
use warnings;
package HelloWorld;

$HelloWorld::VERSION = '0.2.0';

sub hello {
   return "Hello, world!";
}

sub bye {
   return "Goodbye, then!";
}

sub what {
    return "What even IS this world?";
}

sub synonym {
	my @array = ( "earth", "globe", "planet", "all of creation" );
	return $array[rand @array];
}

sub repeat {
   return 1;
}

sub untested {
    return 1;
}

sub argumentTest {
    my ($booleanArg) = @_;

    if (!defined($booleanArg)) {
        return "null";
    }
    elsif ($booleanArg eq "false") {
        return "false";
    }
    elsif ($booleanArg eq "true") {
        return "true";
    }
    else {
        return "unknown";
    }

   return "Unreachable code: cannot be covered";
}

1;
