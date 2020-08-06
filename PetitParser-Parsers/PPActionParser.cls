"Filed out from Dolphin Smalltalk 7"!

PPDelegateParser subclass: #PPActionParser
	instanceVariableNames: 'block'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPActionParser guid: (GUID fromString: '{03fc4a64-5559-4bbe-85f8-87a2d2c46353}')!
PPActionParser comment: ''!
!PPActionParser categoriesForClass!Unclassified! !
!PPActionParser methodsFor!

block
	"Answer the action block of the receiver."

	^ block!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self block = aParser block ]!

parseOn: aStream
	| element |
	^ (element := parser parseOn: aStream) isPetitFailure
		ifFalse: [ block value: element ]
		ifTrue: [ element ]!

setBlock: aBlock
	block := aBlock! !
!PPActionParser categoriesFor: #block!accessing!public! !
!PPActionParser categoriesFor: #match:inContext:seen:!*petitanalyzer-matching!public! !
!PPActionParser categoriesFor: #parseOn:!parsing!public! !
!PPActionParser categoriesFor: #setBlock:!initialization!public! !

!PPActionParser class methodsFor!

on: aParser block: aBlock
	^ (self on: aParser) setBlock: aBlock! !
!PPActionParser class categoriesFor: #on:block:!instance creation!public! !

