"Filed out from Dolphin Smalltalk 7"!

Object subclass: #PPProcessor
	instanceVariableNames: 'searches context'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPProcessor guid: (GUID fromString: '{d51e0a13-417e-46f5-abd4-d84e8630e139}')!
PPProcessor comment: ''!
!PPProcessor categoriesForClass!Unclassified! !
!PPProcessor methodsFor!

addRule: aGrammarRule
	searches add: (aGrammarRule setOwner: self)!

context
	^ context!

initialize
	super initialize.
	searches := OrderedCollection new.
	context := Dictionary new!

performRule: aRule on: aParser
	context := Dictionary new.
	^ aRule performOn: aParser!

performRulesOn: aParser
	| result |
	searches do: [ :rule |
		result := self performRule: rule on: aParser.
		result notNil ifTrue: [ ^ result ] ].
	^ nil! !
!PPProcessor categoriesFor: #addRule:!public!rules! !
!PPProcessor categoriesFor: #context!private! !
!PPProcessor categoriesFor: #initialize!initialization!public! !
!PPProcessor categoriesFor: #performRule:on:!private! !
!PPProcessor categoriesFor: #performRulesOn:!private! !

!PPProcessor class methodsFor!

new
	^ self basicNew initialize! !
!PPProcessor class categoriesFor: #new!instance creation!public! !

