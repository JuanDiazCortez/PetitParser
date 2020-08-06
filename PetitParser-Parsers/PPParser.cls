"Filed out from Dolphin Smalltalk 7"!

Object subclass: #PPParser
	instanceVariableNames: 'properties'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPParser guid: (GUID fromString: '{0391e4db-b002-4f5e-ab41-3c368e1a86ce}')!
PPParser comment: ''!
!PPParser categoriesForClass!Unclassified! !
!PPParser methodsFor!

, aParser 
	"Answer a new parser that parses the receiver followed by aParser."

	^ PPSequenceParser with: self with: aParser!

/ aParser 
	"Answer a new parser that parses the receiver, if the receiver fails try with aParser (ordered-choice)."
	
	^ PPChoiceParser with: self with: aParser!

| aParser
	"Answer a new parser that either parses the receiver or aParser. Fail if both pass or fail (exclusive choice, unordered choice)."

	^ (self not , aParser) / (aParser not , self) ==> #second!

==> aBlock
	"Answer a new parser that performs aBlock as action handler on success."

	^ PPActionParser on: self block: aBlock!

>=> aBlock
	"Answer a new parser that wraps the receiving parser with a two argument block. The first argument is the parsed stream, the second argument a continuation block on the delegate parser."

	^ PPWrappingParser on: self block: aBlock!

allNamedParsers
	"Answer all the named parse nodes of the receiver."

	| result |
	result := OrderedCollection new.
	self allNamedParsersDo: [ :parser | result addLast: parser ].
	^ result!

allNamedParsersDo: aBlock
	"Iterate over all the named parse nodes of the receiver."

	self allParsersDo: [ :each | 
		each name notNil
			ifTrue: [ aBlock value: each ] ]!

allParsers
	"Answer all the parse nodes of the receiver."

	| result |
	result := OrderedCollection new.
	self allParsersDo: [ :parser | result addLast: parser ].
	^ result!

allParsersDo: aBlock
	"Iterate over all the parse nodes of the receiver."

	self allParsersDo: aBlock seen: IdentitySet new!

allParsersDo: aBlock seen: aSet
	"Iterate over all the parse nodes of the receiver, do not visit and follow the ones contained in aSet."

	(aSet includes: self)
		ifTrue: [ ^ self ].
	aSet add: self.
	aBlock value: self.
	self children
		do: [ :each | each asParser  allParsersDo: aBlock seen: aSet ]!

and
	"Answer a new parser (logical and-predicate) that succeeds whenever the receiver does, but never consumes input."

	^ PPAndParser on: self!

answer: anObject
	"Answer a new parser that always returns anObject from a successful parse."

	^ self ==> [ :nodes | anObject ]!

asParser
	"Answer the receiving parser."
	
	^ self!

becomeForward: aObject

	^ self oneWayBecome: aObject!

children
	"Answer a set of child parsers that could follow the receiver."

	^ #()!

copyInContext: aDictionary
	^ self copyInContext: aDictionary seen: IdentityDictionary new!

copyInContext: aDictionary seen: aSeenDictionary
	| copy |
	aSeenDictionary 
		at: self 
		ifPresent: [ :value | ^ value ].
	copy := aSeenDictionary
		at: self
		put: self copy.
	copy children do: [ :each |
		copy
			replace: each
			with: (each copyInContext: aDictionary seen: aSeenDictionary) ].
	^ copy!

cycleSet
	"Answer a set of all nodes that are within one or more cycles of left-recursion. This is generally not a problem if at least one of the nodes is memoized, but it might make the grammar very inefficient and should be avoided if possible."
	
	| cycles |
	cycles := IdentitySet new.
	self cycleSet: OrderedCollection new firstSets: self firstSets into: cycles.
	^ cycles!

cycleSet: aDictionary
	"PRIVATE: Answer the children that could be part of a cycle-set with the receiver, subclasses might restrict the number of children returned. aDictionary is pre-calcualted first-sets."

	^ self children!

