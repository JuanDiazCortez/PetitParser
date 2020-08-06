"Filed out from Dolphin Smalltalk 7"!

PPDelegateParser subclass: #PPCompositeParser
	instanceVariableNames: 'dependencies'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPCompositeParser guid: (GUID fromString: '{73848218-5075-4e44-b1fa-16a61c569fcc}')!
PPCompositeParser comment: ''!
!PPCompositeParser categoriesForClass!Unclassified! !
!PPCompositeParser methodsFor!

dependencyAt: aClass
	"Answer the dependent parser aClass. Throws an error if this parser class is not declared in the method #dependencies on the class-side of the receiver."
	
	^ dependencies at: aClass ifAbsent: [ self error: 'Undeclared dependency in ' , self class name , ' to ' , aClass name ]!

initializeStartingAt: aSymbol dependencies: aDictionary
	self initialize.
	parser := PPDelegateParser named: aSymbol.
	self productionNames keysAndValuesDo: [ :key :value |
		self instVarAt: key put: (PPDelegateParser named: value) ].
	dependencies := aDictionary!

productionAt: aSymbol
	"Answer the production named aSymbol."
	
	^ self productionAt: aSymbol ifAbsent: [ nil ]!

productionAt: aSymbol ifAbsent: aBlock
	"Answer the production named aSymbol, if there is no such production answer the result of evaluating aBlock."
	
	(self class ignoredNames includes: aSymbol asString)
		ifTrue: [ ^ aBlock value ].
	(self class startSymbol = aSymbol)
		ifTrue: [ ^ parser ].
	^ self instVarAt: (self class allInstVarNames
		indexOf: aSymbol asString
		ifAbsent: [ ^ aBlock value ])!

productionNames
	"Answer a dictionary of slot indexes and production names."
	
	| productionNames ignoredNames |
	productionNames := Dictionary new.
	ignoredNames := self class ignoredNames
		collect: [ :each | each asSymbol ].
	self class allInstVarNames keysAndValuesDo: [ :key :value |
		(ignoredNames includes: value asSymbol)
			ifFalse: [ productionNames at: key put: value asSymbol ] ].
	^ productionNames!

start
	"Answer the production to start this parser with."
	
	self subclassResponsibility! !
!PPCompositeParser categoriesFor: #dependencyAt:!public!querying! !
!PPCompositeParser categoriesFor: #initializeStartingAt:dependencies:!initialization!public! !
!PPCompositeParser categoriesFor: #productionAt:!public!querying! !
!PPCompositeParser categoriesFor: #productionAt:ifAbsent:!public!querying! !
!PPCompositeParser categoriesFor: #productionNames!public!querying! !
!PPCompositeParser categoriesFor: #start!accessing!public! !

!PPCompositeParser class methodsFor!

dependencies
	"Answer a collection of PPCompositeParser classes that this parser directly dependends on. Override this method in subclasses to declare dependent parsers. The default implementation does not depend on other PPCompositeParser."

	^ #()!

ignoredNames
	"Answer a collection of instance-variables that should not be automatically initialized with productions, but that are used internal to the composite parser."

	^ PPCompositeParser allInstVarNames!

new
	"Answer a new parser starting at the default start symbol."

	^ self newStartingAt: self startSymbol!

newStartingAt: aSymbol
	"Answer a new parser starting at aSymbol. The code makes sure to resolve all dependent parsers correctly."

	| parsers remaining |
	parsers := IdentityDictionary new.
	remaining := OrderedCollection with: self.
	[ remaining isEmpty ] whileFalse: [
		| dependency |
		dependency := remaining removeLast.
		(parsers includesKey: dependency) ifFalse: [
			parsers at: dependency put: dependency basicNew.
			remaining addAll: dependency dependencies ] ].
	parsers keysAndValuesDo: [ :class :parser |
		| dependencies |
		dependencies := IdentityDictionary new.
		class dependencies 
			do: [ :dependency | dependencies at: dependency put: (parsers at: dependency) ].
		parser 
			initializeStartingAt: (class == self
				ifTrue: [ aSymbol ]
				ifFalse: [ class startSymbol ]) 
			dependencies: dependencies ].
	parsers keysAndValuesDo: [ :class :parser |
		parser setParser: (parser perform: parser children first name).
		parser productionNames keysAndValuesDo: [ :key :value |
			(parser instVarAt: key) setParser: (parser perform: value) ] ].
	^ parsers at: self!

parse: anObject
	^ self parse: anObject startingAt: self startSymbol!

parse: anObject onError: aBlock
	^ self parse: anObject startingAt: self startSymbol onError: aBlock!

parse: anObject startingAt: aSymbol
	^ (self newStartingAt: aSymbol) parse: anObject!

parse: anObject startingAt: aSymbol onError: aBlock
	^ (self newStartingAt: aSymbol) parse: anObject onError: aBlock!

startSymbol
	"Answer the method that represents the default start symbol."

	^ #start! !
!PPCompositeParser class categoriesFor: #dependencies!accessing!public! !
!PPCompositeParser class categoriesFor: #ignoredNames!accessing!public! !
!PPCompositeParser class categoriesFor: #new!instance creation!public! !
!PPCompositeParser class categoriesFor: #newStartingAt:!instance creation!public! !
!PPCompositeParser class categoriesFor: #parse:!parsing!public! !
!PPCompositeParser class categoriesFor: #parse:onError:!parsing!public! !
!PPCompositeParser class categoriesFor: #parse:startingAt:!parsing!public! !
!PPCompositeParser class categoriesFor: #parse:startingAt:onError:!parsing!public! !
!PPCompositeParser class categoriesFor: #startSymbol!accessing!public! !

