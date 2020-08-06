"Filed out from Dolphin Smalltalk 7"!

PPParser subclass: #PPDelegateParser
	instanceVariableNames: 'parser'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPDelegateParser guid: (GUID fromString: '{e2e83ac7-963f-45c7-8bd4-16ac1f29878a}')!
PPDelegateParser comment: ''!
!PPDelegateParser categoriesForClass!Unclassified! !
!PPDelegateParser methodsFor!

children
	^ Array with: parser!

parseOn: aStream
	^ parser parseOn: aStream!

replace: aParser with: anotherParser
	super replace: aParser with: anotherParser.
	parser == aParser ifTrue: [ parser := anotherParser ]!

setParser: aParser
	parser := aParser! !
!PPDelegateParser categoriesFor: #children!accessing!public! !
!PPDelegateParser categoriesFor: #parseOn:!parsing!public! !
!PPDelegateParser categoriesFor: #replace:with:!*petitanalyzer-transforming!public! !
!PPDelegateParser categoriesFor: #setParser:!initialization!public! !

!PPDelegateParser class methodsFor!

on: aParser
	^ self new setParser: aParser! !
!PPDelegateParser class categoriesFor: #on:!instance creation!public! !

