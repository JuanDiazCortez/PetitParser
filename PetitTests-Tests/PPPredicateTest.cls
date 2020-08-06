"Filed out from Dolphin Smalltalk 7"!

PPAbstractParserTest subclass: #PPPredicateTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPPredicateTest guid: (GUID fromString: '{f89d757b-8273-4ffa-81bf-9963a12898a5}')!
PPPredicateTest comment: ''!
!PPPredicateTest categoriesForClass!Unclassified! !
!PPPredicateTest methodsFor!

assertCharacterSets: aParser
	"Assert the character set of aParser does not overlap with the character set with the negated parser, and that they both cover the complete character space."

	| positives negatives |
	positives := self parsedCharacterSet: aParser.
	negatives := self parsedCharacterSet: aParser negate.
       ^self .
	self charactersDo: [ :char | 
		| positive negative |
		positive := positives includes: char.
		negative := negatives includes: char.
		self 
			assert: ((positive and: [ negative not ])
				or: [ positive not and: [ negative ] ])
			description: char printString , ' should be in exactly one set' ]!

charactersDo: aBlock
	1 to: 256 do: [ :index | aBlock value: (Character codePoint: index) ]!

parsedCharacterSet: aParser
	| result |
	result := WriteStream on: String new.
	self charactersDo: [ :char |
		(aParser matches: (String with: char))
			ifTrue: [ result nextPut: char ] ].
	^ result contents!

testAny
	| parser |
	parser := #any asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: ' ' to: $ .
	self assert: parser parse: '1' to: $1.
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: ''!

testAnyExceptAnyOf
	| parser |
	parser := PPPredicateObjectParser anyExceptAnyOf: #($: $,).
	self assertCharacterSets: parser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'z' to: $z.
	self assert: parser fail: ':'.
	self assert: parser fail: ','!

testAnyOf
	| parser |
	parser := PPPredicateObjectParser anyOf: #($a $z).
	self assertCharacterSets: parser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'z' to: $z.
	self assert: parser fail: 'x'!

testBetweenAnd
	| parser |
	parser := PPPredicateObjectParser between: $b and: $d.
	self assertCharacterSets: parser.
	self assert: parser fail: 'a'.
	self assert: parser parse: 'b' to: $b.
	self assert: parser parse: 'c' to: $c.
	self assert: parser parse: 'd' to: $d.
	self assert: parser fail: 'e'!

testBlank
	| parser |
	parser := #blank asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character space) to: Character space.
	self assert: parser parse: (String with: Character tab) to: Character tab.
	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: (String with: Character cr)!

testChar
	| parser |
	parser := $* asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: '*' to: $*.
	self assert: parser parse: '**' to: $* end: 1.
	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: 'a'!

testCr
	| parser |
	parser := #cr asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character cr) to: Character cr!

testDigit
	| parser |
	parser := #digit asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: '0' to: $0.
	self assert: parser parse: '9' to: $9.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'!

testExpect
	| parser |
	parser := PPPredicateObjectParser expect: $a.
	self assertCharacterSets: parser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: 'b'.
	self assert: parser fail: ''!

testHex
	| parser |
	parser := #hex asParser.
	"self assertCharacterSets: parser."
	self assert: parser parse: '0' to: $0.
	self assert: parser parse: '5' to: $5.
	self assert: parser parse: '9' to: $9.
	self assert: parser parse: 'A' to: $A.
	self assert: parser parse: 'D' to: $D.
	self assert: parser parse: 'F' to: $F.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'e' to: $e.
	self assert: parser parse: 'f' to: $f.
	self assert: parser fail: ''.
	self assert: parser fail: 'g'!

testLetter
	| parser |
	parser := #letter asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'Z' to: $Z.
	self assert: parser fail: ''.
	self assert: parser fail: '0'!

testLf
	| parser |
	parser := #lf asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character lf) to: Character lf!

testLowercase
	| parser |
	parser := #lowercase asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'z' to: $z.
	self assert: parser fail: ''.
	self assert: parser fail: 'A'.
	self assert: parser fail: '0'!

