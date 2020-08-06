"Filed out from Dolphin Smalltalk 7"!

PPCompositeParserTest subclass: #PPLambdaParserTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPLambdaParserTest guid: (GUID fromString: '{f1b0eef7-34bc-4335-80b2-422a9f9b6c9f}')!
PPLambdaParserTest comment: ''!
!PPLambdaParserTest categoriesForClass!Unclassified! !
!PPLambdaParserTest methodsFor!

parserClass
	^ PPLambdaParser!

testAbstraction
	self assert: '\x.y' is: #('x' 'y').
	self assert: '\x.\y.z' is: #('x' ('y' 'z'))!

testAnd
	self assert: self parserClass and = #('p' ('q' (('p' 'q') 'p')))!

testApplication
	self assert: '(x x)' is: #('x' 'x').
	self assert: '(x y)' is: #('x' 'y').
	self assert: '((x y) z)' is: #(('x' 'y') 'z').
	self assert: '(x (y z))' is: #('x' ('y' 'z'))!

testFalse
	self assert: self parserClass false = #('x' ('y' 'y'))!

testIfThenElse
	self assert: self parserClass ifthenelse = #('p' 'p')!

testNot
	self assert: self parserClass not = #('p' ('a' ('b' (('p' 'b') 'a'))))!

testOr
	self assert: self parserClass or = #('p' ('q' (('p' 'p') 'q')))!

testParseOnError
	| beenHere |
	result := self parserClass
		parse: '\x.y'
		onError: [ self fail ].
	self assert: result = #('x' 'y').

	beenHere := false.
	result := self parserClass
		parse: '\x.'
		onError: [ beenHere := true ].
	self assert: beenHere.

	beenHere := false.
	result := self parserClass
		parse: '\x.'
		onError: [ :fail | beenHere := true. fail ].
	self assert: beenHere.
	self assert: (result message findString: '$(') > 0.
	self assert: (result message findString: 'expected') > 0.
	self assert: (result position = 0).

	beenHere := false.
	result := self parserClass
		parse: '\x.'
		onError: [ :msg :pos | 
			self assert: (msg findString: '$(') > 0.
			self assert: (msg findString: 'expected') > 0.
			self assert: (pos = 0).
			beenHere := true ].
	self assert: result.
	self assert: beenHere!

testParseStartingAtOnError
	| beenHere |
	result := self parserClass
		parse: 'x'
		startingAt: #variable
		onError: [ self fail ].
	self assert: result = 'x'.
	
	beenHere := false.
	result := self parserClass
		parse: '\'
		startingAt: #variable
		onError: [ beenHere := true ].
	self assert: beenHere.
	
	beenHere := false.
	result := self parserClass
		parse: '\'
		startingAt: #variable
		onError: [ :fail | beenHere := true. fail ].
	self assert: beenHere.
	self assert: result message = 'letter expected'.
	self assert: result position = 0.

	beenHere := false.
	result := self parserClass
		parse: '\'
		startingAt: #variable
		onError: [ :msg :pos | 
			self assert: msg = 'letter expected'.
			self assert: pos = 0.
			beenHere := true ].
	self assert: beenHere!

testProductionAt
	self assert: (parser productionAt: #foo) isNil.
	self assert: (parser productionAt: #foo ifAbsent: [ true ]).
	
	self assert: (parser productionAt: #start) notNil.
	self assert: (parser productionAt: #start ifAbsent: [ true ]) notNil.
	
	self assert: (parser productionAt: #variable) notNil.
	self assert: (parser productionAt: #variable ifAbsent: [ true ]) notNil!

testTrue
	self assert: self parserClass true = #('x' ('y' 'x'))!

testVariable
	self assert: 'x' is: 'x'.
	self assert: 'xy' is: 'xy'.
	self assert: 'x12' is: 'x12'! !
!PPLambdaParserTest categoriesFor: #parserClass!accessing!public! !
!PPLambdaParserTest categoriesFor: #testAbstraction!public!testing! !
!PPLambdaParserTest categoriesFor: #testAnd!public!testing-curch! !
!PPLambdaParserTest categoriesFor: #testApplication!public!testing! !
!PPLambdaParserTest categoriesFor: #testFalse!public!testing-curch! !
!PPLambdaParserTest categoriesFor: #testIfThenElse!public!testing-curch! !
!PPLambdaParserTest categoriesFor: #testNot!public!testing-curch! !
!PPLambdaParserTest categoriesFor: #testOr!public!testing-curch! !
!PPLambdaParserTest categoriesFor: #testParseOnError!public!testing-utilities! !
!PPLambdaParserTest categoriesFor: #testParseStartingAtOnError!public!testing-utilities! !
!PPLambdaParserTest categoriesFor: #testProductionAt!public!testing-utilities! !
!PPLambdaParserTest categoriesFor: #testTrue!public!testing-curch! !
!PPLambdaParserTest categoriesFor: #testVariable!public!testing! !

