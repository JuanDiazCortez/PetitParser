"Filed out from Dolphin Smalltalk 7"!

PPParser subclass: #PPPattern
	instanceVariableNames: 'verificationBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPPattern guid: (GUID fromString: '{f0f868bd-9b3a-42e4-b5c7-4e2fb5c83d9e}')!
PPPattern comment: ''!
!PPPattern categoriesForClass!Unclassified! !
!PPPattern methodsFor!

= aParser
	^ self == aParser or: [ self name notNil and: [ self name = aParser name ] ]!

copyInContext: aDictionary seen: aSeenDictionary
	^ aDictionary at: self!

hash
	^ self identityHash!

initializeOn: aBlock
	verificationBlock := aBlock!

match: aParser inContext: aDictionary seen: anIdentitySet
	(verificationBlock value: aParser value: aDictionary)
		ifFalse: [ ^ false ].
	^ (aDictionary at: self ifAbsentPut: [ aParser ])
		match: aParser inContext: aDictionary seen: anIdentitySet!

parseOn: aStream
	"This is just a pattern used for matching. It should not be used in actual grammars."

	self shouldNotImplement! !
!PPPattern categoriesFor: #=!comparing!public! !
!PPPattern categoriesFor: #copyInContext:seen:!matching!public! !
!PPPattern categoriesFor: #hash!comparing!public! !
!PPPattern categoriesFor: #initializeOn:!initialization!public! !
!PPPattern categoriesFor: #match:inContext:seen:!matching!public! !
!PPPattern categoriesFor: #parseOn:!parsing!public! !

!PPPattern class methodsFor!

any
	"Matches all parsers."

	^ self on: [ :parser :context | true ]!

class: aBehavior
	"Matches parsers that are of the class aBehavior."

	^ self on: [ :parser :context | parser class = aBehavior ]!

kind: aBehavior
	"Matches parsers that are of the class aBehavior or one of its subclasses."

	^ self on: [ :parser :context | parser isKindOf: aBehavior ]!

name: aString
	"Matches parsers with the name aString."

	^ self on: [ :parser :context | parser name = aString ]!

new
	self error: 'Use an explicit constructur on ' , self name!

on: aBlock
	"Matches parsers that satisfy an arbitrary condition in aBlock."

	^ self basicNew initializeOn: aBlock! !
!PPPattern class categoriesFor: #any!instance creation!public! !
!PPPattern class categoriesFor: #class:!instance creation!public! !
!PPPattern class categoriesFor: #kind:!instance creation!public! !
!PPPattern class categoriesFor: #name:!instance creation!public! !
!PPPattern class categoriesFor: #new!instance creation!public! !
!PPPattern class categoriesFor: #on:!instance creation!public! !

