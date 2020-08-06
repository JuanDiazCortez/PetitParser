"Filed out from Dolphin Smalltalk 7"!

PPLiteralParser subclass: #PPLiteralObjectParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPLiteralObjectParser guid: (GUID fromString: '{570bb3af-f242-40d9-848a-ccf86e1c6b37}')!
PPLiteralObjectParser comment: ''!
!PPLiteralObjectParser categoriesForClass!Unclassified! !
!PPLiteralObjectParser methodsFor!

caseInsensitive
	"Answer a parser that can parse the receiver case-insensitive."
	
	literal asUppercase = literal asLowercase ifTrue: [ ^ self ].
	^ PPPredicateObjectParser on: [ :value | literal sameAs: value ] message: message!

negate
	^ (PPPredicateObjectParser expect: literal message: message) negate! !
!PPLiteralObjectParser categoriesFor: #caseInsensitive!operators!public! !
!PPLiteralObjectParser categoriesFor: #negate!operators!public! !

