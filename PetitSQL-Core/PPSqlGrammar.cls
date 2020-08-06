"Filed out from Dolphin Smalltalk 7"!

PPCompositeParser subclass: #PPSqlGrammar
	instanceVariableNames: 'command number condition createCommand deleteCommand insertCommand selectCommand updateCommand expression sequence whereClause limitClause operator comparison logic identifier string'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPSqlGrammar guid: (GUID fromString: '{d069dabd-e583-413a-8e19-1190fa42af2f}')!
PPSqlGrammar comment: 'command ::= define_data
    | modify_data
    | system_command

define_data ::= create_command 

modify_data ::= select_command
    | insert_command
    | update_command
    | delete_command

system_command ::=
    | describe_command
    |	open_command
    | close_command
    | save_command
    | list_command
    | clear_command
    | dump_command
    | help_command

create_command ::=
    ( "CREATE" | "create" ) (character_set)+ 
    "("((character_set)+,)+")" 
    ("WITH"|"with") ("VALUES"|"values") 
    "("((character_set)+,)+")" 

select_command ::= 
    ("SELECT"|"select")  
    ("*"|(character_set)+) 
    ("FROM"|"from") 
    (character_set)+ 
    [("WHERE"|"where") condition]
    [("LIMIT"|"limit") (numeric)+]

insert_command ::= 
    ( "INSERT" | "insert" ) 
    ("INTO"|"into") 
    (character_set)+ 
    "("((character_set)+,)+")" 
    ("VALUES"|"values") 
    "("((character_set)+,)+")" 

update_command ::= 
    ("UPDATE"|update")
    (character_set)+ 
    ("SET"|"set")
    (character_set)+ 
    "="
    (character_set)+ 
    [("WHERE"|"where") condition]

delete_command ::= 
    ("DELETE"|"delete")
    ("FROM"|"from")
    (character_set)+ 
    [("WHERE"|"where") condition]

open_command ::=
    ("OPEN"|"open")
    (character_set)+ 

close_command ::=
    ("CLOSE"|"close")
    (character_set)+ 

save_command ::= 
    ("SAVE"|"save")
    | ("SAVE"|"save")
      ("AS"|"as")
      (character_set)+ 

list ::=
    ("LS"|"ls"|"DIR"|"dir")
    | ("LS"|"ls"|"DIR"|"dir")
      (character_set)+

clear ::=
    ("CLEAR"|"clear"|"CLS"|"cls")

dump ::= 
    ("DUMP"|"dump")

help ::=
    ("help"|"HELP"|"/HELP"|"/help"|"/?")

condition ::= 
    (character_set)+
    (["<"|">"|"!!"]=|["<"|">"|"="])
    (character_set)+
    [(("AND"|"and")|("OR"|"or"))
    (character_set)+
    (["<"|">"|"!!"]=|["<"|">"|"="])
    (character_set)+]

character_set ::= 
    "a"|"b"|"c"|"d"|"e"|"f"|"g"|"h"|"i"|"j"|"k"|"l"|"m"
    "n"|"o"|"p"|"q"|"r"|"s"|"t"|"u"|"v"|"w"|"x"|"y"|"z"
    |"A"|"B"|"C"|"D"|"E"|"F"|"G"|"H"|"I"|"J"|"K"|"L"|"M"
    |"N"|"O"|"P"|"Q"|"R"|"S"|"T"|"U"|"V"|"W"|"X"|"Y"|"Z"
    |"0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"
    |"-"|"_"|"("|")"|"."|","|"""|"/"|"\"|"@"|"#"|"~"|"|"
    |"*"|"&"|"%"|"$"|"�Ǭ�"|"!!"|"+"|"?"|">"|"<"|"="

numeric ::= 
    "0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"
'!
!PPSqlGrammar categoriesForClass!PetitSQL-Core! !
!PPSqlGrammar methodsFor!

command
	^ createCommand / deleteCommand / insertCommand / selectCommand / updateCommand!

comparison
	^ expression , operator , expression!

condition
	^ comparison separatedBy: logic!

createCommand
	^ 'CREATE' sqlToken , expression , $( sqlToken , sequence , $) sqlToken , 'WITH' sqlToken , 'VALUES' sqlToken , $( sqlToken , sequence , $) sqlToken!

deleteCommand
	^ 'DELETE' sqlToken , 'FROM' sqlToken , expression , whereClause optional!

expression
	^ identifier / number / string!

identifier
	^ #letter asParser plus token trim!

insertCommand

	^ 'INSERT' sqlToken , 'INTO' sqlToken , expression , $( sqlToken , sequence , $) sqlToken , 'VALUES' sqlToken , $( sqlToken , sequence , $) sqlToken!

limitClause
	^ 'LIMIT' sqlToken , number!

logic
	^ 'AND' sqlToken / 'OR' sqlToken!

number
	^ #digit asParser plus token trim!

operator
	^ ('<=' asParser / '>=' asParser / '!!=' asParser / $< asParser / $> asParser / $= asParser) token trim!

selectCommand
	^ 'SELECT' sqlToken , ($* sqlToken / sequence) , 'FROM' sqlToken , sequence , whereClause optional , limitClause optional!

sequence
	^ expression separatedBy: $, sqlToken!

start
	^ command!

string
	^ ($" asParser , $" asParser negate star , $" asParser) token trim!

updateCommand
	^ 'UPDATE' sqlToken , expression , 'SET' sqlToken , expression , $= sqlToken , expression , whereClause optional!

whereClause
	^ 'WHERE' sqlToken , condition! !
!PPSqlGrammar categoriesFor: #command!commands!public! !
!PPSqlGrammar categoriesFor: #comparison!operators!public! !
!PPSqlGrammar categoriesFor: #condition!operators!public! !
!PPSqlGrammar categoriesFor: #createCommand!commands!public! !
!PPSqlGrammar categoriesFor: #deleteCommand!commands!public! !
!PPSqlGrammar categoriesFor: #expression!operators!public! !
!PPSqlGrammar categoriesFor: #identifier!public!tokens! !
!PPSqlGrammar categoriesFor: #insertCommand!commands!public! !
!PPSqlGrammar categoriesFor: #limitClause!clauses!public! !
!PPSqlGrammar categoriesFor: #logic!public!tokens! !
!PPSqlGrammar categoriesFor: #number!public!tokens! !
!PPSqlGrammar categoriesFor: #operator!public!tokens! !
!PPSqlGrammar categoriesFor: #selectCommand!commands!public! !
!PPSqlGrammar categoriesFor: #sequence!public!tokens! !
!PPSqlGrammar categoriesFor: #start!accessing!public! !
!PPSqlGrammar categoriesFor: #string!public!tokens! !
!PPSqlGrammar categoriesFor: #updateCommand!commands!public! !
!PPSqlGrammar categoriesFor: #whereClause!clauses!public! !

