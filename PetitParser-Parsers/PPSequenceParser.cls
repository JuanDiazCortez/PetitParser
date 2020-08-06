"Filed out from Dolphin Smalltalk 7"!

PPListParser subclass: #PPSequenceParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPSequenceParser guid: (GUID fromString: '{ff94e99b-3f62-4122-aa75-7ab512e4e8cc}')!
PPSequenceParser comment: ''!
!PPSequenceParser categoriesForClass!Unclassified! !
!PPSequenceParser methodsFor!

, aRule
	^ self copyWith: aRule!

cycleSet: aDictionary
	| firstSet |
	1 to: parsers size do: [ :index |
		firstSet := aDictionary at: (parsers at: index).
		(firstSet anySatisfy: [ :each | each isNullable ])
			ifFalse: [ ^ parsers copyFrom: 1 to: index ] ].
	^ parsers!

firstSets: aFirstDictionary into: aSet
	| nullable |
	parsers do: [ :parser |
		nullable := false.
		(aFirstDictionary at: parser) do: [ :each |
			each isNullable
				ifTrue: [ nullable := true ]
				ifFalse: [ aSet add: each ] ].
		nullable
			ifFalse: [ ^ self ] ].
	aSet add:(Smalltalk at: #PPSentinel) instance !

followSets: aFollowDictionary firstSets: aFirstDictionary into: aSet
	parsers keysAndValuesDo: [ :index :parser |
		| followSet firstSet |
		followSet := aFollowDictionary at: parser.
		index = parsers size
			ifTrue: [ followSet addAll: aSet ]
			ifFalse: [
				(self class withAll: (parsers 
					copyFrom: index + 1 to: parsers size))
						firstSets: aFirstDictionary
						into: (firstSet := IdentitySet new).
				(firstSet anySatisfy: [ :each | each isNullable ])
					ifTrue: [ followSet addAll: aSet ].
				followSet addAll: (firstSet 
					reject: [ :each | each isNullable ]) ] ]!

map: aBlock
	^ aBlock numArgs = self children size
		ifTrue: [ self ==> [ :nodes | aBlock valueWithArguments: nodes ] ]
		ifFalse: [ self error: aBlock numArgs asString , ' arguments expected.' ]!

parseOn: aStream
	"This is optimized code that avoids unnecessary block activations, do not change."
	
	| start elements element |
	start := aStream position.
	elements := Array new: parsers size.
	1 to: parsers size do: [ :index |
		element := (parsers at: index) 
			parseOn: aStream.
		element isPetitFailure ifTrue: [
			aStream position: start.
			^ element ].
		elements at: index put: element ].
	^ elements!

permutation: anArrayOfIntegers
	"Answer a permutation of the receivers sequence."
	
	anArrayOfIntegers do: [ :index |
		(index isInteger and: [ index between: 1 and: parsers size ])
			ifFalse: [ self error: 'Invalid permutation index: ' , index printString ] ].
	^ self ==> [ :nodes | anArrayOfIntegers collect: [ :index | nodes at: index ] ]! !
!PPSequenceParser categoriesFor: #,!operators!public! !
!PPSequenceParser categoriesFor: #cycleSet:!*petitanalyzer-private!public! !
!PPSequenceParser categoriesFor: #firstSets:into:!*petitanalyzer-private!public! !
!PPSequenceParser categoriesFor: #followSets:firstSets:into:!*petitanalyzer-private!public! !
!PPSequenceParser categoriesFor: #map:!operators-mapping!public! !
!PPSequenceParser categoriesFor: #parseOn:!parsing!public! !
!PPSequenceParser categoriesFor: #permutation:!operators-mapping!public! !

