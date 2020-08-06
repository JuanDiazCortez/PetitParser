"Filed out from Dolphin Smalltalk 7"!

PPAbstractParserTest subclass: #PPExtensionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPExtensionTest guid: (GUID fromString: '{97e4286d-4ca9-4efd-b1d1-9d13a06381ad}')!
PPExtensionTest comment: ''!
!PPExtensionTest categoriesForClass!Unclassified! !
!PPExtensionTest methodsFor!

testCharacter
	| parser |
	parser := $a asParser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: 'b'!

testChoice
	| parser |
	parser := #(1 2) asChoiceParser.
	self assert: parser parse: #(1) to: 1.
	self assert: parser parse: #(2) to: 2.
	self assert: parser parse: #(1 2) to: 1 end: 1.
	self assert: parser parse: #(2 1) to: 2 end: 1.
	self assert: parser fail: #().
	self assert: parser fail: #(3)!

testClosure
	| parser |
	parser := [ :stream | stream upTo: $s ] asParser.
	self assert: parser parse: '' to: ''.
	self assert: parser parse: 'a' to: 'a'.
	self assert: parser parse: 'aa' to: 'aa'.
	self assert: parser parse: 's' to: ''.
	self assert: parser parse: 'as' to: 'a'.
	self assert: parser parse: 'aas' to: 'aa'.
	self assert: parser parse: 'sa' to: '' end: 1.
	self assert: parser parse: 'saa' to: '' end: 1.
	
	parser := [ :stream | stream upTo: $s. PPFailure message: 'stream' at: stream position ] asParser.
	self assert: parser fail: ''.
	self assert: parser fail: 's'.
	self assert: parser fail: 'as'!

testEpsilon
	| parser |
	parser := nil asParser.
	self assert: parser asParser = parser!

testParser
	| parser |
	parser := $a asParser.
	self assert: parser asParser = parser!

testRange
	| parser |
	parser := ($a - $c) asParser .
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'b' to: $b.
	self assert: parser parse: 'c' to: $c.
	self assert: parser fail: 'd'!

testSequence
	| parser |
	parser := #(1 2) asSequenceParser.
	self assert: parser parse: #(1 2) to: #(1 2).
	self assert: parser parse: #(1 2 3) to: #(1 2) end: 2.
	self assert: parser fail: #().
	self assert: parser fail: #(1).
	self assert: parser fail: #(1 1).
	self assert: parser fail: #(1 1 2)!

testStream
	| stream |
	stream := 'abc' readStream asPetitStream.
	self assert: (stream class = PPStream).
	self assert: (stream printString = '.abc').
	self assert: (stream peek) = $a.
	self assert: (stream uncheckedPeek = $a).
	self assert: (stream next) = $a.
	self assert: (stream printString = 'a.bc').
	self assert: (stream asPetitStream = stream)!

testString
	| parser |
	parser := 'ab' asParser.
	self assert: parser parse: 'ab' to: 'ab'.
	self assert: parser parse: 'aba' to: 'ab' end: 2.
	self assert: parser parse: 'abb' to: 'ab' end: 2.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'ac'!

testSymbol
	| parser |
	parser := #any asParser.
	self assert: parser parse: 'a'.
	self assert: parser fail: ''!

testText
	| stream |
	stream := 'abc' asText asPetitStream.
	self assert: stream class = PPStream! !
!PPExtensionTest categoriesFor: #testCharacter!public!testing-parser! !
!PPExtensionTest categoriesFor: #testChoice!public!testing-parser! !
!PPExtensionTest categoriesFor: #testClosure!public!testing-parser! !
!PPExtensionTest categoriesFor: #testEpsilon!public!testing-parser! !
!PPExtensionTest categoriesFor: #testParser!public!testing-parser! !
!PPExtensionTest categoriesFor: #testRange!public!testing-parser! !
!PPExtensionTest categoriesFor: #testSequence!public!testing-parser! !
!PPExtensionTest categoriesFor: #testStream!public!testing-stream! !
!PPExtensionTest categoriesFor: #testString!public!testing-parser! !
!PPExtensionTest categoriesFor: #testSymbol!public!testing-parser! !
!PPExtensionTest categoriesFor: #testText!public!testing-stream! !