cycleSet: aStack firstSets: aDictionary into: aSet
	"PRIVATE: Try to find a cycle, where aStack contains the previously visited parsers. The method returns quickly when the receiver is a terminal, terminals cannot be part of a cycle. If aStack already contains the receiver, then we are in a cycle. In this case we don't process the children further and add the nodes to aSet."

	| index |
	self isTerminal
		ifTrue: [ ^ self ].	
	(index := aStack indexOf: self) > 0
		ifTrue: [ ^ aSet addAll: (aStack copyFrom: index to: aStack size) ].
	aStack addLast: self.
	(self cycleSet: aDictionary)
		do: [ :each | each cycleSet: aStack firstSets: aDictionary into: aSet ].
	aStack removeLast!

def: aParser
	"Redefine the receiver as the argument aParser. This method is useful when defining recursive parsers: instantiate a PPUnresolvedParser and later redefine it with another one."

	^ self becomeForward: (aParser name: self name)!

delimitedBy: aParser
	"Answer a new parser that parses the receiver one or more times, separated and possibly ended by aParser."
	
	^ (self separatedBy: aParser) , (aParser optional) ==> [ :node |
		node second isNil
			ifTrue: [ node first ]
			ifFalse: [ node first copyWith: node second ] ]!

end
	"Answer a new parser that succeeds at the end of the input and return the result of the receiver."

	^ PPEndOfInputParser on: self!

firstSet
	"Answer the first-set of the receiver. Note, this implementation is inefficient when called on different receivers of the same grammar, instead use #firstSets to calculate the first-sets at once."
	
	^ self firstSets at: self!

firstSets
	"Answer a dictionary with all the parsers reachable from the receiver as key and their first-set as value. The first-set of a parser is the list of terminal parsers that begin the parser derivable from that parser."
	
	| firstSets |
	firstSets := IdentityDictionary new.
	self allParsersDo: [ :each |
		firstSets at: each put: (each isTerminal
			ifTrue: [ IdentitySet with: each ]
			ifFalse: [ IdentitySet new ]).
		each isNullable
			ifTrue: [ (firstSets at: each) add: self sentinelInstance ] ].
	[	| changed tally |
		changed := false.
		firstSets keysAndValuesDo: [ :parser :first |
			tally := first size.
			parser firstSets: firstSets into: first.
			changed := changed or: [ tally ~= first size ] ].
		changed ] whileTrue.
	^ firstSets!

firstSets: aFirstDictionary into: aSet
	"PRIVATE: Try to add additional elements to the first-set aSet of the receiver, use the incomplete aFirstDictionary."

	self children do: [ :parser | aSet addAll: (aFirstDictionary at: parser) ]!

flatten
	"Answer a new parser that flattens the underlying collection."
	
	^ PPFlattenParser on: self!

foldLeft: aBlock
	"Answer a new parser that that folds the result of the receiver from left-to-right into aBlock. The argument aBlock must take two or more arguments."
	
	| size args |
	size := aBlock numArgs.
	args := Array new: size.
	^ self ==> [ :nodes |
		args at: 1 put: nodes first.
		2 to: nodes size by: size - 1 do: [ :index |
			args
				replaceFrom: 2 to: size with: nodes startingAt: index;
				at: 1 put: (aBlock valueWithArguments: args) ].
		args first ]!

foldRight: aBlock
	"Answer a new parser that that folds the result of the receiver from right-to-left into aBlock. The argument aBlock must take two or more arguments."

	| size args |
	size := aBlock numArgs.
	args := Array new: size.
	^ self ==> [ :nodes |
		args at: size put: nodes last.
		nodes size - size + 1 to: 1 by: 1 - size do: [ :index |
			args
				replaceFrom: 1 to: size - 1 with: nodes startingAt: index;
				at: size put: (aBlock valueWithArguments: args) ].
		args at: size ]!

followSet
	"Answer the follow-set of the receiver starting at the receiver. Note, this implementation is inefficient when called on different receivers of the same grammar, instead use #followSets to calculate the follow-sets at once."

	^ self followSets at: self!

