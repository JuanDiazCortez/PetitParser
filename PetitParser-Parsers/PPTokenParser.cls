"Filed out from Dolphin Smalltalk 7"!

PPFlattenParser subclass: #PPTokenParser
	instanceVariableNames: 'tokenClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPTokenParser guid: (GUID fromString: '{537ee21a-d3e9-41b5-8578-6253bd3bdd9f}')!
PPTokenParser comment: ''!
!PPTokenParser categoriesForClass!Unclassified! !
!PPTokenParser methodsFor!

initialize
	tokenClass := self defaultTokenClass!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self tokenClass = aParser tokenClass ]!

on: aCollection start: aStartInteger stop: aStopInteger value: anObject
	^ self tokenClass on: aCollection start: aStartInteger stop: aStopInteger value: anObject!

tokenClass
	^ tokenClass!

tokenClass: aTokenClass
	tokenClass := aTokenClass! !
!PPTokenParser categoriesFor: #initialize!initialization!public! !
!PPTokenParser categoriesFor: #match:inContext:seen:!*petitanalyzer-matching!public! !
!PPTokenParser categoriesFor: #on:start:stop:value:!public! !
!PPTokenParser categoriesFor: #tokenClass!accessing!public! !
!PPTokenParser categoriesFor: #tokenClass:!accessing!public! !

