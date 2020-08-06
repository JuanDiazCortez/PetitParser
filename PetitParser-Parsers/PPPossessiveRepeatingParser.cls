"Filed out from Dolphin Smalltalk 7"!

PPRepeatingParser subclass: #PPPossessiveRepeatingParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPPossessiveRepeatingParser guid: (GUID fromString: '{946d7613-8b2a-4282-bbbd-690ab1fa4c89}')!
PPPossessiveRepeatingParser comment: ''!
!PPPossessiveRepeatingParser categoriesForClass!Unclassified! !
!PPPossessiveRepeatingParser methodsFor!

parseOn: aStream
	| start element elements |
	start := aStream position.
	elements := OrderedCollection new.
	[ elements size < min ] whileTrue: [
		(element := parser parseOn: aStream) isPetitFailure ifTrue: [
			aStream position: start.
			^ element ].
		elements addLast: element ].
	[ elements size < max ] whileTrue: [
	 	(element := parser parseOn: aStream) isPetitFailure
			ifTrue: [ ^ elements asArray ].
		elements addLast: element ].
	^ elements asArray! !
!PPPossessiveRepeatingParser categoriesFor: #parseOn:!parsing!public! !

