#!perl6

use v6.c;
use Test;

use GDBM;

my $file = "hash-test.db";

my $obj;

lives-ok { $obj = GDBM.new($file) }, "create one";

nok $obj.exists("foo"), "non-existent key doesn't exist";

lives-ok { $obj.store("foo", "bar") }, "set a value";
like $obj.perl, /{:foo("bar")}/, "perl looks fine";
is $obj.fetch("foo"), "bar", "and got it back";
ok $obj.exists("foo"), "and exists";
lives-ok {
    ok (my @keys = $obj.keys), "get keys";
    is @keys.elems, 1, "only one";
    is @keys[0], "foo", "and the right one";
}, "keys";

lives-ok {
    my $i = 0;
    for $obj.kv -> $k, $v {
        $i++;
        is $k, "foo", "got the right key";
        is $v, "bar", "got the right value";
    }

    is $i, 1, "and only got the one";
}, "kv";

lives-ok {
    my $i = 0;
    for $obj.pairs -> $p {
        isa-ok $p, Pair, "it's a pair";
        is $p.key, "foo", "got the right key";
        is $p.value, "bar", "got the right value";
        $i++;
    }
    is $i, 1, "and only got the one";
}, "pairs";

lives-ok { $obj.delete("foo") }, "delete the value";
nok $obj.exists("foo"), "non-existent key doesn't exist";
lives-ok {
    nok $obj.fetch("foo").defined, "returns undefined if no key";
}, "fetch with non-existent key";

lives-ok {
    nok (my @keys = $obj.keys), "get keys shouldn't be any";
}, "keys no elements";




END {
    if $file.IO.e {
        $file.IO.unlink;
    }
}

done-testing;
# vim: expandtab shiftwidth=4 ft=perl6
