"Filed out from Dolphin Smalltalk 7"!

PPAbstractParserTest subclass: #PPParserTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPParserTest guid: (GUID fromString: '{732d1605-6cd0-411d-aad9-084a529e874f}')!
PPParserTest comment: ''!
!PPParserTest categoriesForClass!Unclassified! !
!PPParserTest methodsFor!

testAction
	| block parser |
	block := [ :char | char asUppercase ].
	parser := #any asParser ==> block.
	self assert: parser block = block.

	self assert: parser parse: 'a' to: $A.
	self assert: parser parse: 'b' to: $B!

testAnd
	| parser |
	parser := 'foo' asParser flatten , 'bar' asParser flatten and.
	
	self assert: parser parse: 'foobar' to: #('foo' 'bar') end: 3.
	self assert: parser fail: 'foobaz'.
	
	parser := 'foo' asParser and.
	self assert: parser and = parser!

testAnswer
	| parser |
	parser := $a asParser answer: $b.
	
	self assert: parser parse: 'a' to: $b.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'!

testBlock
	| parser |
	parser := [ :s | s next ] asParser.
	
	self assert: parser parse: 'ab' to: $a end: 1.
	self assert: parser parse: 'b' to: $b.
	"self assert: parser parse: '' to: nil"!

testChildren
	| p1 p2 p3 |
	p1 := #lowercase asParser.
	p2 := p1 ==> #asUppercase.
	p3 := PPUnresolvedParser new.
	p3 def: p2 / p3.
	self assert: p1 children isEmpty.
	self assert: p2 children size = 1.
	self assert: p3 children size = 2!

testChoice
	| parser |
	parser := $a asParser / $b asParser.
	
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'b' to: $b.

	self assert: parser parse: 'ab' to: $a end: 1.
	self assert: parser parse: 'ba' to: $b end: 1.

	self assert: parser fail: ''.
	self assert: parser fail: 'c'.
	self assert: parser fail: 'ca'!

testDelimitedBy
	| parser |
	parser := $a asParser delimitedBy: $b asParser.
	
	self assert: parser parse: 'a' to: #($a).
	self assert: parser parse: 'aba' to: #($a $b $a).
	self assert: parser parse: 'ababa' to: #($a $b $a $b $a).

	self assert: parser parse: 'ab' to: #($a $b).
	self assert: parser parse: 'abab' to: #($a $b $a $b).
	self assert: parser parse: 'ababab' to: #($a $b $a $b $a $b).
	
	self assert: parser parse: 'ac' to: #($a) end: 1.
	self assert: parser parse: 'abc' to: #($a $b) end: 2.
	self assert: parser parse: 'abac' to: #($a $b $a) end: 3.
	self assert: parser parse: 'ababc' to: #($a $b $a $b) end: 4.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'c'!

testDelimitedByWithoutSeparators
	| parser |
	parser := ($a asParser delimitedBy: $b asParser)
		withoutSeparators.
	
	self assert: parser parse: 'a' to: #($a).
	self assert: parser parse: 'aba' to: #($a $a).
	self assert: parser parse: 'ababa' to: #($a $a $a).

	self assert: parser parse: 'ab' to: #($a).
	self assert: parser parse: 'abab' to: #($a $a).
	self assert: parser parse: 'ababab' to: #($a $a $a).
	
	self assert: parser parse: 'ac' to: #($a) end: 1.
	self assert: parser parse: 'abc' to: #($a) end: 2.
	self assert: parser parse: 'abac' to: #($a $a) end: 3.
	self assert: parser parse: 'ababc' to: #($a $a) end: 4.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'c'!

testEndOfInput
	| parser |
	parser := PPEndOfInputParser on: $a asParser.
	self assert: parser end = parser.
	
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: ''.
	self assert: parser fail: 'aa'!

testEndOfInputAfterMatch
	| parser |
	parser := 'stuff' asParser end.
	self assert: parser parse: 'stuff' to: 'stuff'.
	self assert: parser fail: 'stufff'.
	self assert: parser fail: 'fluff'!

testEpsilon
	| parser |
	parser := nil asParser.
	
	self assert: parser parse: '' to: nil.
	
	self assert: parser parse: 'a' to: nil end: 0.
	self assert: parser parse: 'ab' to: nil end: 0!

testFailing
	| parser result |
	parser := PPFailingParser message: 'Plonk'.
	self assert: parser message = 'Plonk'.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'aa'.
	
	result := parser parse: 'a'.
	self assert: result message = 'Plonk'.
	self assert: result printString = 'Plonk at 0'!

testFailure
	| failure |
	failure := PPFailure message: 'Error' at: 3.
	
	self assert: failure message = 'Error'.
	self assert: failure position = 3.
	self assert: failure isPetitFailure.

	self deny: 4 isPetitFailure.
	self deny: 'foo' isPetitFailure!

testFlatten
	| parser |
	parser := $a asParser flatten.
	
	self assert: parser parse: 'a' to: 'a'.
	self assert: parser parse: #($a) to: #($a).
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'!

testFoldLeft2
	| parser |
	parser := #any asParser star 
		foldLeft: [ :a :b | Array with: a with: b ].

	self assert: parser parse: #(a) to: #a.
	self assert: parser parse: #(a b) to: #(a b).
	self assert: parser parse: #(a b c) to: #((a b) c).
	self assert: parser parse: #(a b c d) to: #(((a b) c) d).
	self assert: parser parse: #(a b c d e) to: #((((a b) c) d) e)!

testFoldLeft3
	| parser |
	parser := #any asParser star 
		foldLeft: [ :a :b :c | Array with: a with: b with: c ].

	self assert: parser parse: #(a) to: #a.
	self assert: parser parse: #(a b c) to: #(a b c).
	self assert: parser parse: #(a b c d e) to: #((a b c) d e)!

testFoldRight2
	| parser |
	parser := #any asParser star 
		foldRight: [ :a :b | Array with: a with: b ].

	self assert: parser parse: #(a) to: #a.
	self assert: parser parse: #(a b) to: #(a b).
	self assert: parser parse: #(a b c) to: #(a (b c)).
	self assert: parser parse: #(a b c d) to: #(a (b (c d))).
	self assert: parser parse: #(a b c d e) to: #(a (b (c (d e))))!

testFoldRight3
	| parser |
	parser := #any asParser star 
		foldRight: [ :a :b :c | Array with: a with: b with: c ].

	self assert: parser parse: #(a) to: #a.
	self assert: parser parse: #(a b c) to: #(a b c).
	self assert: parser parse: #(a b c d e) to: #(a b (c d e))!

