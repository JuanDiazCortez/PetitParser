"Filed out from Dolphin Smalltalk 7"!

PPDelegateParser subclass: #PPRepeatingParser
	instanceVariableNames: 'min max'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPRepeatingParser guid: (GUID fromString: '{7b5c0d58-2778-43f0-92f1-9d2430520e8d}')!
PPRepeatingParser comment: ''!
!PPRepeatingParser categoriesForClass!Unclassified! !
!PPRepeatingParser methodsFor!

followSets: aFollowDictionary firstSets: aFirstDictionary into: aSet
	| firstSet |
	super followSets: aFollowDictionary firstSets:  aFirstDictionary into: aSet.
	
	firstSet := aFirstDictionary at: self.
	self children do: [:p | (aFollowDictionary at: p) addAll: (firstSet reject: [:each | each isNullable]) ]!

initialize
	super initialize.
	self setMin: 0; setMax: SmallInteger maxVal!

isNullable
	^ min = 0!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self min = aParser min and: [ self max = aParser max ] ]!

max
	"Answer the maximum number of repetitions."

	^ max!

min
	"Answer the minimum number of repetitions."
	
	^ min!

printOn: aStream
	super printOn: aStream.
	aStream nextPutAll: ' ['; print: min; nextPutAll: ', '; nextPutAll: (max = SmallInteger maxVal
		ifTrue: [ '*' ] ifFalse: [ max printString ]); nextPut: $]!

setMax: anInteger
	max := anInteger!

setMin: anInteger
	min := anInteger! !
!PPRepeatingParser categoriesFor: #followSets:firstSets:into:!*PetitAnalyzer!public! !
!PPRepeatingParser categoriesFor: #initialize!initialization!public! !
!PPRepeatingParser categoriesFor: #isNullable!*petitanalyzer-testing!public! !
!PPRepeatingParser categoriesFor: #match:inContext:seen:!*petitanalyzer-matching!public! !
!PPRepeatingParser categoriesFor: #max!accessing!public! !
!PPRepeatingParser categoriesFor: #min!accessing!public! !
!PPRepeatingParser categoriesFor: #printOn:!printing!public! !
!PPRepeatingParser categoriesFor: #setMax:!initialization!public! !
!PPRepeatingParser categoriesFor: #setMin:!initialization!public! !

