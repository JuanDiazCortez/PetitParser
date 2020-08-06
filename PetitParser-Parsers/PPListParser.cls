"Filed out from Dolphin Smalltalk 7"!

PPParser subclass: #PPListParser
	instanceVariableNames: 'parsers'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPListParser guid: (GUID fromString: '{99d4a818-c404-4b34-a7ec-5d44e381b9e9}')!
PPListParser comment: ''!
!PPListParser categoriesForClass!Unclassified! !
!PPListParser methodsFor!

children
	^ parsers!

copyInContext: aDictionary seen: aSeenDictionary
	| copy copies |
	aSeenDictionary at: self ifPresent: [ :value | ^ value ].
	copy := aSeenDictionary at: self put: self copy.
	copies := OrderedCollection new.
	parsers do: [ :each |
		| result |
		result := each 
			copyInContext: aDictionary
			seen: aSeenDictionary.
		result isCollection
			ifTrue: [ copies addAll: result ]
			ifFalse: [ copies add: result ] ].
	^ copy
		setParsers: copies;
		yourself!

copyWith: aParser
	^ self species withAll: (parsers copyWith: aParser)!

initialize
	super initialize.
	self setParsers: #()!

postCopy
	super postCopy.
	parsers := parsers copy!

replace: aParser with: anotherParser
	super replace: aParser with: anotherParser.
	parsers keysAndValuesDo: [ :index :parser |
		parser == aParser
			ifTrue: [ parsers at: index put: anotherParser ] ]!

setParsers: aCollection
	parsers := aCollection asArray! !
!PPListParser categoriesFor: #children!accessing!public! !
!PPListParser categoriesFor: #copyInContext:seen:!*petitanalyzer-matching!public! !
!PPListParser categoriesFor: #copyWith:!copying!public! !
!PPListParser categoriesFor: #initialize!initialization!public! !
!PPListParser categoriesFor: #postCopy!copying!public! !
!PPListParser categoriesFor: #replace:with:!*petitanalyzer-transforming!public! !
!PPListParser categoriesFor: #setParsers:!initialization!public! !

!PPListParser class methodsFor!

with: aParser
	^ self withAll: (Array with: aParser)!

with: aFirstParser with: aSecondParser
	^ self withAll: (Array with: aFirstParser with: aSecondParser)!

withAll: aCollection
	^ self basicNew setParsers: aCollection! !
!PPListParser class categoriesFor: #with:!instance creation!public! !
!PPListParser class categoriesFor: #with:with:!instance creation!public! !
!PPListParser class categoriesFor: #withAll:!instance creation!public! !

