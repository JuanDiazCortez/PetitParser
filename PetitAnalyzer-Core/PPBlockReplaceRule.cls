"Filed out from Dolphin Smalltalk 7"!

PPReplaceRule subclass: #PPBlockReplaceRule
	instanceVariableNames: 'replaceBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPBlockReplaceRule guid: (GUID fromString: '{fd22418c-30d6-4797-953d-6ed89609aa8b}')!
PPBlockReplaceRule comment: ''!
!PPBlockReplaceRule categoriesForClass!Unclassified! !
!PPBlockReplaceRule methodsFor!

foundMatchFor: aParser 
	^ replaceBlock cull: aParser!

setReplaceBlock: aBlock
	replaceBlock := aBlock! !
!PPBlockReplaceRule categoriesFor: #foundMatchFor:!matching!public! !
!PPBlockReplaceRule categoriesFor: #setReplaceBlock:!initialization!public! !

!PPBlockReplaceRule class methodsFor!

searchFor: aSearchParser replaceWith: aReplaceBlock when: aVerificationBlock
	^ (self searchFor: aSearchParser) 
		setReplaceBlock: aReplaceBlock;
		setVerificationBlock: aVerificationBlock;
		yourself! !
!PPBlockReplaceRule class categoriesFor: #searchFor:replaceWith:when:!instance creation!public! !

