"Filed out from Dolphin Smalltalk 7"!

PPDelegateParser subclass: #PPExpressionParser
	instanceVariableNames: 'operators'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPExpressionParser guid: (GUID fromString: '{538e142b-d654-4827-b411-3476041bf7d5}')!
PPExpressionParser comment: ''!
!PPExpressionParser categoriesForClass!Unclassified! !
!PPExpressionParser methodsFor!

build: aParser left: aChoiceParser
	^ (aParser separatedBy: aChoiceParser) foldLeft: [ :a :op :b | op first value: a value: op second value: b ]!

build: aParser postfix: aChoiceParser
	^ aParser , aChoiceParser star map: [ :term :ops | ops inject: term into: [ :result :operator | operator first value: result value: operator second ] ]!

build: aParser prefix: aChoiceParser
	^ aChoiceParser star , aParser map: [ :ops :term | ops reversed inject: term into: [ :result :operator | operator first value: operator second value: result ] ]!

build: aParser right: aChoiceParser
	^ (aParser separatedBy: aChoiceParser) foldRight: [ :a :op :b | op first value: a value: op second value: b ]!

buildOn: aParser
	^ self buildSelectors inject: aParser into: [ :term :selector |
		| list |
		list := operators at: selector ifAbsent: [ #() ].
		list isEmpty
			ifTrue: [ term ]
			ifFalse: [
				self
					perform: selector with: term 
					with: (list size = 1
						ifTrue: [ list first first ==> [ :operator | Array with: list first second with: operator ] ]
						ifFalse: [ 
							list
								inject: PPChoiceParser new
								into: [ :choice :each | choice / (each first ==> [ :operator | Array with: each second with: operator ]) ] ]) ] ]!

buildSelectors
	^ #(build:prefix: build:postfix: build:right: build:left:)!

group: aOneArgumentBlock
	"Defines a priority group by evaluating aOneArgumentBlock."
	
	operators := Dictionary new.
	parser := [ 
		aOneArgumentBlock value: self.
	 	self buildOn: parser ]
			ensure: [ operators := nil ]!

left: aParser do: aThreeArgumentBlock
	"Define an operator aParser that is left-associative. Evaluate aThreeArgumentBlock with the first term, the operator, and the second term."
	
	self operator: #build:left: parser: aParser do: aThreeArgumentBlock!

operator: aSymbol parser: aParser do: aBlock
	parser isNil
		ifTrue: [ ^ self error: 'You did not specify a term when creating the receiver.' ].
	operators isNil
		ifTrue: [ ^ self error: 'Use #group: to define precedence groups in descending order.' ].
	(operators at: aSymbol ifAbsentPut: [ OrderedCollection new ])
		addLast: (Array with: aParser asParser with: aBlock)!

postfix: aParser do: aTwoArgumentBlock
	"Define a postfix operator aParser. Evaluate aTwoArgumentBlock with the term and the operator."

	self operator: #build:postfix: parser: aParser do: aTwoArgumentBlock!

prefix: aParser do: aTwoArgumentBlock
	"Define a prefix operator aParser. Evaluate aTwoArgumentBlock with the operator and the term."

	self operator: #build:prefix: parser: aParser do: aTwoArgumentBlock!

right: aParser do: aThreeArgumentBlock
	"Define an operator aParser that is right-associative. Evaluate aThreeArgumentBlock with the first term, the operator, and the second term."
	
	self operator: #build:right: parser: aParser do: aThreeArgumentBlock!

term: aParser
	"Defines the initial term aParser of the receiver."
	
	parser isNil
		ifTrue: [ parser := aParser ]
		ifFalse: [ self error: 'Unable to redefine the term.' ]! !
!PPExpressionParser categoriesFor: #build:left:!private! !
!PPExpressionParser categoriesFor: #build:postfix:!private! !
!PPExpressionParser categoriesFor: #build:prefix:!private! !
!PPExpressionParser categoriesFor: #build:right:!private! !
!PPExpressionParser categoriesFor: #buildOn:!private! !
!PPExpressionParser categoriesFor: #buildSelectors!private! !
!PPExpressionParser categoriesFor: #group:!public!specifying! !
!PPExpressionParser categoriesFor: #left:do:!public!specifying! !
!PPExpressionParser categoriesFor: #operator:parser:do:!private! !
!PPExpressionParser categoriesFor: #postfix:do:!public!specifying! !
!PPExpressionParser categoriesFor: #prefix:do:!public!specifying! !
!PPExpressionParser categoriesFor: #right:do:!public!specifying! !
!PPExpressionParser categoriesFor: #term:!public!specifying! !

