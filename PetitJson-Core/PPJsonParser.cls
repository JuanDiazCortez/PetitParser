"Filed out from Dolphin Smalltalk 7"!

PPJsonGrammar subclass: #PPJsonParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPJsonParser guid: (GUID fromString: '{68596b36-770d-416f-9bad-1952e1a06186}')!
PPJsonParser comment: ''!
!PPJsonParser categoriesForClass!Unclassified! !
!PPJsonParser methodsFor!

array
	^ super array ==> [ :nodes | Array withAll: (nodes second ifNil: [ #() ]) ]!

charEscape
	^ super charEscape ==> [ :nodes | CharacterTable at: nodes last ]!

charOctal
	^ super charOctal ==> [ :nodes |
		Character value: (nodes last allButFirst
			inject: nodes last first digitValue
			into: [ :result :each | (result << 4) + each digitValue ]) ]!

elements
	^ super elements ==> [ :nodes | nodes reject: [ :each | each isKindOf: PPToken ] ]!

falseToken
	^ super falseToken ==> [ :token | false ]!

members
	^ super members ==> [ :nodes | nodes reject: [ :each | each isKindOf: PPToken ] ]!

nullToken
	^ super nullToken  ==> [ :token | nil ]!

numberToken
	^ super numberToken ==> [ :token | (token inputValue copyWithout: $+) asLowercase asNumber ]!

object
	^ super object ==> [ :nodes |
		(nodes second ifNil: [ #() ])
			inject: Dictionary new
			into: [ :result :each | 
				result
					add: each;
					yourself ] ]!

pair
	^ super pair map: [ :key :sep :val | key -> val ]!

stringToken
	^ string trim ==> [ :nodes | String withAll: nodes second ]!

trueToken
	^ super trueToken ==> [ :token | true ]! !
!PPJsonParser categoriesFor: #array!grammar!public! !
!PPJsonParser categoriesFor: #charEscape!primitives!public! !
!PPJsonParser categoriesFor: #charOctal!primitives!public! !
!PPJsonParser categoriesFor: #elements!grammar!public! !
!PPJsonParser categoriesFor: #falseToken!public!tokens! !
!PPJsonParser categoriesFor: #members!grammar!public! !
!PPJsonParser categoriesFor: #nullToken!public!tokens! !
!PPJsonParser categoriesFor: #numberToken!public!tokens! !
!PPJsonParser categoriesFor: #object!grammar!public! !
!PPJsonParser categoriesFor: #pair!grammar!public! !
!PPJsonParser categoriesFor: #stringToken!public!tokens! !
!PPJsonParser categoriesFor: #trueToken!public!tokens! !