followSets
	"Answer a dictionary with all the parsers reachable from the receiver as key and their follow-set as value. The follow-set of a parser is the list of terminal parsers that can appear immediately to the right of that parser."
	
	| current previous continue firstSets followSets |
	current := previous := 0.
	firstSets := self firstSets.
	followSets := IdentityDictionary new.
	self allParsersDo: [ :each | followSets at: each put: IdentitySet new ].
	(followSets at: self) add: (Smalltalk  at:#PPSentinel) instance.
	[	followSets keysAndValuesDo: [ :parser :follow |
			parser 
				followSets: followSets
				firstSets: firstSets
				into: follow ].
		current := followSets
			inject: 0
			into: [ :result :each | result + each size ].
		continue := previous < current.
		previous := current.
		continue ] whileTrue.
	^ followSets!

followSets: aFollowDictionary firstSets: aFirstDictionary into: aSet
	"PRIVATE: Try to add additional elements to the follow-set aSet of the receiver, use the incomplete aFollowDictionary and the complete aFirstDictionary."
	
	self children do: [ :parser | (aFollowDictionary at: parser) addAll: aSet ]!

hasProperty: aKey
	"Test if the property aKey is present."
	
	^ properties notNil and: [ properties includesKey: aKey ]!

initialize!

innerChildren
	"Answer the inner children of the receiver."

	| result |
	result := OrderedCollection new.
	self innerChildrenDo: [ :parser | result addLast: parser ].
	^ result!

innerChildrenDo: aBlock
	"Iterate over the inner children of the receiver."

	self innerChildrenDo: aBlock seen: IdentitySet new!

innerChildrenDo: aBlock seen: aSet
	"Iterate over the inner children of the receiver."
	
	self children do: [ :each |
		(aSet includes: each)
			ifTrue: [ ^ self ].
		aSet add: each.
		each name isNil ifTrue: [
			aBlock value: each.
			each innerChildrenDo: aBlock seen: aSet ] ]!

isFirstSetTerminal
	"Answer true if the receiver is a terminal or leaf parser, that means it does not delegate to any other parser."

	^ self children isEmpty!

isNullable
	"Answer true if the receiver is a nullable parser, e.g. it can successfully parse nothing."
	
	^ false!

isPetitParser
	^ true!

isTerminal
	"Answer true if the receiver is a terminal or leaf parser, that means it does not delegate to any other parser."

	^ self children isEmpty!

isUnresolved
	^ false!

map: aBlock
	"Answer a new parser that works on the receiving sequence an passes in each element as a block argument."
	
	^ aBlock numArgs = 1
		ifTrue: [ self ==> aBlock ]
		ifFalse: [ self error: aBlock numArgs asString , ' arguments expected.' ]!

match: aParser inContext: aDictionary
	^ self match: aParser inContext: aDictionary seen: IdentitySet new!

match: aParser inContext: aDictionary seen: anIdentitySet
	"This is the default implementation to match two parsers. This code can properly handle recursion. This is code is supposed to be overridden in subclasses that add new state."

	(self == aParser or: [ anIdentitySet includes: self ])
		ifTrue: [ ^ true ].
	anIdentitySet add: self.
	^ self class = aParser class and: [ self matchList: self children against: aParser children inContext: aDictionary seen: anIdentitySet ]!

matches: anObject
	"Answer if anObject can be parsed by the receiver."
	
	^ (self parse: anObject) isPetitFailure not!

matchesIn: anObject
	"Search anObject repeatedly for the matches of the receiver. Answered an OrderedCollection of the matched parse-trees."

	| result |
	result := OrderedCollection new.
	self 
		matchesIn: anObject
		do: [ :each | result addLast: each ].
	^ result!

matchesIn: anObject do: aBlock
	"Search anObject repeatedly for the matches of the receiver. Evaluate aBlock for each match with the matched parse-tree as the argument. Make sure to always consume exactly one character with each step, to not miss any match."

	((self and ==> aBlock , #any asParser) / #any asParser) star parse: anObject!

matchesSkipIn: anObject
	"Search anObject repeatedly for the matches of the receiver. Answer an OrderedCollection of the matched parse-trees. Skip over matches."

	| result |
	result := OrderedCollection new.
	self 
		matchesSkipIn: anObject
		do: [ :each | result addLast: each ].
	^ result!

matchesSkipIn: anObject do: aBlock
	"Search anObject repeatedly for the matches of the receiver. Evaluate aBlock for each match with the matched parse-tree as the argument. Skip over matches."

	(self ==> aBlock / #any asParser) star parse: anObject!

matchingRangesIn: anObject
	"Search anObject repeatedly for the matches of the receiver. Answer an OrderedCollection of ranges of each match (index of first character to: index of last character)."
	
	| result |
	result := OrderedCollection new.
	self
		matchingRangesIn: anObject
		do: [ :value | result addLast: value ].
	^ result!

matchingRangesIn: anObject do: aBlock
	"Search anObject repeatedly for the matches of the receiver. Evaluate aBlock with the range of each match (index of first character to: index of last character)."

	self token
		matchesIn: anObject
		do: [ :token | aBlock value: (token start to: token stop) ]!

matchingSkipRangesIn: anObject
	"Search anObject repeatedly for the matches of the receiver. Skip over matches. Answer an OrderedCollection of ranges of each match (index of first character to: index of last character)."
	
	| result |
	result := OrderedCollection new.
	self
		matchingSkipRangesIn: anObject
		do: [ :value | result addLast: value ].
	^ result!

matchingSkipRangesIn: anObject do: aBlock
	"Search anObject repeatedly for the matches of the receiver. Skip over matches. Evaluate aBlock with the range of each match (index of first character to: index of last character)."
	
	self token
		matchesSkipIn: anObject
		do: [ :token | aBlock value: (token start to: token stop) ]!

matchList: matchList against: parserList inContext: aDictionary seen: aSet
	^ self matchList: matchList index: 1 against: parserList index: 1 inContext: aDictionary seen: aSet!

matchList: matchList index: matchIndex against: parserList index: parserIndex inContext: aDictionary seen: aSet
	| parser currentIndex currentDictionary currentSeen parsers |
	matchList size < matchIndex
		ifTrue: [ ^ parserList size < parserIndex ].
	parser := matchList at: matchIndex.
	parser class = (Smalltalk at:#PPListPattern) ifTrue: [
		currentIndex := parserIndex - 1.
		[ currentDictionary := aDictionary copy.
		currentSeen := aSet copy.
		parserList size < currentIndex or: [ 
			parsers := parserList copyFrom: parserIndex to: currentIndex.
			(currentDictionary at: parser ifAbsentPut: [ parsers ]) = parsers and: [ 
				(self
					matchList: matchList
					index: matchIndex + 1
					against: parserList
					index: currentIndex + 1
					inContext: currentDictionary
					seen: currentSeen)
					ifTrue: [ 
						currentDictionary keysAndValuesDo: [ :key :value | aDictionary at: key put: value ].
						^ true ].
				false ] ] ] whileFalse: [ currentIndex := currentIndex + 1 ].
		^ false ].
	parserList size < parserIndex
		ifTrue: [ ^ false ].
	(parser match: (parserList at: parserIndex) inContext: aDictionary seen: aSet)
		ifFalse: [ ^ false ].
	^ self
		matchList: matchList
		index: matchIndex + 1
		against: parserList
		index: parserIndex + 1
		inContext: aDictionary
		seen: aSet!

max: anInteger
	"Answer a new parser that parses the receiver at most anInteger times."
	
	^ self star setMax: anInteger!

max: anInteger greedy: aParser
	"Answer a new parser that parses the receiver at most anInteger times until it reaches aParser. This is a greedy non-blind implementation. aParser is not consumed."
	
	^ (self starGreedy: aParser) setMax: anInteger!

max: anInteger lazy: aParser
	"Answer a new parser that parses the receiver at most anInteger times until it reaches aParser. This is a lazy non-blind implementation. aParser is not consumed."
	
	^ (self starLazy: aParser) setMax: anInteger!

memoized
	"Answer a new memoized parser, for refraining redundant computations. This ensures polynomial time O(n^4) for left-recursive grammars and O(n^3) for non left-recursive grammars in the worst case. Not necessary for most grammars that are carefully written and in O(n) anyway."
	
	^ PPMemoizedParser on: self!

min: anInteger
	"Answer a new parser that parses the receiver at least anInteger times."
	
	^ self star setMin: anInteger!

min: anInteger greedy: aParser
	"Answer a new parser that parses the receiver at least anInteger times until it reaches aParser. This is a greedy non-blind implementation. aParser is not consumed."
	
	^ (self starGreedy: aParser) setMin: anInteger!

min: anInteger lazy: aParser
	"Answer a new parser that parses the receiver at least anInteger times until it reaches aParser. This is a lazy non-blind implementation. aParser is not consumed."
	
	^ (self starLazy: aParser) setMin: anInteger!

min: aMinInteger max: aMaxInteger
	"Answer a new parser that parses the receiver at least aMinInteger and at most aMaxInteger times."
	
	^ self star setMin: aMinInteger; setMax: aMaxInteger!

min: aMinInteger max: aMaxInteger greedy: aParser
	"Answer a new parser that parses the receiver at least aMinInteger and at most aMaxInteger times until it reaches aParser. This is a greedy non-blind implementation. aParser is not consumed."
	
	^ (self starGreedy: aParser) setMin: aMinInteger; setMax: aMaxInteger!

min: aMinInteger max: aMaxInteger lazy: aParser
	"Answer a new parser that parses the receiver at least aMinInteger and at most aMaxInteger times until it reaches aParser. This is a greedy non-blind implementation. aParser is not consumed."
	
	^ (self starLazy: aParser) setMin: aMinInteger; setMax: aMaxInteger!

name
	"Answer the production name of the receiver."
	
	^ self propertyAt: #name ifAbsent: [ nil ]!

name: aString
	self propertyAt: #name put: aString!

namedChildren
	"Answer the named children of the receiver."

	| result |
	result := OrderedCollection new.
	self namedChildrenDo: [ :parser | result addLast: parser ].
	^ result!

namedChildrenDo: aBlock
	"Iterate over the named children of the receiver."

	self namedChildrenDo: aBlock seen: IdentitySet new!

namedChildrenDo: aBlock seen: aSet
	"Iterate over the named children of the receiver."
	
	self children do: [ :each |
		(aSet includes: each)
			ifTrue: [ ^ self ].
		aSet add: each.
		each name isNil
			ifTrue: [ each namedChildrenDo: aBlock seen: aSet ]
			ifFalse: [ aBlock value: each ] ]!

negate
	"Answer a new parser consumes any input token but the receiver."
	
	^ self not , #any asParser ==> #second!

not
	"Answer a new parser (logical not-predicate) that succeeds whenever the receiver fails, but never consumes input."

	^ PPNotParser on: self!

optional
	"Answer a new parser that parses the receiver, if possible."

	^ PPOptionalParser on: self!

parse: anObject
	"Parse anObject with the receiving parser and answer the parse-result or an instance of PPFailure."
	
	^ self parseOn: anObject asPetitStream!

parse: anObject onError: aBlock
	"Parse anObject with the receiving parser and answer the parse-result or answer the result of evaluating aBlock. Depending on the number of arguments of the block it is simply evaluated, evaluated with the failure object, or evaluated with the error message and position."
	
	| result |
	result := self parse: anObject.
	result isPetitFailure
		ifFalse: [ ^ result ].
	aBlock numArgs = 0
		ifTrue: [ ^ aBlock value ].
	aBlock numArgs = 1
		ifTrue: [ ^ aBlock value: result ].
	^ aBlock value: result message value: result position!

parseOn: aStream
	"Parse aStream with the receiving parser and answer the parse-result or an instance of PPFailure. Override this method in subclasses to specify custom parse behavior. Do not call this method from outside, instead use #parse:."
	
	self subclassResponsibility!

plus
	"Answer a new parser that parses the receiver one or more times."

	^ self star setMin: 1!

plusGreedy: aParser
	"Answer a new parser that parses the receiver one or more times until it reaches aParser. This is a greedy non-blind implementation of the star operator. aParser is not consumed."
	
	^ (self starGreedy: aParser) setMin: 1!

plusLazy: aParser
	"Answer a new parser that parses the receiver one or more times until it reaches aParser. This is a lazy non-blind implementation of the star operator. aParser is not consumed."
	
	^ (self starLazy: aParser) setMin: 1!

postCopy
	super postCopy.
	properties := properties copy!

printNameOn: aStream
	self name isNil
		ifTrue: [ aStream print: self hash ]
		ifFalse: [ aStream nextPutAll: self name ]!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(.
	self printNameOn: aStream.
	aStream nextPut: $)!

propertyAt: aKey
	"Answer the property value associated with aKey."
	
	^ self propertyAt: aKey ifAbsent: [ self error: 'Property not found' ]!

propertyAt: aKey ifAbsent: aBlock
	"Answer the property value associated with aKey or, if aKey isn't found, answer the result of evaluating aBlock."
	
	^ properties isNil
		ifTrue: [ aBlock value ]
		ifFalse: [ properties at: aKey ifAbsent: aBlock ]!

propertyAt: aKey ifAbsentPut: aBlock
	"Answer the property associated with aKey or, if aKey isn't found store the result of evaluating aBlock as new value."
	
	^ self propertyAt: aKey ifAbsent: [ self propertyAt: aKey put: aBlock value ]!

propertyAt: aKey put: anObject
	"Set the property at aKey to be anObject. If aKey is not found, create a new entry for aKey and set is value to anObject. Answer anObject."

	^ (properties ifNil: [ properties := Dictionary new: 1 ])
		at: aKey put: anObject!

removeProperty: aKey
	"Remove the property with aKey. Answer the property or raise an error if aKey isn't found."
	
	^ self removeProperty: aKey ifAbsent: [ self error: 'Property not found' ]!

removeProperty: aKey ifAbsent: aBlock
	"Remove the property with aKey. Answer the value or, if aKey isn't found, answer the result of evaluating aBlock."
	
	| answer |
	properties isNil ifTrue: [ ^ aBlock value ].
	answer := properties removeKey: aKey ifAbsent: aBlock.
	properties isEmpty ifTrue: [ properties := nil ].
	^ answer!

replace: aParser with: anotherParser
	"Replace the references of the receiver pointing to aParser with anotherParser."!

sentinelInstance
	^(Smalltalk at: #PPSentinel) instance!

separatedBy: aParser
	"Answer a new parser that parses the receiver one or more times, separated by aParser."
	
	^ (PPSequenceParser with: self with: (PPSequenceParser with: aParser with: self) star) ==> [ :nodes |
		| result |
		result := Array new: 2 * nodes second size + 1.
		result at: 1 put: nodes first.
		nodes second 
			keysAndValuesDo: [ :index :pair | result replaceFrom: 2 * index to: 2 * index + 1 with: pair startingAt: 1 ].
		result ]!

star
	"Answer a new parser that parses the receiver zero or more times. This is a greedy and blind implementation that tries to consume as much input as possible and it does not consider what comes afterwards."

	^ PPPossessiveRepeatingParser on: self!

starGreedy: aParser
	"Answer a new parser that parses the receiver zero or more times until it reaches aParser. This is a greedy non-blind implementation of the star operator. aParser is not consumed."
	
	^ PPGreedyRepeatingParser on: self limit: aParser!

times: anInteger
	"Answer a new parser that parses the receiver exactly anInteger times."
	
	^ self min: anInteger max: anInteger!

token
	"Answer a new parser that transforms the input to a token."
	
	^ PPTokenParser on: self!

token: aTokenClass
	"Answer a new parser that transforms the input to a token of class aTokenClass."
	
	^ self token tokenClass: aTokenClass!

transform: aBlock
	"Answer a copy of all parsers reachable from the receiver transformed using aBlock."

	| mapping root |
	mapping := IdentityDictionary new.
	self allParsersDo: [ :each |
		mapping
			at: each
			put: (aBlock value: each copy) ].
	root := mapping at: self.
	[	| changed |
		changed := false.
		root allParsersDo: [ :each |
			each children do: [ :old |
				mapping at: old ifPresent: [ :new |
					each replace: old with: new.
					changed := true ] ] ].
		changed ] whileTrue.
	^ root!

trim
	"Answer a new parser that consumes spaces before and after the receiving parser."
	
	^ self trimSpaces!

trim: aParser
	"Answer a new parser that consumes and ignores aParser repeatedly before and after the receiving parser."
	
	^ PPTrimmingParser on: self trimmer: aParser!

trimBlanks
	"Answer a new parser that consumes blanks before and after the receiving parser."
	
	^ self trim: #blank asParser!

trimSpaces
	"Answer a new parser that consumes spaces before and after the receiving parser."
	
	^ self trim: #space asParser!

withoutSeparators
	"Filters out the separators from a parse result produced by one of the productions #delimitedBy: or #separatedBy:."
	
	^ self ==> [ :items |
		| result |
		result := Array new: items size + 1 // 2.
		1 to: result size do: [ :index | result at: index put: (items at: 2 * index - 1) ].
		result ]!

wrapped
	"Answer a new parser that is simply wrapped."
	
	^ PPDelegateParser on: self! !
!PPParser categoriesFor: #,!operators!public! !
!PPParser categoriesFor: #/!operators!public! !
!PPParser categoriesFor: #|!operators!public! !
!PPParser categoriesFor: #==>!operators-mapping!public! !
!PPParser categoriesFor: #>=>!operators-mapping!public! !
!PPParser categoriesFor: #allNamedParsers!*petitanalyzer-named!public! !
!PPParser categoriesFor: #allNamedParsersDo:!*petitanalyzer-named!public! !
!PPParser categoriesFor: #allParsers!*petitanalyzer-enumerating!public! !
!PPParser categoriesFor: #allParsersDo:!*petitanalyzer-enumerating!public! !
!PPParser categoriesFor: #allParsersDo:seen:!*petitanalyzer-enumerating!public! !
!PPParser categoriesFor: #and!operators!public! !
!PPParser categoriesFor: #answer:!operators-mapping!public! !
!PPParser categoriesFor: #asParser!converting!public! !
!PPParser categoriesFor: #becomeForward:!public! !
!PPParser categoriesFor: #children!accessing!public! !
!PPParser categoriesFor: #copyInContext:!*petitanalyzer-matching!public! !
!PPParser categoriesFor: #copyInContext:seen:!*petitanalyzer-matching!public! !
!PPParser categoriesFor: #cycleSet!*petitanalyzer-querying!public! !
!PPParser categoriesFor: #cycleSet:!*petitanalyzer-private!public! !
!PPParser categoriesFor: #cycleSet:firstSets:into:!*petitanalyzer-private!public! !
!PPParser categoriesFor: #def:!operators!public! !
!PPParser categoriesFor: #delimitedBy:!operators-convenience!public! !
!PPParser categoriesFor: #end!operators!public! !
!PPParser categoriesFor: #firstSet!*petitanalyzer-querying!public! !
!PPParser categoriesFor: #firstSets!*petitanalyzer-querying!public! !
!PPParser categoriesFor: #firstSets:into:!*petitanalyzer-private!public! !
!PPParser categoriesFor: #flatten!operators-mapping!public! !
!PPParser categoriesFor: #foldLeft:!operators-mapping!public! !
!PPParser categoriesFor: #foldRight:!operators-mapping!public! !
!PPParser categoriesFor: #followSet!*petitanalyzer-querying!public! !
!PPParser categoriesFor: #followSets!*petitanalyzer-querying!public! !
!PPParser categoriesFor: #followSets:firstSets:into:!*petitanalyzer-private!public! !
!PPParser categoriesFor: #hasProperty:!accessing-properties!public! !
!PPParser categoriesFor: #initialize!initialization!public! !
!PPParser categoriesFor: #innerChildren!*petitanalyzer-named!public! !
!PPParser categoriesFor: #innerChildrenDo:!*petitanalyzer-named!public! !
!PPParser categoriesFor: #innerChildrenDo:seen:!*petitanalyzer-named!public! !
!PPParser categoriesFor: #isFirstSetTerminal!*PetitAnalyzer!public! !
!PPParser categoriesFor: #isNullable!*petitanalyzer-testing!public! !
!PPParser categoriesFor: #isPetitParser!public!testing! !
!PPParser categoriesFor: #isTerminal!*petitanalyzer-testing!public! !
!PPParser categoriesFor: #isUnresolved!public!testing! !
!PPParser categoriesFor: #map:!operators-mapping!public! !
!PPParser categoriesFor: #match:inContext:!*petitanalyzer-matching!public! !
!PPParser categoriesFor: #match:inContext:seen:!*petitanalyzer-matching!public! !
!PPParser categoriesFor: #matches:!parsing!public! !
!PPParser categoriesFor: #matchesIn:!parsing!public! !
!PPParser categoriesFor: #matchesIn:do:!parsing!public! !
!PPParser categoriesFor: #matchesSkipIn:!parsing!public! !
!PPParser categoriesFor: #matchesSkipIn:do:!parsing!public! !
!PPParser categoriesFor: #matchingRangesIn:!parsing!public! !
!PPParser categoriesFor: #matchingRangesIn:do:!parsing!public! !
!PPParser categoriesFor: #matchingSkipRangesIn:!parsing!public! !
!PPParser categoriesFor: #matchingSkipRangesIn:do:!parsing!public! !
!PPParser categoriesFor: #matchList:against:inContext:seen:!*petitanalyzer-matching!public! !
!PPParser categoriesFor: #matchList:index:against:index:inContext:seen:!*petitanalyzer-matching!public! !
!PPParser categoriesFor: #max:!operators-repeating!public! !
!PPParser categoriesFor: #max:greedy:!operators-repeating!public! !
!PPParser categoriesFor: #max:lazy:!operators-repeating!public! !
!PPParser categoriesFor: #memoized!operators!public! !
!PPParser categoriesFor: #min:!operators-repeating!public! !
!PPParser categoriesFor: #min:greedy:!operators-repeating!public! !
!PPParser categoriesFor: #min:lazy:!operators-repeating!public! !
!PPParser categoriesFor: #min:max:!operators-repeating!public! !
!PPParser categoriesFor: #min:max:greedy:!operators-repeating!public! !
!PPParser categoriesFor: #min:max:lazy:!operators-repeating!public! !
!PPParser categoriesFor: #name!accessing!public! !
!PPParser categoriesFor: #name:!accessing!public! !
!PPParser categoriesFor: #namedChildren!*petitanalyzer-named!public! !
!PPParser categoriesFor: #namedChildrenDo:!*petitanalyzer-named!public! !
!PPParser categoriesFor: #namedChildrenDo:seen:!*petitanalyzer-named!public! !
!PPParser categoriesFor: #negate!operators!public! !
!PPParser categoriesFor: #not!operators!public! !
!PPParser categoriesFor: #optional!operators!public! !
!PPParser categoriesFor: #parse:!parsing!public! !
!PPParser categoriesFor: #parse:onError:!parsing!public! !
!PPParser categoriesFor: #parseOn:!parsing!public! !
!PPParser categoriesFor: #plus!operators-repeating!public! !
!PPParser categoriesFor: #plusGreedy:!operators-repeating!public! !
!PPParser categoriesFor: #plusLazy:!operators-repeating!public! !
!PPParser categoriesFor: #postCopy!copying!public! !
!PPParser categoriesFor: #printNameOn:!printing!public! !
!PPParser categoriesFor: #printOn:!printing!public! !
!PPParser categoriesFor: #propertyAt:!accessing-properties!public! !
!PPParser categoriesFor: #propertyAt:ifAbsent:!accessing-properties!public! !
!PPParser categoriesFor: #propertyAt:ifAbsentPut:!accessing-properties!public! !
!PPParser categoriesFor: #propertyAt:put:!accessing-properties!public! !
!PPParser categoriesFor: #removeProperty:!accessing-properties!public! !
!PPParser categoriesFor: #removeProperty:ifAbsent:!accessing-properties!public! !
!PPParser categoriesFor: #replace:with:!*petitanalyzer-transforming!public! !
!PPParser categoriesFor: #sentinelInstance!public! !
!PPParser categoriesFor: #separatedBy:!operators-convenience!public! !
!PPParser categoriesFor: #star!operators-repeating!public! !
!PPParser categoriesFor: #starGreedy:!operators-repeating!public! !
!PPParser categoriesFor: #times:!operators-repeating!public! !
!PPParser categoriesFor: #token!operators-mapping!public! !
!PPParser categoriesFor: #token:!operators-mapping!public! !
!PPParser categoriesFor: #transform:!*petitanalyzer-transforming!public! !
!PPParser categoriesFor: #trim!operators-mapping!public! !
!PPParser categoriesFor: #trim:!operators-mapping!public! !
!PPParser categoriesFor: #trimBlanks!operators-mapping!public! !
!PPParser categoriesFor: #trimSpaces!operators-mapping!public! !
!PPParser categoriesFor: #withoutSeparators!operators-convenience!public! !
!PPParser categoriesFor: #wrapped!operators!public! !

!PPParser class methodsFor!

named: aString
	^ self new name: aString!

new
	^ self basicNew initialize! !
!PPParser class categoriesFor: #named:!instance creation!public! !
!PPParser class categoriesFor: #new!instance creation!public! !

