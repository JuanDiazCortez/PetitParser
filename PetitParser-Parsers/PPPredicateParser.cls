"Filed out from Dolphin Smalltalk 7"!

PPParser subclass: #PPPredicateParser
	instanceVariableNames: 'predicate predicateMessage negated negatedMessage'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPPredicateParser guid: (GUID fromString: '{21fbdec7-9410-4225-b791-bf81a0715b34}')!
PPPredicateParser comment: ''!
!PPPredicateParser categoriesForClass!Unclassified! !
!PPPredicateParser methodsFor!

block
	"Answer the predicate block of the receiver."
	
	^ predicate!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self block = aParser block and: [ self message = aParser message ] ]!

message
	"Answer the failure message."
	
	^ predicateMessage!

printNameOn: aStream
	super printNameOn: aStream.
	aStream nextPutAll: ', '; print: predicateMessage! !
!PPPredicateParser categoriesFor: #block!accessing!public! !
!PPPredicateParser categoriesFor: #match:inContext:seen:!*petitanalyzer-matching!public! !
!PPPredicateParser categoriesFor: #message!accessing!public! !
!PPPredicateParser categoriesFor: #printNameOn:!printing!public! !

