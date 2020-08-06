"Filed out from Dolphin Smalltalk 7"!

PPParser subclass: #PPUnresolvedParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPUnresolvedParser guid: (GUID fromString: '{c53bb429-58ef-4861-b072-ac8ec0f031d5}')!
PPUnresolvedParser comment: ''!
!PPUnresolvedParser categoriesForClass!Unclassified! !
!PPUnresolvedParser methodsFor!

displayColor
	^ Color red!

isUnresolved
	^ true!

parseOn: aStream
	self error: self printString , ' need to be resolved before execution.'! !
!PPUnresolvedParser categoriesFor: #displayColor!*petitgui-accessing!public! !
!PPUnresolvedParser categoriesFor: #isUnresolved!public!testing! !
!PPUnresolvedParser categoriesFor: #parseOn:!parsing!public! !

