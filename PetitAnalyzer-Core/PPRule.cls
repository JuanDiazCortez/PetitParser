"Filed out from Dolphin Smalltalk 7"!

Object subclass: #PPRule
	instanceVariableNames: 'owner search'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPRule guid: (GUID fromString: '{9890d1e0-bcf0-45c3-9be6-b058894fa590}')!
PPRule comment: ''!
!PPRule categoriesForClass!Unclassified! !
!PPRule methodsFor!

canMatch: aParser 
	^ true!

foundMatchFor: aParser 
	self subclassResponsibility!

initialize!

performOn: aParser
	(search match: aParser inContext: owner context)
		ifFalse: [ ^ nil ].
	(self canMatch: aParser)
		ifFalse: [ ^ nil ].
	^ self foundMatchFor: aParser!

setOwner: aGrammarSearcher
	owner := aGrammarSearcher!

setSearch: aParser
	search := aParser! !
!PPRule categoriesFor: #canMatch:!matching!public! !
!PPRule categoriesFor: #foundMatchFor:!matching!public! !
!PPRule categoriesFor: #initialize!initialization!public! !
!PPRule categoriesFor: #performOn:!matching!public! !
!PPRule categoriesFor: #setOwner:!initialization!public! !
!PPRule categoriesFor: #setSearch:!initialization!public! !

!PPRule class methodsFor!

new
	^ self basicNew initialize!

searchFor: aParser
	^ self new setSearch: aParser! !
!PPRule class categoriesFor: #new!instance creation!public! !
!PPRule class categoriesFor: #searchFor:!instance creation!public! !

