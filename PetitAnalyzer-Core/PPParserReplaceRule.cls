"Filed out from Dolphin Smalltalk 7"!

PPReplaceRule subclass: #PPParserReplaceRule
	instanceVariableNames: 'replaceParser'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPParserReplaceRule guid: (GUID fromString: '{caf635f9-3101-42c0-8644-ec8e7391a787}')!
PPParserReplaceRule comment: ''!
!PPParserReplaceRule categoriesForClass!Unclassified! !
!PPParserReplaceRule methodsFor!

foundMatchFor: aParser 
	^ replaceParser copyInContext: owner context!

setReplaceParser: aParser
	replaceParser := aParser! !
!PPParserReplaceRule categoriesFor: #foundMatchFor:!matching!public! !
!PPParserReplaceRule categoriesFor: #setReplaceParser:!initialization!public! !

!PPParserReplaceRule class methodsFor!

searchFor: aSearchParser replaceWith: aReplaceParser when: aVerificationBlock
	^ (self searchFor: aSearchParser) 
		setReplaceParser: aReplaceParser;
		setVerificationBlock: aVerificationBlock;
		yourself! !
!PPParserReplaceRule class categoriesFor: #searchFor:replaceWith:when:!instance creation!public! !

