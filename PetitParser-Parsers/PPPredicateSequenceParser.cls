"Filed out from Dolphin Smalltalk 7"!

PPPredicateParser subclass: #PPPredicateSequenceParser
	instanceVariableNames: 'size'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPPredicateSequenceParser guid: (GUID fromString: '{98eacae9-a37b-44e5-b9ef-341ff3c2572c}')!
PPPredicateSequenceParser comment: ''!
!PPPredicateSequenceParser categoriesForClass!Unclassified! !
!PPPredicateSequenceParser methodsFor!

initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString size: anInteger
	predicate := aBlock.
	predicateMessage := aString.
	negated := aNegatedBlock.
	negatedMessage := aNegatedString.
	size := anInteger!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self size = aParser size ]!

negate
	"Answer a parser that is the negation of the receiving predicate parser."
	
	^ self class 
		on: negated message: negatedMessage
		negated: predicate message: predicateMessage
		size: size!

size
	"Answer the sequence size of the receiver."

	^ size! !
!PPPredicateSequenceParser categoriesFor: #initializeOn:message:negated:message:size:!initialization!public! !
!PPPredicateSequenceParser categoriesFor: #match:inContext:seen:!*petitanalyzer-matching!public! !
!PPPredicateSequenceParser categoriesFor: #negate!operators!public! !
!PPPredicateSequenceParser categoriesFor: #size!accessing!public! !

!PPPredicateSequenceParser class methodsFor!

on: aBlock message: aString negated: aNegatedBlock message: aNegatedString size: anInteger 
	^ self new initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString size: anInteger!

on: aBlock message: aString size: anInteger
	^ self on: aBlock message: aString negated: [ :each | (aBlock value: each) not ] message: 'no ' , aString size: anInteger! !
!PPPredicateSequenceParser class categoriesFor: #on:message:negated:message:size:!instance creation!public! !
!PPPredicateSequenceParser class categoriesFor: #on:message:size:!instance creation!public! !

