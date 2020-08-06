"Filed out from Dolphin Smalltalk 7"!

PPRepeatingParser subclass: #PPLimitedRepeatingParser
	instanceVariableNames: 'limit'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPLimitedRepeatingParser guid: (GUID fromString: '{7d0c49d4-6090-4ccb-913c-906896786a04}')!
PPLimitedRepeatingParser comment: ''!
!PPLimitedRepeatingParser categoriesForClass!Unclassified! !
!PPLimitedRepeatingParser methodsFor!

children
	^ Array with: parser with: limit!

limit
	"Answer the parser that limits (or ends) this repetition."
	
	^ limit!

matchesLimitOn: aStream
	| element position |
	position := aStream position.
	element := limit parseOn: aStream.
	aStream position: position.
	^ element isPetitFailure not!

replace: aParser with: anotherParser
	super replace: aParser with: anotherParser.
	limit == aParser ifTrue: [ limit := anotherParser ]!

setLimit: aParser
	limit := aParser! !
!PPLimitedRepeatingParser categoriesFor: #children!accessing!public! !
!PPLimitedRepeatingParser categoriesFor: #limit!accessing!public! !
!PPLimitedRepeatingParser categoriesFor: #matchesLimitOn:!public! !
!PPLimitedRepeatingParser categoriesFor: #replace:with:!*petitanalyzer-transforming!public! !
!PPLimitedRepeatingParser categoriesFor: #setLimit:!initialization!public! !

!PPLimitedRepeatingParser class methodsFor!

on: aParser limit: aLimitParser
	^ (self on: aParser) setLimit: aLimitParser! !
!PPLimitedRepeatingParser class categoriesFor: #on:limit:!instance creation!public! !

