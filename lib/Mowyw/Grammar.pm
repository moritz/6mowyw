grammar Mowyw::Grammar;

token TOP { ^ <chunk>* $ }

token chunk { <literal> | <directive> }

token literal {
    [<!before '[%' > .]+
}

token directive {
    '[%' ~ '%]'
    [<.ws> <command> <.ws> ]
}

token arg           { [<!before '%]'> \S]+ }

token slurpy_arg    { [<!before '%]'> .]+ }
token name          { <alpha> \w* }

proto token command { <...> }
token command:sym<comment> { <sym>  [ <!before '%]'> .]* }
token command:sym<include> { <sym> <.ws> <arg> }
rule  command:sym<setvar>  { <sym> <name> '='? <slurpy_arg> }
rule  command:sym<readvar> { <sym> <name> }
regex command:sym<verbatim> {
        <sym>
        <.ws> '%]' :
        (.*?) '[%'
        <.ws> 'endverbatim'
        <.ws> <?before '%]'>
        # the final %] is parsed by token directive
}


# vim: ft=perl6
