"Filed out from Dolphin Smalltalk 7"!

PPCompositeParser subclass: #PPJsonGrammar
	instanceVariableNames: 'members pair string value elements number object array trueToken falseToken nullToken char stringToken numberToken charEscape charNormal charOctal'
	classVariableNames: 'CharacterTable'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPJsonGrammar guid: (GUID fromString: '{15c5f50c-5f1f-4434-939a-5b2d3c2d2881}')!
PPJsonGrammar comment: ''!
!PPJsonGrammar categoriesForClass!Unclassified! !
!PPJsonGrammar methodsFor!

array
	^ $[ asParser token trim , elements optional , $] asParser token trim!

char
	^ charEscape / charOctal / charNormal!

charEscape
	^$\ asParser , (PPPredicateObjectParser anyOf: (String withAll: CharacterTable keys asArray ))!

charNormal
	^PPPredicateObjectParser anyExceptAnyOf: '\"'!

charOctal
	^ '\u' asParser , (#hex asParser min: 4 max: 4)!

elements
	^ value separatedBy: $, asParser token trim!

falseToken
	^ 'false' asParser token trim!

members
	^ pair separatedBy: $, asParser token trim!

nullToken
	^ 'null' asParser token trim!

number
	^ 	($- asParser optional) ,
		($0 asParser / #digit asParser plus) ,
		($. asParser , #digit asParser plus) optional , 
		(($e asParser / $E asParser) , ($- asParser / $+ asParser) optional , #digit asParser plus) optional!

numberToken
	^ number token trim!

object
	^ ${ asParser token trim , members optional , $} asParser token trim!

pair
	^ stringToken , $: asParser token trim , value!

start
	^ value end!

string
	^ $" asParser , char star , $" asParser!

stringToken
	^ string token trim!

trueToken
	^ 'true' asParser token  trim!

value
	^ stringToken / numberToken / object / array / trueToken / falseToken / nullToken! !
!PPJsonGrammar categoriesFor: #array!grammar!public! !
!PPJsonGrammar categoriesFor: #char!primitives!public! !
!PPJsonGrammar categoriesFor: #charEscape!primitives!public! !
!PPJsonGrammar categoriesFor: #charNormal!primitives!public! !
!PPJsonGrammar categoriesFor: #charOctal!primitives!public! !
!PPJsonGrammar categoriesFor: #elements!grammar!public! !
!PPJsonGrammar categoriesFor: #falseToken!public!tokens! !
!PPJsonGrammar categoriesFor: #members!grammar!public! !
!PPJsonGrammar categoriesFor: #nullToken!public!tokens! !
!PPJsonGrammar categoriesFor: #number!primitives!public! !
!PPJsonGrammar categoriesFor: #numberToken!public!tokens! !
!PPJsonGrammar categoriesFor: #object!grammar!public! !
!PPJsonGrammar categoriesFor: #pair!grammar!public! !
!PPJsonGrammar categoriesFor: #start!accessing!public! !
!PPJsonGrammar categoriesFor: #string!primitives!public! !
!PPJsonGrammar categoriesFor: #stringToken!public!tokens! !
!PPJsonGrammar categoriesFor: #trueToken!public!tokens! !
!PPJsonGrammar categoriesFor: #value!grammar!public! !

!PPJsonGrammar class methodsFor!

initialize
	CharacterTable := Dictionary new.
	CharacterTable
		at: $\ put: $\;
		at: $/ put: $/;
		at: $" put: $";
		at: $b put: Character backspace;
		at: $f put: Character newPage;
		at: $n put: Character lf;
		at: $r put: Character cr;
		at: $t put: Character tab! !
!PPJsonGrammar class categoriesFor: #initialize!initialization!public! !

