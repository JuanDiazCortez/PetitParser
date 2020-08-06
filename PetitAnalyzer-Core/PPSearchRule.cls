"Filed out from Dolphin Smalltalk 7"!

PPRule subclass: #PPSearchRule
	instanceVariableNames: 'answerBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPSearchRule guid: (GUID fromString: '{2019db2b-0fc9-4a16-9365-b03dd1e01c88}')!
PPSearchRule comment: ''!
!PPSearchRule categoriesForClass!Unclassified! !
!PPSearchRule methodsFor!

canMatch: aParser
	owner setAnswer: (answerBlock cull: aParser cull: owner answer).
	^ super canMatch: aParser!

foundMatchFor: aParser 
	^ aParser!

setAnswerBlock: aBlock
	answerBlock := aBlock! !
!PPSearchRule categoriesFor: #canMatch:!matching!public! !
!PPSearchRule categoriesFor: #foundMatchFor:!matching!public! !
!PPSearchRule categoriesFor: #setAnswerBlock:!initialization!public! !

!PPSearchRule class methodsFor!

searchFor: aParser thenDo: aBlock
	^ (self searchFor: aParser) setAnswerBlock: aBlock! !
!PPSearchRule class categoriesFor: #searchFor:thenDo:!instance creation!public! !

