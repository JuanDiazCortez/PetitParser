"Filed out from Dolphin Smalltalk 7"!

PPParser subclass: #PPPluggableParser
	instanceVariableNames: 'block'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPPluggableParser guid: (GUID fromString: '{d63df72a-d9d8-4eee-a7f0-029d57c55618}')!
PPPluggableParser comment: ''!
!PPPluggableParser categoriesForClass!Unclassified! !
!PPPluggableParser methodsFor!

block
	"Answer the pluggable block."

	^ block!

initializeOn: aBlock
	block := aBlock!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self block = aParser block ]!

parseOn: aStream
	| position result |
	position := aStream position.
	result := block value: aStream.
	result isPetitFailure
		ifTrue: [ aStream position: position ].
	^ result! !
!PPPluggableParser categoriesFor: #block!accessing!public! !
!PPPluggableParser categoriesFor: #initializeOn:!initialization!public! !
!PPPluggableParser categoriesFor: #match:inContext:seen:!*petitanalyzer-matching!public! !
!PPPluggableParser categoriesFor: #parseOn:!parsing!public! !

!PPPluggableParser class methodsFor!

on: aBlock
	^ self new initializeOn: aBlock! !
!PPPluggableParser class categoriesFor: #on:!instance creation!public! !

