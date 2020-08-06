"Filed out from Dolphin Smalltalk 7"!

PPAbstractParserTest subclass: #PPSearcherTest
	instanceVariableNames: 'searcher'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPSearcherTest guid: (GUID fromString: '{4ff76f11-6832-44cb-a2ba-ba05b4ff481b}')!
PPSearcherTest comment: ''!
!PPSearcherTest categoriesForClass!Unclassified! !
!PPSearcherTest methodsFor!

setUp
	searcher := PPSearcher new!

testAnyPattern
	| result |
	searcher
		matches: PPPattern any
		do: [ :parser :answer | answer add: parser; yourself ].

	result := searcher
		execute: ($a asParser)
		initialAnswer: OrderedCollection new.
	self assert: result size = 1.
	
	result := searcher
		execute: ($a asParser star)
		initialAnswer: OrderedCollection new.
	self assert: result size = 2.
	
	result := searcher
		execute: ($a asParser , $b asParser)
		initialAnswer: OrderedCollection new.
	self assert: result size = 3!

testClassPattern
	| result |
	searcher 
		matches: (PPPattern class: PPLiteralObjectParser)
		do: [ :parser :answer | answer add: parser; yourself ].

	result := searcher
		execute: ($a asParser)
		initialAnswer: OrderedCollection new.
	self assert: result size = 1.
	self assert: (result allSatisfy: [ :each | each class = PPLiteralObjectParser ]).
	
	result := searcher
		execute: ('abc' asParser)
		initialAnswer: OrderedCollection new.
	self assert: result isEmpty.
	
	result := searcher
		execute: (#any asParser)
		initialAnswer: OrderedCollection new.
	self assert: result isEmpty.
	
	result := searcher
		execute: ($a asParser / #any asParser , $b asParser)
		initialAnswer: OrderedCollection new.
	self assert: result size = 2.
	self assert: (result allSatisfy: [ :each | each class = PPLiteralObjectParser ])!

testCopyMatchAction
	| old new |
	old := $a asParser ==> [ :token | $b ].
	new := old copyInContext: Dictionary new.
	self assert: (old match: old inContext: Dictionary new).
	self assert: (old match: new inContext: Dictionary new).
	self deny: (old == new).!

testCopyMatchDelegate
	| old new |
	old := $a asParser token trim.
	new := old copyInContext: Dictionary new.
	self assert: (old match: old inContext: Dictionary new).
	self assert: (old match: new inContext: Dictionary new).
	self deny: (old == new).!

testCopyMatchEpsilon
	| old new |
	old := nil asParser.
	new := old copyInContext: Dictionary new.
	self assert: (old match: old inContext: Dictionary new).
	self assert: (old match: new inContext: Dictionary new).
	self deny: (old == new).!

testCopyMatchFailure
	| old new |
	old := PPFailingParser message: 'problem'.
	new := old copyInContext: Dictionary new.
	self assert: (old match: old inContext: Dictionary new).
	self assert: (old match: new inContext: Dictionary new).
	self deny: (old == new).!

testCopyMatchList
	| old new |
	old := $a asParser , $b asParser , $c asParser.
	new := old copyInContext: Dictionary new.
	self assert: (old match: old inContext: Dictionary new).
	self assert: (old match: new inContext: Dictionary new).
	self deny: (old == new).!

testCopyMatchLiteral
	| old new |
	old := $a asParser.
	new := old copyInContext: Dictionary new.
	self assert: (old match: old inContext: Dictionary new).
	self assert: (old match: new inContext: Dictionary new).
	self deny: (old == new).!

testCopyMatchPluggable
	| old new |
	old := [ :stream | ] asParser.
	new := old copyInContext: Dictionary new.
	self assert: (old match: old inContext: Dictionary new).
	self assert: (old match: new inContext: Dictionary new).
	self deny: (old == new).!

testCopyMatchPredicate
	| old new |
	old := #word asParser.
	new := old copyInContext: Dictionary new.
	self assert: (old match: old inContext: Dictionary new).
	self assert: (old match: new inContext: Dictionary new).
	self deny: (old == new).!

testCopyMatchPredicateSequence
	| old new |
	old := 'foo' asParser caseInsensitive.
	new := old copyInContext: Dictionary new.
	self assert: (old match: old inContext: Dictionary new).
	self assert: (old match: new inContext: Dictionary new).
	self deny: (old == new).!

testCopyMatchRecursiveDelegate
	| old new |
	old := PPDelegateParser new.
	old setParser: old.
	new := old copyInContext: Dictionary new.
	self assert: (old match: old inContext: Dictionary new).
	self assert: (old match: new inContext: Dictionary new).
	self deny: (old == new).!

testCopyMatchRecursiveList
	| old new |
	old := PPChoiceParser new.
	old setParsers: (Array with: old).
	new := old copyInContext: Dictionary new.
	self assert: (old match: old inContext: Dictionary new).
	self assert: (old match: new inContext: Dictionary new).
	self deny: (old == new).!

testCopyMatchRepetition
	| old new |
	old := #word asParser star.
	new := old copyInContext: Dictionary new.
	self assert: (old match: old inContext: Dictionary new).
	self assert: (old match: new inContext: Dictionary new).
	self deny: (old == new).!

testCopyMatchRepetitionGreedy
	| old new |
	old := #word asParser starGreedy: #digit asParser.
	new := old copyInContext: Dictionary new.
	self assert: (old match: old inContext: Dictionary new).
	self assert: (old match: new inContext: Dictionary new).
	self deny: (old == new).!

testCopyMatchRepetitionLazy
	| old new |
	old := #word asParser starLazy: #digit asParser.
	new := old copyInContext: Dictionary new.
	self assert: (old match: old inContext: Dictionary new).
	self assert: (old match: new inContext: Dictionary new).
	self deny: (old == new).!

testCopyMatchRepetitionMinMax
	| old new |
	old := #word asParser min: 5 max: 10.
	new := old copyInContext: Dictionary new.
	self assert: (old match: old inContext: Dictionary new).
	self assert: (old match: new inContext: Dictionary new).
	self deny: (old == new).!

testKindPattern
	| result |
	searcher 
		matches: (PPPattern kind: PPLiteralParser)
		do: [ :parser :answer | answer add: parser; yourself ].

	result := searcher
		execute: ($a asParser)
		initialAnswer: OrderedCollection new.
	self assert: result size = 1.
	self assert: (result allSatisfy: [ :each | each class = PPLiteralObjectParser ]).
	
	result := searcher
		execute: ('abc' asParser)
		initialAnswer: OrderedCollection new.
	self assert: result size = 1.
	self assert: (result allSatisfy: [ :each | each class = PPLiteralSequenceParser ]).
	
	result := searcher
		execute: (#any asParser)
		initialAnswer: OrderedCollection new.
	self assert: result isEmpty.
	
	result := searcher
		execute: ($a asParser / #any asParser , $b asParser)
		initialAnswer: OrderedCollection new.
	self assert: result size = 2.
	self assert: (result allSatisfy: [ :each | each class = PPLiteralObjectParser ])!

testListInfix
	| result |
	searcher
		matches: PPListPattern any , $a asParser , PPListPattern any
		do: [ :parser :answer | true ].
	
	result := searcher
		execute: $a asParser , $a asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $a asParser , $b asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $b asParser , $a asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $b asParser , $b asParser
		initialAnswer: false.
	self deny: result.
	
	result := searcher
		execute: $a asParser , $a asParser , $a asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $b asParser , $a asParser , $a asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $a asParser , $b asParser , $a asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $a asParser , $a asParser , $b asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $b asParser , $b asParser , $a asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $a asParser , $b asParser , $b asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $b asParser , $a asParser , $b asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $b asParser , $b asParser , $b asParser
		initialAnswer: false.
	self deny: result!

testListPostfix
	| result |
	searcher
		matches: PPListPattern any , $b asParser
		do: [ :parser :answer | true ].
	
	result := searcher
		execute: $a asParser , $a asParser
		initialAnswer: false.
	self deny: result.
	
	result := searcher
		execute: $a asParser , $b asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $b asParser , $a asParser
		initialAnswer: false.
	self deny: result.
	
	result := searcher
		execute: $b asParser , $b asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $a asParser , $a asParser , $a asParser
		initialAnswer: false.
	self deny: result.
	
	result := searcher
		execute: $b asParser , $a asParser , $a asParser
		initialAnswer: false.
	self deny: result.
	
	result := searcher
		execute: $a asParser , $b asParser , $a asParser
		initialAnswer: false.
	self deny: result.
	
	result := searcher
		execute: $a asParser , $a asParser , $b asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $b asParser , $b asParser , $a asParser
		initialAnswer: false.
	self deny: result.
	
	result := searcher
		execute: $a asParser , $b asParser , $b asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $b asParser , $a asParser , $b asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $b asParser , $b asParser , $b asParser
		initialAnswer: false.
	self assert: result!

testListPrefix
	| result |
	searcher
		matches: $a asParser , PPListPattern any
		do: [ :parser :answer | true ].
	
	result := searcher
		execute: $a asParser , $a asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $a asParser , $b asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $b asParser , $a asParser
		initialAnswer: false.
	self deny: result.
	
	result := searcher
		execute: $b asParser , $b asParser
		initialAnswer: false.
	self deny: result.
	
	
	
	result := searcher
		execute: $a asParser , $a asParser , $a asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $b asParser , $a asParser , $a asParser
		initialAnswer: false.
	self deny: result.
	
	result := searcher
		execute: $a asParser , $b asParser , $a asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $a asParser , $a asParser , $b asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $b asParser , $b asParser , $a asParser
		initialAnswer: false.
	self deny: result.
	
	result := searcher
		execute: $a asParser , $b asParser , $b asParser
		initialAnswer: false.
	self assert: result.
	
	result := searcher
		execute: $b asParser , $a asParser , $b asParser
		initialAnswer: false.
	self deny: result.
	
	result := searcher
		execute: $b asParser , $b asParser , $b asParser
		initialAnswer: false.
	self deny: result!

testMatchesAny
	| result |
	searcher
		matchesAnyOf: (Array 
			with: $a asParser
			with: $b asParser)
		do: [ :parser :answer | answer add: parser; yourself ].

	result := searcher
		execute: $a asParser , $b asParser , $c asParser
		initialAnswer: OrderedCollection new.
	
	self assert: result size = 2.
	self assert: result first literal = $a.
	self assert: result last literal = $b!

testMultiplePattern
	| result |
	searcher matches: $a asParser
		do: 
			[:parser :answer |
			answer first add: parser.
			answer].
	searcher matches: PPPattern any
		do: 
			[:parser :answer |
			answer second add: parser.
			answer].
	result := searcher execute: $a asParser , $a asParser , $b asParser
				initialAnswer: (Array with: OrderedCollection new with: OrderedCollection new).
	self assert: result first size = 2.
	self assert: result first first literal = $a.
	self assert: result first last literal = $a.
	self assert: result last size = 2.
	self assert: result last first class = PPSequenceParser.
	self assert: result last last literal = $b!

testNamePattern
	| result |
	searcher 
		matches: (PPPattern name: 'foo')
		do: [ :parser :answer | answer add: parser; yourself ].

	result := searcher 
		execute: ($a asParser)
		initialAnswer: OrderedCollection new.
	self assert: result isEmpty.
	
	result := searcher
		execute: ($a asParser name: 'foo')
		initialAnswer: OrderedCollection new.
	self assert: result size = 1.
	self assert: result first name = 'foo'.
	
	result := searcher
		execute: ($a asParser name: 'bar') , ($b asParser name: 'foo')
		initialAnswer: OrderedCollection new.
	self assert: result size = 1.
	self assert: result first name = 'foo'!

testNewPattern
	self 
		should: [ PPPattern new ]
		raise: Error!

testRecursivePattern
	| recursive |
	recursive := PPDelegateParser new.
	recursive setParser: recursive.
	searcher 
		matches: recursive 
		do: [ :parser :answer | parser ].
	
	self assert: (searcher execute: recursive) = recursive.
	self assert: (searcher execute: $a asParser) isNil.
	self assert: (searcher execute: $a asParser / $b asParser star) isNil!

testRepeatedPattern
	| pattern result |
	searcher
		matches: (pattern := PPPattern any) , pattern
		do: [ :parser :answer | answer add: parser; yourself ].

	result := searcher
		execute: ($a asParser , $b asParser)
		initialAnswer: OrderedCollection new.
	self assert: result isEmpty.
	
	result := searcher
		execute: $a asParser , $a asParser
		initialAnswer: OrderedCollection new.
	self assert: result size = 1.
	
	result := searcher
		execute: ($a asParser , ($a asParser , $b asParser))
		initialAnswer: OrderedCollection new.
	self assert: result isEmpty.
	
	result := searcher
		execute: ($b asParser , ($a asParser , $a asParser))
		initialAnswer: OrderedCollection new.
	self assert: result size = 1! !
!PPSearcherTest categoriesFor: #setUp!public!running! !
!PPSearcherTest categoriesFor: #testAnyPattern!public!testing! !
!PPSearcherTest categoriesFor: #testClassPattern!public!testing! !
!PPSearcherTest categoriesFor: #testCopyMatchAction!public!testing-copy! !
!PPSearcherTest categoriesFor: #testCopyMatchDelegate!public!testing-copy! !
!PPSearcherTest categoriesFor: #testCopyMatchEpsilon!public!testing-copy! !
!PPSearcherTest categoriesFor: #testCopyMatchFailure!public!testing-copy! !
!PPSearcherTest categoriesFor: #testCopyMatchList!public!testing-copy! !
!PPSearcherTest categoriesFor: #testCopyMatchLiteral!public!testing-copy! !
!PPSearcherTest categoriesFor: #testCopyMatchPluggable!public!testing-copy! !
!PPSearcherTest categoriesFor: #testCopyMatchPredicate!public!testing-copy! !
!PPSearcherTest categoriesFor: #testCopyMatchPredicateSequence!public!testing-copy! !
!PPSearcherTest categoriesFor: #testCopyMatchRecursiveDelegate!public!testing-copy! !
!PPSearcherTest categoriesFor: #testCopyMatchRecursiveList!public!testing-copy! !
!PPSearcherTest categoriesFor: #testCopyMatchRepetition!public!testing-copy! !
!PPSearcherTest categoriesFor: #testCopyMatchRepetitionGreedy!public!testing-copy! !
!PPSearcherTest categoriesFor: #testCopyMatchRepetitionLazy!public!testing-copy! !
!PPSearcherTest categoriesFor: #testCopyMatchRepetitionMinMax!public!testing-copy! !
!PPSearcherTest categoriesFor: #testKindPattern!public!testing! !
!PPSearcherTest categoriesFor: #testListInfix!public!testing-lists! !
!PPSearcherTest categoriesFor: #testListPostfix!public!testing-lists! !
!PPSearcherTest categoriesFor: #testListPrefix!public!testing-lists! !
!PPSearcherTest categoriesFor: #testMatchesAny!public!testing! !
!PPSearcherTest categoriesFor: #testMultiplePattern!public!testing! !
!PPSearcherTest categoriesFor: #testNamePattern!public!testing! !
!PPSearcherTest categoriesFor: #testNewPattern!public!testing! !
!PPSearcherTest categoriesFor: #testRecursivePattern!public!testing! !
!PPSearcherTest categoriesFor: #testRepeatedPattern!public!testing! !

