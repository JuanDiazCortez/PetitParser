"Filed out from Dolphin Smalltalk 7"!

PPAbstractParserTest subclass: #PPObjectTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPObjectTest guid: (GUID fromString: '{f116ed8f-35c3-46d6-ae97-cf9557177640}')!
PPObjectTest comment: ''!
!PPObjectTest categoriesForClass!Unclassified! !
!PPObjectTest methodsFor!

integer
	^ PPPredicateObjectParser
		on: [ :each | each isInteger ]
		message: 'integer expected'!

string
	^ PPPredicateObjectParser
		on: [ :each | each isString ]
		message: 'string expected'!

testChoice
	| parser |
	parser := self integer / self string.
	self assert: parser parse: #(123) to: 123.
	self assert: parser parse: #('abc') to: 'abc'!

testFibonacci
	"This parser accepts fibonacci sequences with arbitrary start pairs."
	
	| parser |
	parser := ((self integer , self integer) end ==> [ :pair | pair first + pair last ])
		/ (self integer , (self integer , self integer) and >=> [ :stream :continuation |
			| result |
			result := continuation value.
			(result isPetitFailure or: [ result first + result last first ~= result last last ])
				ifFalse: [ parser parseOn: stream ]
				ifTrue: [ PPFailure message: 'invalid fibonacci sequence' at: stream position ] ]).
	self assert: parser parse: #(1 1) to: 2.
	self assert: parser parse: #(1 1 2) to: 3.
	self assert: parser parse: #(1 1 2 3) to: 5.
	self assert: parser parse: #(1 1 2 3 5) to: 8.
	self assert: parser parse: #(1 1 2 3 5 8) to: 13.
	self assert: parser parse: #(1 1 2 3 5 8 13) to: 21.
	self assert: parser fail: #().
	self assert: parser fail: #(1).
	self assert: parser fail: #(1 2 3 4) end: 2!

testInteger
	self assert: self integer parse: #(123) to: 123.
	self assert: self integer fail: #('abc')!

testSequence
	| parser |
	parser := self integer , self string.
	self assert: parser parse: #(123 'abc') to: #(123 'abc').
	self assert: parser fail: #(123 456).
	self assert: parser fail: #('abc' 'def').
	self assert: parser fail: #('abc' 123)!

testString
	self assert: self string parse: #('abc') to: 'abc'.
	self assert: self string fail: #(123)! !
!PPObjectTest categoriesFor: #integer!parsers!public! !
!PPObjectTest categoriesFor: #string!parsers!public! !
!PPObjectTest categoriesFor: #testChoice!public!testing-operators! !
!PPObjectTest categoriesFor: #testFibonacci!public!testing-fancy! !
!PPObjectTest categoriesFor: #testInteger!public!testing! !
!PPObjectTest categoriesFor: #testSequence!public!testing-operators! !
!PPObjectTest categoriesFor: #testString!public!testing! !

