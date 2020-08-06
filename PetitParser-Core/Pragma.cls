"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Pragma
	instanceVariableNames: 'method keyword arguments'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Pragma guid: (GUID fromString: '{7018beda-2c67-4576-b574-dac1b7e113a8}')!
Pragma comment: 'I represent an occurrence of a pragma in a compiled method.  A pragma is a literal message pattern that occurs between angle brackets at the start of a method after any temporaries.  A common example is the primitive pragma:
	<primitive: 123 errorCode: ''errorCode''>
but one can add one''s own and use them as metadata attached to a method.  Because pragmas are messages one can browse senders and implementors and perform them.  One can query a method for its pragmas by sending it the pragmas message, which answers an Array of instances of me, one for each pragma in the method.

I can provide information about the defining class, method, its selector, as well as the information about the pragma keyword and its arguments. See the two ''accessing'' protocols for details. ''accessing-method'' provides information about the method the pragma is found in, while ''accessing-pragma'' is about the pragma itself.

Instances are retrieved using one of the pragma search methods of the ''finding'' protocol on the class side.

To browse all methods with pragmas in the system evaluate
	SystemNavigation default browseAllSelect: [:m| m pragmas notEmpty]
and to browse all nonprimitive methods with pragmas evaluate
	SystemNavigation default browseAllSelect: [:m| m primitive isZero and: [m pragmas notEmpty]]'!
!Pragma categoriesForClass!Kernel-Methods! !
!Pragma methodsFor!

= anObject 
	^self class == anObject class
	  and: [keyword == anObject keyword
	  and: [arguments = anObject arguments]]!

analogousCodeTo: anObject 
	^self class == anObject class
	  and: [keyword == anObject keyword
	  and: [arguments = anObject arguments]]!

argumentAt: anInteger
	"Answer one of the arguments of the pragma."
	
	^ self arguments at: anInteger.!

arguments
	"Answer the arguments of the receiving pragma. For a pragma defined as <key1: val1 key2: val2> this will answer #(val1 val2)."
	
	^ arguments!

hash
	^keyword hash + arguments hash!

hasLiteral: aLiteral
	^keyword == aLiteral 
	   or: [(arguments hasLiteral: aLiteral)
		or: [keyword == #hasLiteralTest: and: [
			self methodClass theNonMetaClass perform: arguments first with: aLiteral]]]!

hasLiteralSuchThat: aBlock
	"Answer true if litBlock returns true for any literal in the receiver, even if embedded in further array structure.
	 This method is only intended for private use by CompiledMethod hasLiteralSuchThat:"
	^(aBlock value: keyword)
	   or: [arguments hasLiteralSuchThat: aBlock]!

key
	"Answer the keyword of the pragma (the selector of its message pattern).
	 This accessor provides polymorphism with Associations used for properties."
	^keyword!

keyword
	"Answer the keyword of the pragma (the selector of its message pattern).
	 For a pragma defined as <key1: val1 key2: val2> this will answer #key1:key2:."
	
	^ keyword!

message
	"Answer the message of the receiving pragma."
	
	^ Message selector: self keyword arguments: self arguments. !

method
	"Answer the compiled-method containing the pragma."
	
	^ method!

methodClass
	"Answer the class of the method containing the pragma."
	
	^ method methodClass!

numArgs
	"Answer the number of arguments in the pragma."

	^ self arguments size.!

