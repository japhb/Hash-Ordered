use v6.c;
use Test;

use Hash::Ordered;

plan 11;

my @keys   := <b c d e f g h a>;
my @values := 666, 314, 628, 271, 6, 7, 8, 42;
my @pairs  := (@keys Z=> @values).List;
my @kv     := (@keys Z @values).flat.List;

my %h is Hash::Ordered = @pairs;
subtest {
    is %h.elems, +@keys, "did we get {+@keys} elements";
    is %h.gist,
      '{b => 666, c => 314, d => 628, e => 271, f => 6, g => 7, h => 8, a => 42}',
      'does .gist work ok';
    is %h.Str,
      'b	666 c	314 d	628 e	271 f	6 g	7 h	8 a	42',
      'does .Str work ok';
    is %h.raku,
      'Hash::Ordered.new(:b(666),:c(314),:d(628),:e(271),:f(6),:g(7),:h(8),:a(42))',
      'does .raku work ok';
}, 'test basic stuff after initialization';

is-deeply %h.keys.List,     @keys, 'are the keys in order';
is-deeply %h.values.List, @values, 'are the values in order';
is-deeply %h.pairs.List,   @pairs, 'are the pairs in order';
is-deeply %h.kv.List,         @kv, 'are the key / values in order';

subtest {
    plan +@keys;
    my %test = @pairs;
    is %test{.key}, .value, "did iteration {.key} produce %test{.key}"
      for %h;
}, 'checking iterator';

subtest {
    plan +@keys;
    my %test = @pairs;
    is %h{$_}, %test{$_}, "did key $_ produce %test{$_}"
      for @keys;
}, 'checking {x}';

subtest {
    plan 4;
    ok %h<g>:exists, 'does "g" exist';
    is %h<g>:delete, 7, 'does delete return the right value';
    nok %h<g>:exists, 'has element been removed';
    is %h.elems, @keys - 1, 'do we have one elem less';
}, 'deletion of key';

subtest {
    plan 4;
dd %h<d>:exists;
dd %h<e>:exists;
dd %h<f>:exists;
    is-deeply %h<d e f>:exists, (True,True,True),
      'can we check existence of an existing slice';
    is %h<d e f>:delete, (628,271,6), 'can we remove an existing slice';
    is-deeply %h<d e f>:exists, (False,False,False),
      'can we check existence of removed slice';
    is %h.elems, @keys - 4, 'did we update number of elements';
}, 'can we delete a slice';
=finish

subtest {
    plan 3;
    is-deeply (%h{@keys}:v), @values, 'does a value slice work';
    is-deeply (%h{}:v),      @values, 'does a value zen-slice work';
    is-deeply (%h{*}:v),     @values, 'does a value whatever-slice work';
}, 'can we do value slices';

lives-ok { %h = @pairs }, 'can re-initialize a Hash';

# vim: expandtab shiftwidth=4
