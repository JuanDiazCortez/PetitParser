"Filed out from Dolphin Smalltalk 7"!

PPLiteralParser subclass: #PPLiteralSequenceParser
	instanceVariableNames: 'size'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPLiteralSequenceParser guid: (GUID fromString: '{3a9d0ddd-2182-4478-90f0-21f21531f421}')!
PPLiteralSequenceParser comment: ''!
!PPLiteralSequenceParser categoriesForClass!Unclassified! !
!PPLiteralSequenceParser methodsFor!

caseInsensitive
	"Answer a parser that can parse the receiver case-insensitive."
	
	literal asUppercase = literal asLowercase ifTrue: [ ^ self ].
	^ PPPredicateSequenceParser on: [ :value | literal sameAs: value ] message: message size: size!

initializeOn: anObject message: aString
	super initializeOn: anObject message: aString.
	size := literal size!

size
	"Answer the sequence size of the receiver."

	^ size! !
!PPLiteralSequenceParser categoriesFor: #caseInsensitive!operators!public! !
!PPLiteralSequenceParser categoriesFor: #initializeOn:message:!initialization!public! !
!PPLiteralSequenceParser categoriesFor: #size!accessing!public! !

