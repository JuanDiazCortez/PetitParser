"Filed out from Dolphin Smalltalk 7"!

PPDelegateParser subclass: #PPFlattenParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPFlattenParser guid: (GUID fromString: '{48c57ae1-6e51-49bd-b400-4b2f26a6d2f8}')!
PPFlattenParser comment: ''!
!PPFlattenParser categoriesForClass!Unclassified! !
!PPFlattenParser methodsFor!

on: aCollection start: aStartInteger stop: aStopInteger value: anObject
	^ aCollection copyFrom: aStartInteger to: aStopInteger!

parseOn: aStream
	| start element |
	start := aStream position.
	element := parser parseOn: aStream.
	element isPetitFailure ifTrue: [ ^ element ].
	^ self on: aStream collection start: start + 1 stop: aStream position value: element! !
!PPFlattenParser categoriesFor: #on:start:stop:value:!public! !
!PPFlattenParser categoriesFor: #parseOn:!parsing!public! !