printOn: aStream
	aStream
		nextPut: $<;
		print: self message;
		nextPut: $>.
	method ifNotNil:
		[:m|
		 aStream nextPutAll: ' "in '.
		 m printReferenceOn: aStream.
		 aStream nextPut: $"]!

selector
	"Answer the selector of the method containing the pragma.
	 Do not confuse this with the selector of the pragma's message pattern."
	
	^method selector!

setArguments: anArray
	arguments := anArray!

setKeyword: aSymbol
	keyword := aSymbol!

setMethod: aCompiledMethod
	method := aCompiledMethod! !
!Pragma categoriesFor: #=!comparing!public! !
!Pragma categoriesFor: #analogousCodeTo:!comparing!public! !
!Pragma categoriesFor: #argumentAt:!accessing/pragma!public! !
!Pragma categoriesFor: #arguments!accessing/pragma!public! !
!Pragma categoriesFor: #hash!comparing!public! !
!Pragma categoriesFor: #hasLiteral:!public!testing! !
!Pragma categoriesFor: #hasLiteralSuchThat:!public!testing! !
!Pragma categoriesFor: #key!accessing/pragma!public! !
!Pragma categoriesFor: #keyword!accessing/pragma!public! !
!Pragma categoriesFor: #message!accessing/pragma!public! !
!Pragma categoriesFor: #method!accessing/method!public! !
!Pragma categoriesFor: #methodClass!accessing/method!public! !
!Pragma categoriesFor: #numArgs!accessing/pragma!public! !
!Pragma categoriesFor: #printOn:!printing!public! !
!Pragma categoriesFor: #selector!accessing/method!public! !
!Pragma categoriesFor: #setArguments:!initialization!public! !
!Pragma categoriesFor: #setKeyword:!initialization!public! !
!Pragma categoriesFor: #setMethod:!initialization!public! !

!Pragma class methodsFor!

allNamed: aSymbol from: aSubClass to: aSuperClass
	"Answer a collection of all pragmas found in methods of all classes between aSubClass and aSuperClass (inclusive) whose keyword is aSymbol."
	
	^ Array streamContents: [ :stream |
		aSubClass withAllSuperclassesDo: [ :class |
			self withPragmasIn: class do:  [ :pragma |
				pragma keyword = aSymbol
					ifTrue: [ stream nextPut: pragma ] ].
			aSuperClass = class
				ifTrue: [ ^ stream contents ] ] ].!

allNamed: aSymbol from: aSubClass to: aSuperClass sortedByArgument: anInteger
	"Answer a collection of all pragmas found in methods of all classes between aSubClass and aSuperClass (inclusive) whose keyword is aSymbol, sorted according to argument anInteger."

	^ self allNamed: aSymbol from: aSubClass to: aSuperClass sortedUsing: [ :a :b | (a argumentAt: anInteger) < (b argumentAt: anInteger) ].!

allNamed: aSymbol from: aSubClass to: aSuperClass sortedUsing: aSortBlock
	"Answer a collection of all pragmas found in methods of all classes between aSubClass and aSuperClass (inclusive) whose keyword is aSymbol, sorted according to aSortBlock."
	
	^ (self allNamed: aSymbol from: aSubClass to: aSuperClass) sort: aSortBlock.!

allNamed: aSymbol in: aClass
	"Answer a collection of all pragmas found in methods of aClass whose keyword is aSymbol."
	
	^ Array streamContents: [ :stream |
		self withPragmasIn: aClass do: [ :pragma |
			pragma keyword = aSymbol
				ifTrue: [ stream nextPut: pragma ] ] ].!

allNamed: aSymbol in: aClass sortedByArgument: anInteger
	"Answer a collection of all pragmas found in methods of aClass whose keyword is aSymbol, sorted according to argument anInteger."

	^ self allNamed: aSymbol in: aClass sortedUsing: [ :a :b | (a argumentAt: anInteger) < (b argumentAt: anInteger) ].!

allNamed: aSymbol in: aClass sortedUsing: aSortBlock
	"Answer a collection of all pragmas found in methods of aClass whose keyword is aSymbol, sorted according to aSortBlock."
	
	^ (self allNamed: aSymbol in: aClass) sort: aSortBlock.!

for: aMethod selector: aSelector arguments: anArray
	^self new
		setMethod: aMethod;
		setKeyword: aSelector;
		setArguments: anArray;
		yourself!

keyword: aSymbol arguments: anArray
	^ self new
		setKeyword: aSymbol;
		setArguments: anArray;
		yourself.!

withPragmasIn: aClass do: aBlock
	aClass selectorsAndMethodsDo: [ :selector :method | method pragmas do: aBlock ].! !
!Pragma class categoriesFor: #allNamed:from:to:!finding!public! !
!Pragma class categoriesFor: #allNamed:from:to:sortedByArgument:!finding!public! !
!Pragma class categoriesFor: #allNamed:from:to:sortedUsing:!finding!public! !
!Pragma class categoriesFor: #allNamed:in:!finding!public! !
!Pragma class categoriesFor: #allNamed:in:sortedByArgument:!finding!public! !
!Pragma class categoriesFor: #allNamed:in:sortedUsing:!finding!public! !
!Pragma class categoriesFor: #for:selector:arguments:!instance creation!public! !
!Pragma class categoriesFor: #keyword:arguments:!private! !
!Pragma class categoriesFor: #withPragmasIn:do:!private! !

