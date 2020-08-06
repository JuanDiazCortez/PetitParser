"Filed out from Dolphin Smalltalk 7"!

Object subclass: #PPCharSetPredicate
	instanceVariableNames: 'block classification'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPCharSetPredicate guid: (GUID fromString: '{a0261457-29df-4da3-86c4-6d3d0f9df765}')!
PPCharSetPredicate comment: ''!
!PPCharSetPredicate categoriesForClass!Unclassified! !
!PPCharSetPredicate methodsFor!

initializeOn: aBlock
	block := aBlock.
	classification := Array new: 255.
	1 to: classification size do: [ :index |
		classification at: index put: (block
			value: (Character value: index)) ]!

value: aCharacter
	| index |
	index := aCharacter asInteger.
	index == 0
		ifTrue: [ ^ block value: aCharacter ].
	index > 255
		ifTrue: [ ^ block value: aCharacter ].
	^ classification at: index! !
!PPCharSetPredicate categoriesFor: #initializeOn:!initialization!public! !
!PPCharSetPredicate categoriesFor: #value:!evaluating!public! !

!PPCharSetPredicate class methodsFor!

on: aBlock
	^ self basicNew initializeOn: aBlock! !
!PPCharSetPredicate class categoriesFor: #on:!instance creation!public! !

