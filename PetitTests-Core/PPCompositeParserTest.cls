"Filed out from Dolphin Smalltalk 7"!

PPAbstractParserTest subclass: #PPCompositeParserTest
	instanceVariableNames: 'parser result'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPCompositeParserTest guid: (GUID fromString: '{f8dfb9aa-ea7d-441d-a26b-615afabe098a}')!
PPCompositeParserTest comment: ''!
!PPCompositeParserTest categoriesForClass!PetitTests-Core! !
!PPCompositeParserTest methodsFor!

assert: aCollection is: anObject
	self parse: aCollection.
	self
		assert: result = anObject
		description: 'Got: ' , result printString , '; Expected: ' , anObject printString
		resumable: true!

fail: aString rule: aSymbol 
	| production |
	production := self parserInstanceFor: aSymbol.
	result := production end parse: aString.
	self
		assert: result isPetitFailure
		description: 'Able to parse ' , aString printString.
	^ result!

parse: aString 
	^ self parse: aString rule: #start!

parse: aString rule: aSymbol
	| production |
	production := self parserInstanceFor: aSymbol.
	result := production end parse: aString.
	self
		deny: result isPetitFailure
		description: 'Unable to parse ' , aString printString.
	^ result!

parseInstanceFor: aSymbol
	^aSymbol = #start
		ifTrue: [self parseInstance]
		ifFalse: 
			[self parseInstance productionAt: aSymbol
				ifAbsent: 
					[self error: ' Produccion ' , self parserClass name , ' >>' , aSymbol printString , ' not found']]!

parserClass
	self subclassResponsibility!

parserInstance
	^ PPParserResource reset; current parserAt: self parserClass!

parserInstanceFor: aSymbol
	^ aSymbol = #start
		ifTrue: [ self parserInstance ]
		ifFalse: [
			self parserInstance
				productionAt: aSymbol 
				ifAbsent: [ self error: 'Production ' , self parserClass name , '>>' , aSymbol printString , ' not found.' ] ]!

resources
	^ Array with: PPParserResource!

setUp
	super setUp.
	parser := self parserInstance!

tearDown
	super tearDown.
	parser := result := nil.
	! !
!PPCompositeParserTest categoriesFor: #assert:is:!public!utilities! !
!PPCompositeParserTest categoriesFor: #fail:rule:!parsing!public! !
!PPCompositeParserTest categoriesFor: #parse:!parsing!public! !
!PPCompositeParserTest categoriesFor: #parse:rule:!parsing!public! !
!PPCompositeParserTest categoriesFor: #parseInstanceFor:!public! !
!PPCompositeParserTest categoriesFor: #parserClass!accessing!public! !
!PPCompositeParserTest categoriesFor: #parserInstance!accessing!public! !
!PPCompositeParserTest categoriesFor: #parserInstanceFor:!accessing!public! !
!PPCompositeParserTest categoriesFor: #resources!public! !
!PPCompositeParserTest categoriesFor: #setUp!public!running! !
!PPCompositeParserTest categoriesFor: #tearDown!public!running! !

!PPCompositeParserTest class methodsFor!

isAbstract
	^ self name = #PPCompositeParserTest!

resources
	^ Array with: PPParserResource! !
!PPCompositeParserTest class categoriesFor: #isAbstract!public!testing! !
!PPCompositeParserTest class categoriesFor: #resources!accessing!public! !

