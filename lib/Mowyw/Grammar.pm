grammar Mowyw::Grammar;

our $open  = '[%';
our $close = '%]';

token TOP { ^ <chunk>* $ }

token chunk { <literal> | <directive> }

token literal {
    [<!before $open > .]+
}

token directive {
    $open ~ $close
    [<.ws> <command> <.ws> ]
}

token arg           { [<!before $close> \S]+ }

token slurpy_arg    { [<!before $close> .]+ }
token name          { <alpha> \w* }

proto token command { <...> }
token command:sym<comment> { <sym>  [ <!before $close> .]* }
token command:sym<include> { <sym> <.ws> <arg> }
rule  command:sym<setvar>  { <sym> <name> '='? <slurpy_arg> }
rule  command:sym<readvar> { <sym> <name> }
regex command:sym<verbatim> {
        <sym>
        <.ws> $close :
        (.*?) $open
        <.ws> 'endverbatim'
        <.ws> <?before $close>
        # the final %] is parsed by token directive
}


# vim: ft=perl6
