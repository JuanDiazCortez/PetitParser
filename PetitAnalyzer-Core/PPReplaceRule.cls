"Filed out from Dolphin Smalltalk 7"!

PPRule subclass: #PPReplaceRule
	instanceVariableNames: 'verificationBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPReplaceRule guid: (GUID fromString: '{2dcc0459-8415-4da0-9818-4395ab469a03}')!
PPReplaceRule comment: ''!
!PPReplaceRule categoriesForClass!Unclassified! !
!PPReplaceRule methodsFor!

canMatch: aParser 
	^ verificationBlock cull: aParser!

initialize
	super initialize.
	verificationBlock := [ :parser | true ]!

setVerificationBlock: aBlock
	verificationBlock := aBlock! !
!PPReplaceRule categoriesFor: #canMatch:!matching!public! !
!PPReplaceRule categoriesFor: #initialize!initialization!public! !
!PPReplaceRule categoriesFor: #setVerificationBlock:!initialization!public! !