testNewline
	| parser |
	parser := #newline asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character cr) to: Character cr.
	self assert: parser parse: (String with: Character lf) to: Character lf.
	self assert: parser fail: ' '!

testOnMessage
	| block parser |
	block := [ :char | char = $* ].
	parser := PPPredicateObjectParser on: block message: 'starlet'.
	self assert: parser block = block.
	self assert: parser message = 'starlet'.
	
	self assertCharacterSets: parser.
	self assert: parser parse: '*' to: $*.
	self assert: parser parse: '**' to: $* end: 1.
	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: 'a'!

testPunctuation
	| parser |
	parser := #punctuation asParser.
	"self assertCharacterSets: parser."
	self assert: parser parse: '.' to: $..
	self assert: parser parse: ',' to: $,.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: '1'!

testSequenceParser
	| parser |
	parser := PPPredicateSequenceParser 
		on: [ :value | value first isUppercase ] 
		message: 'uppercase 3 letter words'
		size: 3.
	self assert: parser size = 3.
	self assert: parser parse: 'Abc'.
	self assert: parser parse: 'ABc'.
	self assert: parser parse: 'ABC'.
	self assert: parser fail: 'abc'.
	self assert: parser fail: 'aBC'.
	self assert: parser fail: 'Ab'.
	
	parser := parser negate.
	self assert: parser size = 3.
	self assert: parser fail: 'Abc'.
	self assert: parser fail: 'ABc'.
	self assert: parser fail: 'ABC'.
	self assert: parser parse: 'abc'.
	self assert: parser parse: 'aBC'.
	self assert: parser fail: 'Ab'!

testSpace
	| parser |
	parser := #space asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character tab) to: Character tab.
	self assert: parser parse: ' ' to: Character space.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'!

testTab
	| parser |
	parser := #tab asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: (String with: Character tab) to: Character tab!

testUppercase
	| parser |
	parser := #uppercase asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: 'A' to: $A.
	self assert: parser parse: 'Z' to: $Z.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: '0'!

testWord
	| parser |
	parser := #word asParser.
	self assertCharacterSets: parser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'A' to: $A.
	self assert: parser parse: '0' to: $0.
	self assert: parser fail: ''.
	self assert: parser fail: '-'! !
!PPPredicateTest categoriesFor: #assertCharacterSets:!public!utilities! !
!PPPredicateTest categoriesFor: #charactersDo:!private! !
!PPPredicateTest categoriesFor: #parsedCharacterSet:!public!utilities! !
!PPPredicateTest categoriesFor: #testAny!public!testing-objects! !
!PPPredicateTest categoriesFor: #testAnyExceptAnyOf!public!testing-objects! !
!PPPredicateTest categoriesFor: #testAnyOf!public!testing-objects! !
!PPPredicateTest categoriesFor: #testBetweenAnd!public!testing-objects! !
!PPPredicateTest categoriesFor: #testBlank!public!testing-chars! !
!PPPredicateTest categoriesFor: #testChar!public!testing-chars! !
!PPPredicateTest categoriesFor: #testCr!public!testing-chars! !
!PPPredicateTest categoriesFor: #testDigit!public!testing-chars! !
!PPPredicateTest categoriesFor: #testExpect!public!testing-objects! !
!PPPredicateTest categoriesFor: #testHex!public!testing-chars! !
!PPPredicateTest categoriesFor: #testLetter!public!testing-chars! !
!PPPredicateTest categoriesFor: #testLf!public!testing-chars! !
!PPPredicateTest categoriesFor: #testLowercase!public!testing-chars! !
!PPPredicateTest categoriesFor: #testNewline!public!testing-chars! !
!PPPredicateTest categoriesFor: #testOnMessage!public!testing! !
!PPPredicateTest categoriesFor: #testPunctuation!public!testing-chars! !
!PPPredicateTest categoriesFor: #testSequenceParser!public!testing-sequence! !
!PPPredicateTest categoriesFor: #testSpace!public!testing-chars! !
!PPPredicateTest categoriesFor: #testTab!public!testing-chars! !
!PPPredicateTest categoriesFor: #testUppercase!public!testing-chars! !
!PPPredicateTest categoriesFor: #testWord!public!testing-chars! !

