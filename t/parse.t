use v6;
use Test;
use Mowyw::Grammar;


my @samples =
    [1, '',                         'empty string'],
    [1, 'foobar',                   'alpha'],
    [0, '[% bla',                   'unmatched opening'],
    [1, '[% comment abc def %]',    'comment'],
    [1, 'foo [% comment %] bar',    'comment with context'],
    [0, '[% unknown command %]',    'unknown command'],
    [1, '[% include blubb %]',      'include'],
    [0, '[% include a b %]',        'include takes just one arg'],
    [1, '[% setvar foo bar baz %]', 'setvar'],
    [1, '[% setvar foo = bar baz %]', 'setvar with optional ='],
    [1, '[% readvar foo %]',        'readvar'],
    [0, '[% readvar %]',            'readvar neads a var name'],

    ;

plan +@samples;

for @samples -> $s {
    my ($should_match, $sample, $desc) = $s.flat;

    my $success = 0;
    my $diag;
    try {
        $success = ?Mowyw::Grammar.parse($sample);
        CATCH {
            $diag = "$!";
        }
    }
    ok($should_match !^ $success, $desc) or do {
        diag $diag if $diag;
    }
}

done_testing;

# vim: ft=perl6
