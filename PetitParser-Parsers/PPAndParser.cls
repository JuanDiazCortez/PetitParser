"Filed out from Dolphin Smalltalk 7"!

PPDelegateParser subclass: #PPAndParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPAndParser guid: (GUID fromString: '{6f90e78a-d460-448c-ba27-dc1e03e60b0a}')!
PPAndParser comment: ''!
!PPAndParser categoriesForClass!Unclassified! !
!PPAndParser methodsFor!

and
	^ self!

parseOn: aStream
	| element position |
	position := aStream position.
	element := parser parseOn: aStream.
	aStream position: position.
	^ element! !
!PPAndParser categoriesFor: #and!operators!public! !
!PPAndParser categoriesFor: #parseOn:!parsing!public! !

