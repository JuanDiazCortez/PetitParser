"Filed out from Dolphin Smalltalk 7"!

PPProcessor subclass: #PPSearcher
	instanceVariableNames: 'answer'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPSearcher guid: (GUID fromString: '{b3e9565a-d965-4af0-8174-a54b1fb8bb2e}')!
PPSearcher comment: ''!
!PPSearcher categoriesForClass!Unclassified! !
!PPSearcher methodsFor!

answer
	^ answer!

execute: aParser
	"Perform the search rules of the receiver on aParser. Answer the result of the search."

	^ self execute: aParser initialAnswer: nil!

execute: aParser initialAnswer: anObject
	"Perform the search rules of the receiver on aParser. Inject anObject into the matches and answer the result."

	| previous |
	previous := context.
	answer := anObject.
	context := Dictionary new.
	aParser allParsersDo: [ :each | 
		self performRulesOn: each ].
	context := previous.
	^ answer!

matches: aParser do: anAnswerBlock
	"Add a search expression aParser, evaluate anAnswerBlock with the matched node and the previous answer."

	self addRule: (PPSearchRule searchFor: aParser thenDo: anAnswerBlock)!

matchesAnyOf: aCollectionOfParsers do: anAnswerBlock
	"Add a collection of search expressions aCollectionOfParsers, evaluate anAnswerBlock with the matched node and the previous answer."
	
	aCollectionOfParsers
		do: [ :each | self matches: each do: anAnswerBlock ]!

setAnswer: anObject
	answer := anObject! !
!PPSearcher categoriesFor: #answer!private! !
!PPSearcher categoriesFor: #execute:!public! !
!PPSearcher categoriesFor: #execute:initialAnswer:!public! !
!PPSearcher categoriesFor: #matches:do:!public!rules! !
!PPSearcher categoriesFor: #matchesAnyOf:do:!public!rules! !
!PPSearcher categoriesFor: #setAnswer:!initialization!public! !

