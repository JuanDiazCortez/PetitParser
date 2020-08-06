"Filed out from Dolphin Smalltalk 7"!

PPDelegateParser subclass: #PPTrimmingParser
	instanceVariableNames: 'trimmer'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPTrimmingParser guid: (GUID fromString: '{87de7fcd-5b59-4be8-8f54-303fe2d4c77e}')!
PPTrimmingParser comment: ''!
!PPTrimmingParser categoriesForClass!Unclassified! !
!PPTrimmingParser methodsFor!

parseOn: aStream
	| position element |
	position := aStream position.
	[ (trimmer parseOn: aStream) isPetitFailure ]
		whileFalse.
	element := parser parseOn: aStream.
	element isPetitFailure ifTrue: [
		aStream position: position.
		^ element ].
	[ (trimmer parseOn: aStream) isPetitFailure ]
		whileFalse.
	^ element!

setTrimmer: aParser
	trimmer := aParser! !
!PPTrimmingParser categoriesFor: #parseOn:!parsing!public! !
!PPTrimmingParser categoriesFor: #setTrimmer:!initialization!public! !

!PPTrimmingParser class methodsFor!

on: aParser trimmer: aTrimParser
	^ self new
		setParser: aParser;
		setTrimmer: aTrimParser;
		yourself! !
!PPTrimmingParser class categoriesFor: #on:trimmer:!instance creation!public! !

