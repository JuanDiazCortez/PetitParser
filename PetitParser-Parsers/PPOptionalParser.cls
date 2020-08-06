"Filed out from Dolphin Smalltalk 7"!

PPDelegateParser subclass: #PPOptionalParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPOptionalParser guid: (GUID fromString: '{3cd18750-2497-44db-b9f1-f068a9721df3}')!
PPOptionalParser comment: ''!
!PPOptionalParser categoriesForClass!Unclassified! !
!PPOptionalParser methodsFor!

isNullable
	^ true!

parseOn: aStream
	| element |
	element := parser parseOn: aStream.
	^ element isPetitFailure ifFalse: [ element ]! !
!PPOptionalParser categoriesFor: #isNullable!*petitanalyzer-testing!public! !
!PPOptionalParser categoriesFor: #parseOn:!parsing!public! !