testHasProperty
	| parser |
	parser := PPParser new.
	self deny: (parser hasProperty: #foo).
	parser propertyAt: #foo put: 123.
	self assert: (parser hasProperty: #foo)!

testListConstructor
	| p1 p2 p3 |
	p1 := PPChoiceParser with: $a asParser.
	p2 := PPChoiceParser with: $a asParser with: $b asParser.
	p3 := PPChoiceParser withAll: (Array with: $a asParser with: $b asParser with: $c asParser).
	
	self assert: p1 children size = 1.
	self assert: p2 children size = 2.
	self assert: p3 children size = 3!

testLiteralObject
	| parser |
	parser := PPLiteralObjectParser 
		on: $a
		message: 'letter "a" expected'.
	self assert: parser literal = $a.
	self assert: parser message = 'letter "a" expected'.
	
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: 'b'!

testLiteralObjectCaseInsensitive
	| parser |
	parser := $a asParser caseInsensitive.
	
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'A' to: $A.

	self assert: parser fail: ''.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'B'!

testLiteralSequence
	| parser |
	parser := PPLiteralSequenceParser 
		on: 'abc'
		message: 'sequence "abc" expected'.
	self assert: parser size = 3.
	self assert: parser literal = 'abc'.
	self assert: parser message = 'sequence "abc" expected'.
	
	self assert: parser parse: 'abc' to: 'abc'.
	self assert: parser fail: 'ab'.
	self assert: parser fail: 'abd'!

testLiteralSequenceCaseInsensitive
	| parser |
	parser := 'abc' asParser caseInsensitive.
	
	self assert: parser parse: 'abc' to: 'abc'.
	self assert: parser parse: 'ABC' to: 'ABC'.
	self assert: parser parse: 'abC' to: 'abC'.
	self assert: parser parse: 'AbC' to: 'AbC'.
	
	self assert: parser fail: 'ab'.
	self assert: parser fail: 'abd'!

testMap1
	| parser |
	parser := #any asParser 
		map: [ :a | Array with: a ].

	self assert: parser parse: #(a) to: #(a)!

testMap2
	| parser |
	parser := (#any asParser , #any asParser) 
		map: [ :a :b | Array with: b with: a ].

	self assert: parser parse: #(a b) to: #(b a)!

testMap3
	| parser |
	parser := (#any asParser , #any asParser , #any asParser)
		map: [ :a :b :c | Array with: c with: b with: a ].

	self assert: parser parse: #(a b c) to: #(c b a)!

testMapFail1
	self
		should: [ #any asParser map: [  ] ]
		raise: Error.
	self
		should: [ #any asParser map: [ :a :b | ] ]
		raise: Error!

testMapFail2
	self
		should: [ (#any asParser , #any asParser) map: [ :a | ] ]
		raise: Error.
	self
		should: [ (#any asParser , #any asParser) map: [ :a :b :c | ] ]
		raise: Error!

testMatches
	| parser |
	parser := $a asParser.
	
	self assert: (parser matches: 'a').
	self deny: (parser matches: 'b').
	
	self assert: (parser matches: 'a' readStream).
	self deny: (parser matches: 'b' readStream)!

testMatchesIn
	| parser result |
	parser := $a asParser.
	
	result := parser matchesIn: 'abba'.
	self assert: result size = 2.
	self assert: result first = $a.
	self assert: result last = $a.
	
	result := parser matchesIn: 'baaah'.
	self assert: result size = 3.
	self assert: result first = $a.
	self assert: result last = $a!

testMatchesInEmpty
	"Empty matches should properly advance and match at each position and at the end."

	| parser result |
	parser := [ :stream | stream position ] asParser.
	
	result := parser matchesIn: '123'.
	self assert: result asArray = #(0 1 2 3)!

testMatchesInOverlapping
	"Matches that overlap should be properly reported."

	| parser result |
	parser := #digit asParser , #digit asParser.
	
	result := parser matchesIn: 'a123b'.
	self assert: result size = 2.
	self assert: result first = #($1 $2).
	self assert: result last = #($2 $3)!

testMatchesSkipIn
	| parser result |
	parser := $a asParser.
	
	result := parser matchesSkipIn: 'abba'.
	self assert: result size = 2.
	self assert: result first = $a.
	self assert: result last = $a.
	
	result := parser matchesSkipIn: 'baaah'.
	self assert: result size = 3.
	self assert: result first = $a.
	self assert: result last = $a!

testMatchesSkipInOverlapping
	"Matches that overlap should be properly reported."

	| parser result |
	parser := #digit asParser , #digit asParser.
	
	result := parser matchesSkipIn: 'a123b'.
	self assert: result size = 1.
	self assert: result first = #($1 $2)!

testMatchingRangesIn
	| input parser result |
	input := 'a12b3'.
	parser := #digit asParser plus.
	result := parser matchingRangesIn: input.
	result := result collect: [ :each | input copyFrom: each first to: each last ].
	self assert: result size = 3.
	self assert: result first = '12'.
	self assert: result second = '2'.
	self assert: result last = '3'!

testMatchingSkipRangesIn
	| input parser result |
	input := 'a12b3'.
	parser := #digit asParser plus.
	result := parser matchingSkipRangesIn: input.
	result := result collect: [ :each | input copyFrom: each first to: each last ].
	self assert: result size = 2.
	self assert: result first = '12'.
	self assert: result last = '3'!

testMax
	| parser |
	parser := $a asParser max: 2.
	self assert: parser min = 0.
	self assert: parser max = 2.

	self assert: parser parse: '' to: #().
	self assert: parser parse: 'a' to: #($a).
	self assert: parser parse: 'aa' to: #($a $a).
	self assert: parser parse: 'aaa' to: #($a $a) end: 2.
	self assert: parser parse: 'aaaa' to: #($a $a) end: 2.
	
	self assert: (parser printString endsWith: '[0, 2]')!

testMaxGreedy
	| parser |
	parser := #word asParser max: 2 greedy: #digit asParser.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'abc'.
	
	self assert: parser parse: '1' to: #() end: 0.
	self assert: parser parse: 'a1' to: #($a) end: 1.
	self assert: parser parse: 'ab1' to: #($a $b) end: 2.
	self assert: parser fail: 'abc1'.
	
	self assert: parser parse: '12' to: #($1) end: 1.
	self assert: parser parse: 'a12' to: #($a $1) end: 2.
	self assert: parser parse: 'ab12' to: #($a $b) end: 2.
	self assert: parser fail: 'abc12'.
	
	self assert: parser parse: '123' to: #($1 $2) end: 2.
	self assert: parser parse: 'a123' to: #($a $1) end: 2.
	self assert: parser parse: 'ab123' to: #($a $b) end: 2.
	self assert: parser fail: 'abc123'!

testMaxLazy
	| parser |
	parser := #word asParser max: 2 lazy: #digit asParser.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'abc'.
	
	self assert: parser parse: '1' to: #() end: 0.
	self assert: parser parse: 'a1' to: #($a) end: 1.
	self assert: parser parse: 'ab1' to: #($a $b) end: 2.
	self assert: parser fail: 'abc1'.
	
	self assert: parser parse: '12' to: #() end: 0.
	self assert: parser parse: 'a12' to: #($a) end: 1.
	self assert: parser parse: 'ab12' to: #($a $b) end: 2.
	self assert: parser fail: 'abc12'.
	
	self assert: parser parse: '123' to: #() end: 0.
	self assert: parser parse: 'a123' to: #($a) end: 1.
	self assert: parser parse: 'ab123' to: #($a $b) end: 2.
	self assert: parser fail: 'abc123'!

testMemoized
	| count parser twice |
	count := 0.
	parser := [ :s | count := count + 1. s next ] asParser memoized.
	twice := parser and , parser.
	
	count := 0.
	self assert: parser parse: 'a' to: $a.
	self assert: count = 1.

	count := 0.
	self assert: twice parse: 'a' to: #($a $a).
	self assert: count = 1.
	
	self assert: parser memoized = parser!

testMin
	| parser |
	parser := $a asParser min: 2.
	self assert: parser min = 2.
	self assert: parser max > parser min.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser parse: 'aa' to: #($a $a).
	self assert: parser parse: 'aaa' to: #($a $a $a).
	self assert: parser parse: 'aaaa' to: #($a $a $a $a).
	
	self assert: (parser printString endsWith: '[2, *]')!

testMinGreedy
	| parser |
	parser := #word asParser min: 2 greedy: #digit asParser.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'abcde'.
	
	self assert: parser fail: '1'.
	self assert: parser fail: 'a1'.
	self assert: parser parse: 'ab1' to: #($a $b) end: 2.
	self assert: parser parse: 'abc1' to: #($a $b $c) end: 3.
	self assert: parser parse: 'abcd1' to: #($a $b $c $d) end: 4.
	self assert: parser parse: 'abcde1' to: #($a $b $c $d $e) end: 5.
	
	self assert: parser fail: '12'.
	self assert: parser parse: 'a12' to: #($a $1) end: 2.
	self assert: parser parse: 'ab12' to: #($a $b $1) end: 3.
	self assert: parser parse: 'abc12' to: #($a $b $c $1) end: 4.
	self assert: parser parse: 'abcd12' to: #($a $b $c $d $1) end: 5.
	self assert: parser parse: 'abcde12' to: #($a $b $c $d $e $1) end: 6.
	
	self assert: parser parse: '123' to: #($1 $2) end: 2.
	self assert: parser parse: 'a123' to: #($a $1 $2) end: 3.
	self assert: parser parse: 'ab123' to: #($a $b $1 $2) end: 4.
	self assert: parser parse: 'abc123' to: #($a $b $c $1 $2) end: 5.
	self assert: parser parse: 'abcd123' to: #($a $b $c $d $1 $2) end: 6.
	self assert: parser parse: 'abcde123' to: #($a $b $c $d $e $1 $2) end: 7.
	
	self assert: parser parse: '1234' to: #($1 $2 $3) end: 3.
	self assert: parser parse: 'a1234' to: #($a $1 $2 $3) end: 4.
	self assert: parser parse: 'ab1234' to: #($a $b $1 $2 $3) end: 5.
	self assert: parser parse: 'abc1234' to: #($a $b $c $1 $2 $3) end: 6.
	self assert: parser parse: 'abcd1234' to: #($a $b $c $d $1 $2 $3) end: 7.
	self assert: parser parse: 'abcde1234' to: #($a $b $c $d $e $1 $2 $3) end: 8!

testMinLazy
	| parser |
	parser := #word asParser min: 2 lazy: #digit asParser.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'abcde'.
	
	self assert: parser fail: '1'.
	self assert: parser fail: 'a1'.
	self assert: parser parse: 'ab1' to: #($a $b) end: 2.
	self assert: parser parse: 'abc1' to: #($a $b $c) end: 3.
	self assert: parser parse: 'abcd1' to: #($a $b $c $d) end: 4.
	self assert: parser parse: 'abcde1' to: #($a $b $c $d $e) end: 5.
	
	self assert: parser fail: '12'.
	self assert: parser parse: 'a12' to: #($a $1) end: 2.
	self assert: parser parse: 'ab12' to: #($a $b) end: 2.
	self assert: parser parse: 'abc12' to: #($a $b $c) end: 3.
	self assert: parser parse: 'abcd12' to: #($a $b $c $d) end: 4.
	self assert: parser parse: 'abcde12' to: #($a $b $c $d $e) end: 5.
	
	self assert: parser parse: '123' to: #($1 $2) end: 2.
	self assert: parser parse: 'a123' to: #($a $1) end: 2.
	self assert: parser parse: 'ab123' to: #($a $b) end: 2.
	self assert: parser parse: 'abc123' to: #($a $b $c) end: 3.
	self assert: parser parse: 'abcd123' to: #($a $b $c $d) end: 4.
	self assert: parser parse: 'abcde123' to: #($a $b $c $d $e) end: 5.
	
	self assert: parser parse: '1234' to: #($1 $2) end: 2.
	self assert: parser parse: 'a1234' to: #($a $1) end: 2.
	self assert: parser parse: 'ab1234' to: #($a $b) end: 2.
	self assert: parser parse: 'abc1234' to: #($a $b $c) end: 3.
	self assert: parser parse: 'abcd1234' to: #($a $b $c $d) end: 4.
	self assert: parser parse: 'abcde1234' to: #($a $b $c $d $e) end: 5!

testMinMax
	| parser |
	parser := $a asParser min: 2 max: 4.
	self assert: parser min = 2.
	self assert: parser max = 4.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser parse: 'aa' to: #($a $a).
	self assert: parser parse: 'aaa' to: #($a $a $a).
	self assert: parser parse: 'aaaa' to: #($a $a $a $a).
	self assert: parser parse: 'aaaaa' to: #($a $a $a $a) end: 4.
	self assert: parser parse: 'aaaaaa' to: #($a $a $a $a) end: 4.
	
	self assert: (parser printString endsWith: '[2, 4]')!

testMinMaxGreedy
	| parser |
	parser := #word asParser min: 2 max: 4 greedy: #digit asParser.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'abcde'.
	
	self assert: parser fail: '1'.
	self assert: parser fail: 'a1'.
	self assert: parser parse: 'ab1' to: #($a $b) end: 2.
	self assert: parser parse: 'abc1' to: #($a $b $c) end: 3.
	self assert: parser parse: 'abcd1' to: #($a $b $c $d) end: 4.
	self assert: parser fail: 'abcde1'.
	
	self assert: parser fail: '12'.
	self assert: parser parse: 'a12' to: #($a $1) end: 2.
	self assert: parser parse: 'ab12' to: #($a $b $1) end: 3.
	self assert: parser parse: 'abc12' to: #($a $b $c $1) end: 4.
	self assert: parser parse: 'abcd12' to: #($a $b $c $d) end: 4.
	self assert: parser fail: 'abcde12'.
	
	self assert: parser parse: '123' to: #($1 $2) end: 2.
	self assert: parser parse: 'a123' to: #($a $1 $2) end: 3.
	self assert: parser parse: 'ab123' to: #($a $b $1 $2) end: 4.
	self assert: parser parse: 'abc123' to: #($a $b $c $1) end: 4.
	self assert: parser parse: 'abcd123' to: #($a $b $c $d) end: 4.
	self assert: parser fail: 'abcde123'.
	
	self assert: parser parse: '1234' to: #($1 $2 $3) end: 3.
	self assert: parser parse: 'a1234' to: #($a $1 $2 $3) end: 4.
	self assert: parser parse: 'ab1234' to: #($a $b $1 $2) end: 4.
	self assert: parser parse: 'abc1234' to: #($a $b $c $1) end: 4.
	self assert: parser parse: 'abcd1234' to: #($a $b $c $d) end: 4.
	self assert: parser fail: 'abcde1234'!

testMinMaxLazy
	| parser |
	parser := #word asParser min: 2 max: 4 lazy: #digit asParser.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'abcde'.
	
	self assert: parser fail: '1'.
	self assert: parser fail: 'a1'.
	self assert: parser parse: 'ab1' to: #($a $b) end: 2.
	self assert: parser parse: 'abc1' to: #($a $b $c) end: 3.
	self assert: parser parse: 'abcd1' to: #($a $b $c $d) end: 4.
	self assert: parser fail: 'abcde1'.
	
	self assert: parser fail: '12'.
	self assert: parser parse: 'a12' to: #($a $1) end: 2.
	self assert: parser parse: 'ab12' to: #($a $b) end: 2.
	self assert: parser parse: 'abc12' to: #($a $b $c) end: 3.
	self assert: parser parse: 'abcd12' to: #($a $b $c $d) end: 4.
	self assert: parser fail: 'abcde12'.
	
	self assert: parser parse: '123' to: #($1 $2) end: 2.
	self assert: parser parse: 'a123' to: #($a $1) end: 2.
	self assert: parser parse: 'ab123' to: #($a $b) end: 2.
	self assert: parser parse: 'abc123' to: #($a $b $c) end: 3.
	self assert: parser parse: 'abcd123' to: #($a $b $c $d) end: 4.
	self assert: parser fail: 'abcde123'.
	
	self assert: parser parse: '1234' to: #($1 $2) end: 2.
	self assert: parser parse: 'a1234' to: #($a $1) end: 2.
	self assert: parser parse: 'ab1234' to: #($a $b) end: 2.
	self assert: parser parse: 'abc1234' to: #($a $b $c) end: 3.
	self assert: parser parse: 'abcd1234' to: #($a $b $c $d) end: 4.
	self assert: parser fail: 'abcde1234'!

testNamed
	| parser |
	parser := PPSequenceParser new.
	self assert: parser name isNil.
	
	parser := PPChoiceParser named: 'choice'.
	self assert: parser name = 'choice'.
	
	parser := $* asParser name: 'star'.
	self assert: parser name = 'star'!

testNegate
	| parser |
	parser := 'foo' asParser negate.
	
	self assert: parser parse: 'f' to: $f end: 1.
	self assert: parser parse: 'fo' to: $f end: 1.
	self assert: parser parse: 'fob' to: $f end: 1.
	self assert: parser parse: 'ffoo' to: $f end: 1.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'foo'!

testNot
	| parser |
	parser := 'foo' asParser flatten , 'bar' asParser flatten not.
	
	self assert: parser parse: 'foobaz' to: #('foo' nil) end: 3.
	self assert: parser fail: 'foobar'!

testOptional
	| parser |
	parser := $a asParser optional.
	
	self assert: parser parse: '' to: nil.
	self assert: parser parse: 'a' to: $a.
	
	self assert: parser parse: 'aa' to: $a end: 1.
	self assert: parser parse: 'ab' to: $a end: 1.
	self assert: parser parse: 'b' to: nil end: 0.
	self assert: parser parse: 'bb' to: nil end: 0.
	self assert: parser parse: 'ba' to: nil end: 0!

testParse
	| parser result |
	parser := $a asParser.
	
	self assert: (parser parse: 'a') = $a.
	self assert: (result := parser parse: 'b') isPetitFailure.
	self assert: (result message findString: '$a') > 0.
	self assert: (result message findString: 'expected') > 0.
	self assert: (result position = 0).
	
	self assert: (parser parse: 'a' readStream) = $a.
	self assert: (result := parser parse: 'b' readStream) isPetitFailure.
	self assert: (result message findString: '$a') > 0.
	self assert: (result message findString: 'expected') > 0.
	self assert: (result position = 0)!

testParseOnError0
	| parser result seen |
	parser := $a asParser.

	result := parser parse: 'a' onError: [ self signalFailure: 'Not supposed to report an error' ].
	self assert: result = $a.

	result := parser parse: 'b' onError: [ seen := true ].
	self assert: result.
	self assert: seen!

testParseOnError1
	| parser result seen |
	parser := $a asParser.

	result := parser parse: 'a' onError: [ self signalFailure: 'Not supposed to report an error' ].
	self assert: result = $a.
	
	result := parser parse: 'b' onError: [ :failure | 
		self assert: (failure position = 0).
		self assert: (failure message findString: '$a') > 0.
		self assert: (failure message findString: 'expected') > 0.
		seen := true ].
	self assert: result.
	self assert: seen!

testParseOnError2
	| parser result seen |
	parser := $a asParser.
	
	result := parser parse: 'a' onError: [ self signalFailure: 'Not supposed to report an error' ].
	self assert: result = $a.

	result := parser parse: 'b' onError: [ :msg :pos | 
		self assert: (msg findString: '$a') > 0.
		self assert: (msg findString: 'expected') > 0.
		self assert: pos = 0.
		seen := true ].
	self assert: result.
	self assert: seen!

testParser
	| parser |
	parser := PPParser new.
	
	self assert: parser isPetitParser.

	self deny: 4 isPetitParser.
	self deny: 'foo' isPetitParser!

testPermutation
	| parser |
	parser := #any asParser , #any asParser , #any asParser.

	self assert: (parser permutation: #()) parse: '123' to: #().
	self assert: (parser permutation: #(1)) parse: '123' to: #($1).
	self assert: (parser permutation: #(1 3)) parse: '123' to: #($1 $3).
	self assert: (parser permutation: #(3 1)) parse: '123' to: #($3 $1).
	self assert: (parser permutation: #(2 2)) parse: '123' to: #($2 $2).
	self assert: (parser permutation: #(3 2 1)) parse: '123' to: #($3 $2 $1).
	
	self should: [ parser permutation: #(0) ] raise: Error.
	self should: [ parser permutation: #(4) ] raise: Error.
	self should: [ parser permutation: #($2) ] raise: Error!

testPluggable
	| block parser |
	block := [ :stream | stream position ].
	parser := block asParser.
	self assert: parser block = block!

testPlus
	| parser |
	parser := $a asParser plus.
	
	self assert: parser min = 1.
	self assert: parser max > parser min.
	
	self assert: parser parse: 'a' to: #($a).
	self assert: parser parse: 'aa' to: #($a $a).
	self assert: parser parse: 'aaa' to: #($a $a $a).
	
	self assert: parser parse: 'ab' to: #($a) end: 1.
	self assert: parser parse: 'aab' to: #($a $a) end: 2.
	self assert: parser parse: 'aaab' to: #($a $a $a) end: 3.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'ba'!

testPlusGreedy
	| limit parser |
	limit := #digit asParser.
	parser := #word asParser plusGreedy: limit.
	
	self assert: parser min = 1.
	self assert: parser max > parser min.	
	self assert: parser limit = limit.
	self assert: parser children size = 2.
	self assert: parser children last = limit.

	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'ab'.

	self assert: parser parse: 'a1' to: #($a) end: 1.
	self assert: parser parse: 'ab1' to: #($a $b) end: 2.
	self assert: parser parse: 'abc1' to: #($a $b $c) end: 3.
	self assert: parser parse: 'a12' to: #($a $1) end: 2.
	self assert: parser parse: 'ab12' to: #($a $b $1) end: 3.
	self assert: parser parse: 'abc12' to: #($a $b $c $1) end: 4.
	self assert: parser parse: 'a123' to: #($a $1 $2) end: 3.
	self assert: parser parse: 'ab123' to: #($a $b $1 $2) end: 4.
	self assert: parser parse: 'abc123' to: #($a $b $c $1 $2) end: 5.!

testPlusLazy
	| limit parser |
	limit := #digit asParser.
	parser := #word asParser plusLazy: limit.
	
	self assert: parser min = 1.
	self assert: parser max > parser min.	
	self assert: parser limit = limit.
	self assert: parser children size = 2.
	self assert: parser children last = limit.

	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'ab'.

	self assert: parser parse: 'a1' to: #($a) end: 1.
	self assert: parser parse: 'ab1' to: #($a $b) end: 2.
	self assert: parser parse: 'abc1' to: #($a $b $c) end: 3.
	self assert: parser parse: 'a12' to: #($a) end: 1.
	self assert: parser parse: 'ab12' to: #($a $b) end: 2.
	self assert: parser parse: 'abc12' to: #($a $b $c) end: 3.
	self assert: parser parse: 'a123' to: #($a) end: 1.
	self assert: parser parse: 'ab123' to: #($a $b) end: 2.
	self assert: parser parse: 'abc123' to: #($a $b $c) end: 3!

testPostCopy
	| parser copy |
	parser := PPParser new.
	parser propertyAt: #foo put: true.
	copy := parser copy.
	copy propertyAt: #foo put: false.
	self assert: (parser propertyAt: #foo).
	self deny: (copy propertyAt: #foo)!

testPrint
	| parser |
	parser := PPParser new.
	self assert: (parser printString findString: 'PPParser') > 0.
	
	parser := PPParser named: 'choice'.
	self assert: (parser printString findString: 'PPParser(choice') > 0.
	
	parser := PPLiteralObjectParser on: $a.
	self assert: (parser printString findString: '$a') > 0.
	
	parser := PPFailingParser message: 'error'.
	self assert: (parser printString findString: 'error') > 0.
	
	parser := PPPredicateObjectParser on: [ :c | true ] message: 'error'.
	self assert: (parser printString findString: 'error') > 0!

testPropertyAt
	| parser |
	parser := PPParser new.
	self should: [ parser propertyAt: #foo ] raise: Error.
	parser propertyAt: #foo put: true.
	self assert: (parser propertyAt: #foo)!

testPropertyAtIfAbsent
	| parser |
	parser := PPParser new.
	self assert: (parser propertyAt: #foo ifAbsent: [ true ]).
	parser propertyAt: #foo put: true.
	self assert: (parser propertyAt: #foo ifAbsent: [ false ])!

testPropertyAtIfAbsentPut
	| parser |
	parser := PPParser new.
	self assert: (parser propertyAt: #foo ifAbsentPut: [ true ]).
	self assert: (parser propertyAt: #foo ifAbsentPut: [ false ])!

testRemoveProperty
	| parser |
	parser := PPParser new.
	self should: [ parser removeProperty: #foo ] raise: Error.
	parser propertyAt: #foo put: true.
	self assert: (parser removeProperty: #foo)!

testRemovePropertyIfAbsent
	| parser |
	parser := PPParser new.
	self assert: (parser removeProperty: #foo ifAbsent: [ true ]).
	parser propertyAt: #foo put: true.
	self assert: (parser removeProperty: #foo ifAbsent: [ false ])!

testSeparatedBy
	| parser |
	parser := $a asParser separatedBy: $b asParser.
	
	self assert: parser parse: 'a' to: #($a).
	self assert: parser parse: 'aba' to: #($a $b $a).
	self assert: parser parse: 'ababa' to: #($a $b $a $b $a).
	
	self assert: parser parse: 'ab' to: #($a) end: 1.
	self assert: parser parse: 'abab' to: #($a $b $a) end: 3.
	self assert: parser parse: 'ac' to: #($a) end: 1.
	self assert: parser parse: 'abac' to: #($a $b $a) end: 3.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'c'!

testSeparatedByWithoutSeparators
	| parser |
	parser := ($a asParser separatedBy: $b asParser)
		withoutSeparators.
	
	self assert: parser parse: 'a' to: #($a).
	self assert: parser parse: 'aba' to: #($a $a).
	self assert: parser parse: 'ababa' to: #($a $a $a).
	
	self assert: parser parse: 'ab' to: #($a) end: 1.
	self assert: parser parse: 'abab' to: #($a $a) end: 3.
	self assert: parser parse: 'ac' to: #($a) end: 1.
	self assert: parser parse: 'abac' to: #($a $a) end: 3.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'c'!

testSequence
	| parser |
	parser := $a asParser , $b asParser.
	
	self assert: parser parse: 'ab' to: #($a $b).
	
	self assert: parser parse: 'aba' to: #($a $b) end: 2.
	self assert: parser parse: 'abb' to: #($a $b) end: 2.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'aa'.
	self assert: parser fail: 'ba'.
	self assert: parser fail: 'bab'!

testSideEffectChoice
	"Adding another element to a choice should create a copy, otherwise we get unwanted side-effects."

	| p1 p2 p3 |
	p1 := $a asParser.
	p2 := p1 / $b asParser.
	p3 := p1 / $c asParser.
	
	self assert: p1 parse: 'a'.
	self assert: p1 fail: 'b'.
	self assert: p1 fail: 'c'.
	
	self assert: p2 parse: 'a'.
	self assert: p2 parse: 'b'.
	self assert: p2 fail: 'c'.
	
	self assert: p3 parse: 'a'.
	self assert: p3 fail: 'b'.
	self assert: p3 parse: 'c'!

testSideEffectListCopy
	| old new |
	old := $a asParser , $b asParser.
	new := old copy.
	
	self deny: old == new.
	self deny: old children == new children.
	self assert: old children first == new children first.
	self assert: old children last == new children last!

testSideEffectSequence
	"Adding another element to a sequence should create a copy, otherwise we get unwanted side-effects."

	| p1 p2 p3 |
	p1 := $a asParser.
	p2 := p1 , $b asParser.
	p3 := p1 , $c asParser.
	
	self assert: p1 parse: 'a'.	
	self assert: p1 parse: 'ab' end: 1.
	self assert: p1 parse: 'ac' end: 1.
	
	self assert: p2 fail: 'a'.	
	self assert: p2 parse: 'ab'.
	self assert: p2 fail: 'ac'.

	self assert: p3 fail: 'a'.	
	self assert: p3 fail: 'ab'.
	self assert: p3 parse: 'ac'!

testStar
	| parser |
	parser := $a asParser star.
	
	self assert: parser min = 0.
	self assert: parser max > parser min.
	
	self assert: parser parse: '' to: #().
	self assert: parser parse: 'a' to: #($a).
	self assert: parser parse: 'aa' to: #($a $a).
	self assert: parser parse: 'aaa' to: #($a $a $a).
	
	self assert: parser parse: 'b' to: #() end: 0.
	self assert: parser parse: 'ab' to: #($a) end: 1.
	self assert: parser parse: 'aab' to: #($a $a) end: 2.
	self assert: parser parse: 'aaab' to: #($a $a $a) end: 3!

testStarGreedy
	| limit parser |
	limit := #digit asParser.
	parser := #word asParser starGreedy: limit.
	
	self assert: parser min = 0.
	self assert: parser max > parser min.
	self assert: parser limit = limit.
	self assert: parser children size = 2.
	self assert: parser children last = limit.

	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'ab'.

	self assert: parser parse: '1' to: #() end: 0.
	self assert: parser parse: 'a1' to: #($a) end: 1.
	self assert: parser parse: 'ab1' to: #($a $b) end: 2.
	self assert: parser parse: 'abc1' to: #($a $b $c) end: 3.
	self assert: parser parse: '12' to: #($1) end: 1.
	self assert: parser parse: 'a12' to: #($a $1) end: 2.
	self assert: parser parse: 'ab12' to: #($a $b $1) end: 3.
	self assert: parser parse: 'abc12' to: #($a $b $c $1) end: 4.
	self assert: parser parse: '123' to: #($1 $2) end: 2.
	self assert: parser parse: 'a123' to: #($a $1 $2) end: 3.
	self assert: parser parse: 'ab123' to: #($a $b $1 $2) end: 4.
	self assert: parser parse: 'abc123' to: #($a $b $c $1 $2) end: 5!

testStarLazy
	| limit parser |
	limit := #digit asParser.
	parser := #word asParser starLazy: limit.
	
	self assert: parser min = 0.
	self assert: parser max > parser min.
	self assert: parser limit = limit.
	self assert: parser children size = 2.
	self assert: parser children last = limit.

	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'ab'.

	self assert: parser parse: '1' to: #() end: 0.
	self assert: parser parse: 'a1' to: #($a) end: 1.
	self assert: parser parse: 'ab1' to: #($a $b) end: 2.
	self assert: parser parse: 'abc1' to: #($a $b $c) end: 3.
	self assert: parser parse: '12' to: #() end: 0.
	self assert: parser parse: 'a12' to: #($a) end: 1.
	self assert: parser parse: 'ab12' to: #($a $b) end: 2.
	self assert: parser parse: 'abc12' to: #($a $b $c) end: 3.
	self assert: parser parse: '123' to: #() end: 0.
	self assert: parser parse: 'a123' to: #($a) end: 1.
	self assert: parser parse: 'ab123' to: #($a $b) end: 2.
	self assert: parser parse: 'abc123' to: #($a $b $c) end: 3!

testTimes
	| parser |
	parser := $a asParser times: 2.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser parse: 'aa' to: #($a $a).
	self assert: parser parse: 'aaa' to: #($a $a) end: 2!

testToken
	| parser |
	parser := $a asParser token.
	self assert: parser tokenClass = PPToken.
	self assert: parser parse: 'a' toToken: 1 stop: 1.	
	self assert: parser fail: 'b'.
	self assert: parser fail: ''.
	
	parser := $a asParser token: PPToken.
	self assert: parser tokenClass = PPToken.
	self assert: parser parse: 'a' toToken: 1 stop: 1.	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'!

testTrim
	| parser |
	parser := $a asParser token trim.
	
	self assert: parser parse: 'a' toToken: 1 stop: 1.
	self assert: parser parse: 'a ' toToken: 1 stop: 1.
	self assert: parser parse: 'a	' toToken: 1 stop: 1.
	self assert: parser parse: 'a  ' toToken: 1 stop: 1.
	self assert: parser parse: 'a 
	 ' toToken: 1 stop: 1.
		
	self assert: parser parse: 'a' toToken: 1 stop: 1.
	self assert: parser parse: ' a' toToken: 2 stop: 2.
	self assert: parser parse: '	a' toToken: 2 stop: 2.
	self assert: parser parse: '    a' toToken: 5 stop: 5.

	
	self assert: parser parse: 'aa' toToken: 1 stop: 1 end: 1.
	self assert: parser parse: 'a	a' toToken: 1 stop: 1 end: 2.
	self assert: parser parse: 'a  a' toToken: 1 stop: 1 end: 3.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'!

testTrimBlanks
	| parser |
	parser := $a asParser token trimBlanks.
	
	self assert: parser parse: 'a' toToken: 1 stop: 1.
	self assert: parser parse: 'a ' toToken: 1 stop: 1.
	self assert: parser parse: 'a	' toToken: 1 stop: 1.
	self assert: parser parse: 'a  ' toToken: 1 stop: 1.
	
	self assert: parser parse: 'a' toToken: 1 stop: 1.
	self assert: parser parse: ' a' toToken: 2 stop: 2.
	self assert: parser parse: '	a' toToken: 2 stop: 2.
	self assert: parser parse: '    a' toToken: 5 stop: 5.
	
	self assert: parser parse: 'aa' toToken: 1 stop: 1 end: 1.
	self assert: parser parse: 'a	a' toToken: 1 stop: 1 end: 2.
	self assert: parser parse: 'a  a' toToken: 1 stop: 1 end: 3.
	
	self assert: parser fail: ''.
	self assert: parser fail: '
'.
	self assert: parser fail: '
a'.
	self assert: parser fail: 'b'.!

testTrimCustom
	| parser |
	parser := $a asParser token trim: $b asParser.
	
	self assert: parser parse: 'a' toToken: 1 stop: 1.
	self assert: parser parse: 'ab' toToken: 1 stop: 1.
	self assert: parser parse: 'abb' toToken: 1 stop: 1.
		
	self assert: parser parse: 'a' toToken: 1 stop: 1.
	self assert: parser parse: 'ba' toToken: 2 stop: 2.
	self assert: parser parse: 'bba' toToken: 3 stop: 3.
	
	self assert: parser parse: 'aa' toToken: 1 stop: 1 end: 1.
	self assert: parser parse: 'ab' toToken: 1 stop: 1 end: 2.
	self assert: parser parse: 'abba' toToken: 1 stop: 1 end: 3.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'!

testTrimSpaces
	| parser |
	parser := $a asParser token trimSpaces.
	
	self assert: parser parse: 'a' toToken: 1 stop: 1.
	self assert: parser parse: 'a ' toToken: 1 stop: 1.
	self assert: parser parse: 'a	' toToken: 1 stop: 1.
	self assert: parser parse: 'a  ' toToken: 1 stop: 1.
	self assert: parser parse: 'a 
	 ' toToken: 1 stop: 1.
		
	self assert: parser parse: 'a' toToken: 1 stop: 1.
	self assert: parser parse: ' a' toToken: 2 stop: 2.
	self assert: parser parse: '	a' toToken: 2 stop: 2.
	self assert: parser parse: '    a' toToken: 5 stop: 5.
	self assert: parser parse: '     a' toToken: 6 stop: 6.
	
	self assert: parser parse: 'aa' toToken: 1 stop: 1 end: 1.
	self assert: parser parse: 'a	a' toToken: 1 stop: 1 end: 2.
	self assert: parser parse: 'a  a' toToken: 1 stop: 1 end: 3.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'!

testUnresolved
	| parser |
	parser := PPUnresolvedParser new.
	
	self assert: parser isUnresolved.
	self should: [ parser parse: '' ] raise: Error.
	self should: [ parser parse: 'a' ] raise: Error.
	self should: [ parser parse: 'ab' ] raise: Error.
	
	parser := nil asParser.
	self deny: parser isUnresolved!

testWrapped
	| parser |
	parser := $a asParser wrapped.
	
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: 'b'.
	
	parser := (($a asParser , $b asParser ) wrapped , $c asParser).
	self assert: parser parse: 'abc' to: #(#($a $b) $c)!

testWrapping
	| parser result |
	parser := #digit asParser plus >=> [ :stream :cc | 
		Array 
			with: stream position 
			with: cc value 
			with: stream position ].

	self assert: parser parse: '1' to: #(0 ($1) 1).
	self assert: parser parse: '12' to: #(0 ($1 $2) 2).
	self assert: parser parse: '123' to: #(0 ($1 $2 $3) 3).
	
	result := parser parse: 'a'.
	self assert: result first = 0.
	self assert: result second isPetitFailure.
	self assert: result last = 0!

testXor
	| parser |
	parser := ($a asParser / $b asParser)
			|  ($b asParser / $c asParser).
	
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'c' to: $c.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'd'.
	
	" truly symmetric "
	parser := ($b asParser / $c asParser)
			|  ($a asParser / $b asParser).
	
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'c' to: $c.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'd'! !
!PPParserTest categoriesFor: #testAction!public!testing-mapping! !
!PPParserTest categoriesFor: #testAnd!public!testing! !
!PPParserTest categoriesFor: #testAnswer!public!testing-mapping! !
!PPParserTest categoriesFor: #testBlock!public!testing! !
!PPParserTest categoriesFor: #testChildren!public!testing-utilities! !
!PPParserTest categoriesFor: #testChoice!public!testing! !
!PPParserTest categoriesFor: #testDelimitedBy!public!testing! !
!PPParserTest categoriesFor: #testDelimitedByWithoutSeparators!public!testing! !
!PPParserTest categoriesFor: #testEndOfInput!public!testing! !
!PPParserTest categoriesFor: #testEndOfInputAfterMatch!public!testing! !
!PPParserTest categoriesFor: #testEpsilon!public!testing! !
!PPParserTest categoriesFor: #testFailing!public!testing! !
!PPParserTest categoriesFor: #testFailure!public!testing-utilities! !
!PPParserTest categoriesFor: #testFlatten!public!testing-mapping! !
!PPParserTest categoriesFor: #testFoldLeft2!public!testing-mapping! !
!PPParserTest categoriesFor: #testFoldLeft3!public!testing-mapping! !
!PPParserTest categoriesFor: #testFoldRight2!public!testing-mapping! !
!PPParserTest categoriesFor: #testFoldRight3!public!testing-mapping! !
!PPParserTest categoriesFor: #testHasProperty!public!testing-properties! !
!PPParserTest categoriesFor: #testListConstructor!public!testing-utilities! !
!PPParserTest categoriesFor: #testLiteralObject!public!testing! !
!PPParserTest categoriesFor: #testLiteralObjectCaseInsensitive!public!testing! !
!PPParserTest categoriesFor: #testLiteralSequence!public!testing! !
!PPParserTest categoriesFor: #testLiteralSequenceCaseInsensitive!public!testing! !
!PPParserTest categoriesFor: #testMap1!public!testing-mapping! !
!PPParserTest categoriesFor: #testMap2!public!testing-mapping! !
!PPParserTest categoriesFor: #testMap3!public!testing-mapping! !
!PPParserTest categoriesFor: #testMapFail1!public!testing-mapping! !
!PPParserTest categoriesFor: #testMapFail2!public!testing-mapping! !
!PPParserTest categoriesFor: #testMatches!public!testing-utilities! !
!PPParserTest categoriesFor: #testMatchesIn!public!testing-utilities! !
!PPParserTest categoriesFor: #testMatchesInEmpty!public!testing-utilities! !
!PPParserTest categoriesFor: #testMatchesInOverlapping!public!testing-utilities! !
!PPParserTest categoriesFor: #testMatchesSkipIn!public!testing-utilities! !
!PPParserTest categoriesFor: #testMatchesSkipInOverlapping!public!testing-utilities! !
!PPParserTest categoriesFor: #testMatchingRangesIn!public!testing-utilities! !
!PPParserTest categoriesFor: #testMatchingSkipRangesIn!public!testing-utilities! !
!PPParserTest categoriesFor: #testMax!public!testing! !
!PPParserTest categoriesFor: #testMaxGreedy!public!testing! !
!PPParserTest categoriesFor: #testMaxLazy!public!testing! !
!PPParserTest categoriesFor: #testMemoized!public!testing! !
!PPParserTest categoriesFor: #testMin!public!testing! !
!PPParserTest categoriesFor: #testMinGreedy!public!testing! !
!PPParserTest categoriesFor: #testMinLazy!public!testing! !
!PPParserTest categoriesFor: #testMinMax!public!testing! !
!PPParserTest categoriesFor: #testMinMaxGreedy!public!testing! !
!PPParserTest categoriesFor: #testMinMaxLazy!public!testing! !
!PPParserTest categoriesFor: #testNamed!public!testing-accessing! !
!PPParserTest categoriesFor: #testNegate!public!testing! !
!PPParserTest categoriesFor: #testNot!public!testing! !
!PPParserTest categoriesFor: #testOptional!public!testing! !
!PPParserTest categoriesFor: #testParse!public!testing-utilities! !
!PPParserTest categoriesFor: #testParseOnError0!public!testing-utilities! !
!PPParserTest categoriesFor: #testParseOnError1!public!testing-utilities! !
!PPParserTest categoriesFor: #testParseOnError2!public!testing-utilities! !
!PPParserTest categoriesFor: #testParser!public!testing-utilities! !
!PPParserTest categoriesFor: #testPermutation!public!testing-mapping! !
!PPParserTest categoriesFor: #testPluggable!public!testing! !
!PPParserTest categoriesFor: #testPlus!public!testing! !
!PPParserTest categoriesFor: #testPlusGreedy!public!testing! !
!PPParserTest categoriesFor: #testPlusLazy!public!testing! !
!PPParserTest categoriesFor: #testPostCopy!public!testing-properties! !
!PPParserTest categoriesFor: #testPrint!public!testing-accessing! !
!PPParserTest categoriesFor: #testPropertyAt!public!testing-properties! !
!PPParserTest categoriesFor: #testPropertyAtIfAbsent!public!testing-properties! !
!PPParserTest categoriesFor: #testPropertyAtIfAbsentPut!public!testing-properties! !
!PPParserTest categoriesFor: #testRemoveProperty!public!testing-properties! !
!PPParserTest categoriesFor: #testRemovePropertyIfAbsent!public!testing-properties! !
!PPParserTest categoriesFor: #testSeparatedBy!public!testing! !
!PPParserTest categoriesFor: #testSeparatedByWithoutSeparators!public!testing! !
!PPParserTest categoriesFor: #testSequence!public!testing! !
!PPParserTest categoriesFor: #testSideEffectChoice!public!testing-fixtures! !
!PPParserTest categoriesFor: #testSideEffectListCopy!public!testing-fixtures! !
!PPParserTest categoriesFor: #testSideEffectSequence!public!testing-fixtures! !
!PPParserTest categoriesFor: #testStar!public!testing! !
!PPParserTest categoriesFor: #testStarGreedy!public!testing! !
!PPParserTest categoriesFor: #testStarLazy!public!testing! !
!PPParserTest categoriesFor: #testTimes!public!testing! !
!PPParserTest categoriesFor: #testToken!public!testing-mapping! !
!PPParserTest categoriesFor: #testTrim!public!testing-mapping! !
!PPParserTest categoriesFor: #testTrimBlanks!public!testing-mapping! !
!PPParserTest categoriesFor: #testTrimCustom!public!testing-mapping! !
!PPParserTest categoriesFor: #testTrimSpaces!public!testing-mapping! !
!PPParserTest categoriesFor: #testUnresolved!public!testing! !
!PPParserTest categoriesFor: #testWrapped!public!testing! !
!PPParserTest categoriesFor: #testWrapping!public!testing-mapping! !
!PPParserTest categoriesFor: #testXor!public!testing! !

