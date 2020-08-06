"Filed out from Dolphin Smalltalk 7"!

PPArithmeticParserTest subclass: #PPExpressionParserTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPExpressionParserTest guid: (GUID fromString: '{3087bebc-9493-43e7-9b55-21b83604ea41}')!
PPExpressionParserTest comment: ''!
!PPExpressionParserTest categoriesForClass!Unclassified! !
!PPExpressionParserTest methodsFor!

parserInstance
	| expression parens number |
	expression := PPExpressionParser new.
	parens := $( asParser trim , expression , $) asParser trim
		==> [ :value | value second ].
	number := (#digit asParser plus , ($. asParser , #digit asParser plus) optional) flatten trim
		==> [ :value | value asNumber ].
	expression term: parens / number.
	expression
		group: [ :g |
			g prefix: $- asParser trim do: [ :op :a | a negated ] ];
		group: [ :g |
			g postfix: '++' asParser trim do: [ :a :op | a + 1 ].
			g postfix: '--' asParser trim do: [ :a :op | a - 1 ] ];
		group: [ :g |
			g right: $^ asParser trim do: [ :a :op :b | a raisedTo: b ] ];
		group: [ :g |
			g left: $* asParser trim do: [ :a :op :b | a * b ].
			g left: $/ asParser trim do: [ :a :op :b | a / b ] ];
		group: [ :g |
			g left: $+ asParser trim do: [ :a :op :b | a + b ].
			g left: $- asParser trim do: [ :a :op :b | a - b ] ].
	^ expression end!

testPostfixAdd
	self assert: '0++' is: 1.
	self assert: '0++++' is: 2.
	self assert: '0++++++' is: 3.

	self assert: '0+++1' is: 2.
	self assert: '0+++++1' is: 3.
	self assert: '0+++++++1' is: 4!

testPostfixSub
	self assert: '1--' is: 0.
	self assert: '2----' is: 0.
	self assert: '3------' is: 0.

	self assert: '2---1' is: 0.
	self assert: '3-----1' is: 0.
	self assert: '4-------1' is: 0.!

testPrefixNegate
	self assert: '1' is: 1.
	self assert: '-1' is: -1.
	self assert: '--1' is: 1.
	self assert: '---1' is: -1! !
!PPExpressionParserTest categoriesFor: #parserInstance!accessing!public! !
!PPExpressionParserTest categoriesFor: #testPostfixAdd!public!testing! !
!PPExpressionParserTest categoriesFor: #testPostfixSub!public!testing! !
!PPExpressionParserTest categoriesFor: #testPrefixNegate!public!testing! !

!PPExpressionParserTest class methodsFor!

shouldInheritSelectors
	^ true! !
!PPExpressionParserTest class categoriesFor: #shouldInheritSelectors!public!testing! !

