"Filed out from Dolphin Smalltalk 7"!

PPAbstractParserTest subclass: #PPScriptingTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPScriptingTest guid: (GUID fromString: '{517886e6-5709-4995-bd31-b52e702bd486}')!
PPScriptingTest comment: ''!
!PPScriptingTest categoriesForClass!Unclassified! !
!PPScriptingTest methodsFor!

expressionInterpreter
	"Same as #expressionInterpreter but with semantic actions."
	
	| mul prim add dec |
	add := PPUnresolvedParser new.
	mul := PPUnresolvedParser new.
	prim := PPUnresolvedParser new.
	dec := ($0 - $9) ==> [ :token | token codePoint - $0 codePoint ].
	add def: ((mul , $+ asParser , add) ==> [ :nodes | (nodes at: 1) + (nodes at: 3) ])
		/ mul.
	mul def: ((prim , $* asParser , mul) ==> [ :nodes | (nodes at: 1) * (nodes at: 3) ])
		/ prim.
	prim def: (($( asParser , add , $) asParser) ==> [ :nodes | nodes at: 2 ])
		/ dec.
	^ add end!

expressionParser
	"Simple demo of scripting an expression parser."
	
	| mul prim add dec |
	add := PPUnresolvedParser new.
	mul := PPUnresolvedParser new.
	prim := PPUnresolvedParser new.
	dec := ($0 - $9).
	add def: (mul , $+ asParser , add)
		/ mul.
	mul def: (prim , $* asParser , mul)
		/ prim.
	prim def: ($( asParser , add , $) asParser)
		/ dec.
	^ add end!

straightLineParser
	| goal stm stmList id char dec exp expList mulExp primExp nonzero num lower upper |
	goal := PPUnresolvedParser new.
	stmList := PPUnresolvedParser new.
	stm := PPUnresolvedParser new.
	exp := PPUnresolvedParser new.
	expList := PPUnresolvedParser new.
	mulExp := PPUnresolvedParser new.
	primExp := PPUnresolvedParser new.
	
	lower := $a - $z.
	upper := $A - $Z.
	char := lower / upper.
	nonzero := $1 - $9.
	dec := $0 - $9.
	id := char, ( char / dec ) star.
	num := $0 asParser / ( nonzero, dec star).

	goal def: stmList end.
	stmList def: stm , ( $; asParser, stm ) star.
	stm def: ( id, ':=' asParser, exp )
		/ ( 'print' asParser, $( asParser, expList, $) asParser ). 
	exp def: mulExp, ( ( $+ asParser / $- asParser ), mulExp ) star.
	expList def: exp, ( $, asParser, exp ) star.
	mulExp def: primExp, ( ( $* asParser / $/ asParser ), primExp ) star.
	primExp def: id
		/ num
		/ ( $( asParser, stmList, $, asParser, exp, $) asParser ).
	^ goal
!

testExpressionInterpreter
	self 
		assert: self expressionInterpreter
		parse: '2*(3+4)'
		to: 14!

testExpressionParser
	self
		assert: self expressionParser
		parse: '2*(3+4)'
		to: #($2 $* ($( ($3 $+ $4) $)))!

testSLassign
	
	self assert: self straightLineParser
		parse: 'abc:=1'
		to: #(#($a #($b $c) ':=' #(#(#($1 #()) #()) #())) #())!

testSLprint
	self 
		assert: self straightLineParser
		parse: 'print(3,4)'
		to: #(('print' $( ((($3 ()) ()) () (($, ((($4 ()) ()) ())))) $)) ())! !
!PPScriptingTest categoriesFor: #expressionInterpreter!examples!public! !
!PPScriptingTest categoriesFor: #expressionParser!examples!public! !
!PPScriptingTest categoriesFor: #straightLineParser!examples!public! !
!PPScriptingTest categoriesFor: #testExpressionInterpreter!public!tests! !
!PPScriptingTest categoriesFor: #testExpressionParser!public!tests! !
!PPScriptingTest categoriesFor: #testSLassign!public!tests! !
!PPScriptingTest categoriesFor: #testSLprint!public!tests! !

