"Filed out from Dolphin Smalltalk 7"!

PPParser subclass: #PPLiteralParser
	instanceVariableNames: 'literal message'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPLiteralParser guid: (GUID fromString: '{c9e6011e-be33-483f-a4a6-8c45304aeb57}')!
PPLiteralParser comment: ''!
!PPLiteralParser categoriesForClass!Unclassified! !
!PPLiteralParser methodsFor!

caseInsensitive
	"Answer a parser that can parse the receiver case-insensitive."
	
	self subclassResponsibility!

initializeOn: anObject message: aString
	literal := anObject.
	message := aString!

literal
	"Answer the parsed literal."

	^ literal!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self literal = aParser literal and: [ self message = aParser message ] ]!

message
	"Answer the failure message."
	
	^ message!

printNameOn: aStream
	super printNameOn: aStream.
	aStream nextPutAll: ', '; print: literal! !
!PPLiteralParser categoriesFor: #caseInsensitive!operators!public! !
!PPLiteralParser categoriesFor: #initializeOn:message:!initialization!public! !
!PPLiteralParser categoriesFor: #literal!accessing!public! !
!PPLiteralParser categoriesFor: #match:inContext:seen:!*petitanalyzer-matching!public! !
!PPLiteralParser categoriesFor: #message!accessing!public! !
!PPLiteralParser categoriesFor: #printNameOn:!printing!public! !

!PPLiteralParser class methodsFor!

on: anObject
	^ self on: anObject message: anObject printString , ' expected'!

on: anObject message: aString
	^ self new initializeOn: anObject message: aString! !
!PPLiteralParser class categoriesFor: #on:!instance creation!public! !
!PPLiteralParser class categoriesFor: #on:message:!instance creation!public! !

