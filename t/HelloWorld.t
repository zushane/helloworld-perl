use strict;
use warnings;
use Test::More qw(no_plan);

# Verify module can be included via "use" pragma
BEGIN { use_ok('HelloWorld') };

# Verify module can be included via "require" pragma
require_ok( 'HelloWorld' );

# Test hello() routine using a regular expression
my $helloCall = HelloWorld::hello();
like($helloCall, qr/Hello, .*world/, "hello() RE test");

# Test hello_message() routine using a got/expected routine
is($helloCall, "Hello, world!", "hello() IS test");

# Test bye() routine using a regular expression
my $byeCall = HelloWorld::bye();
like($byeCall, qr/Goodbye, then/, "bye() RE test");

# Test goodbye_message() routine using a got/expected routine.
is($byeCall, "Goodbye, then!", "bye() IS test");

# Test what_message() routine using a regular expression
my $whatCall = HelloWorld::what();
like( $whatCall, qr/^What.*\?/, "what() RE test" );

# Test what_message() routine using a got/expected routine.
is($whatCall, "What even IS this world?", "what() IS test");

# Test repeat() routine using a got/expected routine
for (my $ctr=1; $ctr<=10; $ctr++) {
    my $repeatCall = HelloWorld::repeat();
    is($repeatCall, 1, "repeat() IS test");
}

# Test argumentTest() 
my $argumentTestCall1 = HelloWorld::argumentTest();
is($argumentTestCall1, "null", "argumentTest() IS null test");

# Test argumentTest("true") 
my $argumentTestCall2 = HelloWorld::argumentTest("true");
is($argumentTestCall2, "true", "argumentTest() IS true test");

# Test argumentTest("false") 
my $argumentTestCall3 = HelloWorld::argumentTest("false");
is($argumentTestCall3, "false", "argumentTest() IS false test");

# Test argumentTest(123) 
my $argumentTestCall4 = HelloWorld::argumentTest(123);
is($argumentTestCall4, "unknown", "argumentTest() IS unknown test");
