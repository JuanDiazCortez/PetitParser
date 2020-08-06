"Filed out from Dolphin Smalltalk 7"!

PPProcessor subclass: #PPRewriter
	instanceVariableNames: 'changed'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPRewriter guid: (GUID fromString: '{936927cf-cf39-4473-b708-6908f5f7c322}')!
PPRewriter comment: ''!
!PPRewriter categoriesForClass!Unclassified! !
!PPRewriter methodsFor!

execute: aParser
	"Perform the replace rules of the receiver on aParser, answer the resulting parser."

	| previous result |
	previous := context.
	changed := false.
	context := Dictionary new.
	result := aParser transform: [ :each |
		| transformed |
		transformed := self performRulesOn: each.
		transformed isNil
			ifTrue: [ each ]
			ifFalse: [ changed := true. transformed ] ].
	context := previous.
	^ result!

hasChanged
	"Answer if the last operation has changed anything."
	
	^ changed!

initialize
	super initialize.
	changed := false!

replace: aSearchParser with: aReplaceParser
	self replace: aSearchParser with: aReplaceParser when: [ :node | true ]!

replace: aSearchParser with: aReplaceParser when: aValidationBlock
	self addRule: (PPParserReplaceRule searchFor: aSearchParser replaceWith: aReplaceParser when: aValidationBlock)!

replace: aSearchParser withValueFrom: aReplaceBlock
	self replace: aSearchParser withValueFrom: aReplaceBlock when: [ :node | true ]!

replace: aSearchParser withValueFrom: aReplaceBlock when: aValidationBlock
	self addRule: (PPBlockReplaceRule searchFor: aSearchParser replaceWith: aReplaceBlock when: aValidationBlock)! !
!PPRewriter categoriesFor: #execute:!public! !
!PPRewriter categoriesFor: #hasChanged!public!testing! !
!PPRewriter categoriesFor: #initialize!initialization!public! !
!PPRewriter categoriesFor: #replace:with:!accessing!public! !
!PPRewriter categoriesFor: #replace:with:when:!accessing!public! !
!PPRewriter categoriesFor: #replace:withValueFrom:!accessing!public! !
!PPRewriter categoriesFor: #replace:withValueFrom:when:!accessing!public! !

