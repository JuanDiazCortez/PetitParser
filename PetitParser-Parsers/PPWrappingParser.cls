"Filed out from Dolphin Smalltalk 7"!

PPActionParser subclass: #PPWrappingParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPWrappingParser guid: (GUID fromString: '{a10eba1d-5b6b-48d8-af30-5126a979d0bb}')!
PPWrappingParser comment: ''!
!PPWrappingParser categoriesForClass!Unclassified! !
!PPWrappingParser methodsFor!

parseOn: aStream
	^ block value: aStream value: [ parser parseOn: aStream ]! !
!PPWrappingParser categoriesFor: #parseOn:!parsing!public! !

