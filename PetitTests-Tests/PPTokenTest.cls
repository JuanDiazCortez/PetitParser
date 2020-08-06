"Filed out from Dolphin Smalltalk 7"!

PPAbstractParserTest subclass: #PPTokenTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPTokenTest guid: (GUID fromString: '{0fff4729-5571-4052-81a8-ebb7c4e542bc}')!
PPTokenTest comment: 'Test PPToken'!
!PPTokenTest categoriesForClass!Unclassified! !
!PPTokenTest methodsFor!

identifier
	^ #word asParser plus token!

parse: aString using: aParser
	^ aParser parse: aString!

testCollection
	| input result |
	input := 'foo    '.
	result := self 
		parse: input
		using: self identifier.
	self assert: (result collection = input).
	self assert: (result collection == input)!

testColumn
	| input parser result |
	input := '1' , (String with: Character cr) , '12' , (String with: Character cr with: Character lf) , '123' , (String with: Character lf) , '1234'.
	parser := #any asParser token star.
	result := parser parse: input.
	result 
		with:  #(1 2 1 2 3 4 1 2 3 4 1 2 3 4)
		do: [ :token :line | self assert: token column = line ]!

testCopyFromTo
	| result other |
	result := PPToken on: 'abc'.
	other := result copyFrom: 2 to: 2.
	
	self assert: other size = 1.
	self assert: other start = 2.
	self assert: other stop = 2.
	self assert: other collection = result collection!

testEquality
	| token1 token2 |
	token1 := self  parse: 'foo' using: self identifier.
	token2 := self  parse: 'foo' using: self identifier.
	self deny: token1 == token2.
	self assert: token1 = token2.
	self assert: token1 hash = token2 hash.!

testInitialize
	PPToken initialize!

testInputValue
	| input result |
	input := 'foo'.
	result := self 
		parse: input
		using: self identifier.
	self assert: result inputValue = input.
	self deny: result inputValue == input!

testLine
	| input parser result |
	input := '1' , (String with: Character cr) , '12' , (String with: Character cr with: Character lf) , '123' , (String with: Character lf) , '1234'.
	parser := #any asParser token star.
	result := parser parse: input.
	result 
		with: #(1 1 2 2 2 2 3 3 3 3 4 4 4 4) 
		do: [ :token :line | self assert: token line = line ]!

testNew
	self should: [ PPToken new ] raise: Error.!

testParsedValue
	| input result |
	input := 'foo'.
	result := self 
		parse: input
		using: self identifier.
	self assert: result parsedValue = #($f $o $o)!

testPrinting
	| result |
	result := PPToken on: 'var'.
	self assert: (result printString findString: 'PPToken[1,3]') > 0!

testSize
	| result |
	result := self 
		parse: 'foo'
		using: self identifier.
	self assert: result size = 3!

testStart
	| result |
	result := self 
		parse: 'foo'
		using: self identifier.
	self assert: result start = 1!

testStop
	| result |
	result := self 
		parse: 'foo'
		using: self identifier.
	self assert: result stop = 3!

testValue
	| result |
	result := PPToken on: 'var'.
	self should: [ result value ] raise: Exception! !
!PPTokenTest categoriesFor: #identifier!accessing!public! !
!PPTokenTest categoriesFor: #parse:using:!public!utilities! !
!PPTokenTest categoriesFor: #testCollection!public!testing! !
!PPTokenTest categoriesFor: #testColumn!public!testing-querying! !
!PPTokenTest categoriesFor: #testCopyFromTo!public!testing-copying! !
!PPTokenTest categoriesFor: #testEquality!public!testing-comparing! !
!PPTokenTest categoriesFor: #testInitialize!public!testing! !
!PPTokenTest categoriesFor: #testInputValue!public!testing-values! !
!PPTokenTest categoriesFor: #testLine!public!testing-querying! !
!PPTokenTest categoriesFor: #testNew!public!testing! !
!PPTokenTest categoriesFor: #testParsedValue!public!testing-values! !
!PPTokenTest categoriesFor: #testPrinting!public!testing! !
!PPTokenTest categoriesFor: #testSize!public!testing! !
!PPTokenTest categoriesFor: #testStart!public!testing! !
!PPTokenTest categoriesFor: #testStop!public!testing! !
!PPTokenTest categoriesFor: #testValue!public!testing! !

