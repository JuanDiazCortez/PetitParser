"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #PPAbstractParserTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPAbstractParserTest guid: (GUID fromString: '{ef651645-b773-42c5-b72d-d6f1b8954f9a}')!
PPAbstractParserTest comment: ''!
!PPAbstractParserTest categoriesForClass!PetitTests-Core! !
!PPAbstractParserTest methodsFor!

assert: aParser fail: aCollection
	^ self assert: aParser fail: aCollection end: 0!

assert: aParser fail: aCollection end: anInteger
	| stream result |
	self assert: aParser isPetitParser description: 'Parser invalid'.
	stream := aCollection asPetitStream.
	result := aParser parse: stream.
	self assert: result isPetitFailure description: 'Parser did not fail'.
	self assert: stream position = anInteger description: 'Parser failed at wrong position'.
	^result!

assert: aParser parse: aCollection
	^ self assert: aParser parse: aCollection to: nil end: aCollection size !

assert: aParser parse: aCollection end: anInteger
	^ self assert: aParser parse: aCollection to: nil end: anInteger!

assert: aParser parse: aCollection to: anObject
	^ self assert: aParser parse: aCollection to: anObject end: aCollection size !

assert: aParser parse: aCollection to: aTargetObject end: anInteger
	| stream result |
	self 
		assert: aParser isPetitParser
		description: 'Parser invalid'.
	stream := aCollection asPetitStream.
	result := aParser parse: stream.
	aTargetObject isNil
		ifTrue: [ self deny: result isPetitFailure ]
		ifFalse: [ self assert: result = aTargetObject ].
	self 
		assert: stream position = anInteger
		description: 'Parser accepted at wrong position'.
	^ result!

assert: aParser parse: aCollection toToken: aStartInteger stop: aStopInteger
	^ self assert: aParser parse: aCollection toToken: aStartInteger stop: aStopInteger end: aCollection size!

assert: aParser parse: aParserObject toToken: aStartInteger stop: aStopInteger end: anEndInteger
	| token |
	token := self
				assert: aParser
				parse: aParserObject
				to: nil
				end: anEndInteger.
	self assert: (token isKindOf: PPToken).
	self assert: token start = aStartInteger.
	self assert: token stop = aStopInteger.
	^token!

isCollection

	^true ! !
!PPAbstractParserTest categoriesFor: #assert:fail:!public!utilities! !
!PPAbstractParserTest categoriesFor: #assert:fail:end:!public!utilities! !
!PPAbstractParserTest categoriesFor: #assert:parse:!public!utilities! !
!PPAbstractParserTest categoriesFor: #assert:parse:end:!public!utilities! !
!PPAbstractParserTest categoriesFor: #assert:parse:to:!public!utilities! !
!PPAbstractParserTest categoriesFor: #assert:parse:to:end:!public!utilities! !
!PPAbstractParserTest categoriesFor: #assert:parse:toToken:stop:!public!utilities! !
!PPAbstractParserTest categoriesFor: #assert:parse:toToken:stop:end:!public!utilities! !
!PPAbstractParserTest categoriesFor: #isCollection!public! !

!PPAbstractParserTest class methodsFor!

isAbstract
	^ self name = #PPAbstractParserTest!

packageNamesUnderTest
	^ #('PetitParser' 'PetitTests')! !
!PPAbstractParserTest class categoriesFor: #isAbstract!public!testing! !
!PPAbstractParserTest class categoriesFor: #packageNamesUnderTest!accessing!public! !

