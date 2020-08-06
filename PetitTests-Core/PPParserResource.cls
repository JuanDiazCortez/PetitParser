"Filed out from Dolphin Smalltalk 7"!

TestResource subclass: #PPParserResource
	instanceVariableNames: 'parsers'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPParserResource guid: (GUID fromString: '{e3795786-f540-4263-a3b1-d6ac13fa4a00}')!
PPParserResource comment: ''!
!PPParserResource categoriesForClass!PetitTests-Core! !
!PPParserResource methodsFor!

parserAt: aParserClass
	"Answer a cached instance of aParserClass."
	
	^self  parsers at: aParserClass name ifAbsentPut: [ aParserClass new ]!

parsers

	^ parsers ifNil: [ parsers  := Dictionary  new ]!

setUp
	super setUp.
	parsers := Dictionary new!

tearDown

	parsers := nil.! !
!PPParserResource categoriesFor: #parserAt:!accessing!public! !
!PPParserResource categoriesFor: #parsers!public! !
!PPParserResource categoriesFor: #setUp!public!running! !
!PPParserResource categoriesFor: #tearDown!public! !

