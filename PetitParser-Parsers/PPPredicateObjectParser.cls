"Filed out from Dolphin Smalltalk 7"!

PPPredicateParser subclass: #PPPredicateObjectParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPPredicateObjectParser guid: (GUID fromString: '{4383dc81-e425-4bf7-b457-515d8f306cd4}')!
PPPredicateObjectParser comment: ''!
!PPPredicateObjectParser categoriesForClass!Unclassified! !
!PPPredicateObjectParser methodsFor!

chars: aCollection message: aString
	^ self on: (PPCharSetPredicate on: [ :char | aCollection includes: char ]) message: aString!

digit
	^ self on: (PPCharSetPredicate on: [ :char | char isDigit ]) message: 'digit expected'!

hex
	^ self 
		on: (PPCharSetPredicate on: [ :char | 
			(char between: $0 and: $9) 
				or: [ (char between: $a and: $f) 
				or: [ (char between: $A and: $F) ] ] ])
		message: 'hex digit expected'!

initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString
	predicate := aBlock.
	predicateMessage := aString.
	negated := aNegatedBlock.
	negatedMessage := aNegatedString!

letter
	^ self on: (PPCharSetPredicate on: [ :char | char isLetter ]) message: 'letter expected'!

lowercase
	^ self on: (PPCharSetPredicate on: [ :char | char isLowercase ]) message: 'lowercase letter expected'!

negate
	"Answer a parser that is the negation of the receiving predicate parser."
	
	^ self class 
		on: negated message: negatedMessage 
		negated: predicate message: predicateMessage!

space
	^ self on: (PPCharSetPredicate on: [ :char | char isSeparator ]) message: 'separator expected'!

uppercase
	^ self on: (PPCharSetPredicate on: [ :char | char isUppercase ]) message: 'uppercase letter expected'!

word
	^ self on: (PPCharSetPredicate on: [ :char | char isAlphaNumeric ]) message: 'letter or digit expected'! !
!PPPredicateObjectParser categoriesFor: #chars:message:!public! !
!PPPredicateObjectParser categoriesFor: #digit!public! !
!PPPredicateObjectParser categoriesFor: #hex!public! !
!PPPredicateObjectParser categoriesFor: #initializeOn:message:negated:message:!initialization!public! !
!PPPredicateObjectParser categoriesFor: #letter!public! !
!PPPredicateObjectParser categoriesFor: #lowercase!public! !
!PPPredicateObjectParser categoriesFor: #negate!operators!public! !
!PPPredicateObjectParser categoriesFor: #space!public! !
!PPPredicateObjectParser categoriesFor: #uppercase!public! !
!PPPredicateObjectParser categoriesFor: #word!public! !

!PPPredicateObjectParser class methodsFor!

any
	^ self
		on: [ :each | true ] message: 'input expected'
		negated: [ :each | false ] message: 'no input expected'!

anyExceptAnyOf: aCollection
	^ self
		on: [ :each | (aCollection includes: each) not ] message: 'any except ' , aCollection printString , ' expected'
		negated: [ :each | aCollection includes: each ] message: aCollection printString ,  ' not expected'!

anyOf: aCollection
	^ self
		on: [ :each | aCollection includes: each ] message: 'any of ' , aCollection printString , ' expected'
		negated: [ :each | (aCollection includes: each) not ] message: 'none of ' , aCollection printString ,  'expected'!

between: min and: max
	^ self
		on: [ :each | each >= min and: [ each <= max ] ] message: min printString , '..' , max printString , ' expected'
		negated: [ :each | each < min or: [ each > max ] ] message: min printString , '..' , max printString , ' not expected'!

blank
	^ self chars: (String with: Character space with: Character tab) message: 'blank expected'!

char: aCharacter
	^ self expect: aCharacter message: (String with: $" with: aCharacter with: $") , ' expected'!

char: aCharacter message: aString
	^ self expect: aCharacter message: aString!

chars: aCollection message: aString
	^ self on: (PPCharSetPredicate on: [ :char | aCollection includes: char ]) message: aString!

control
	^ self chars: ((0 to: 31) collect: [ :each | Character value: each ]) message: 'control character expected'!

cr
	^ self char: Character cr message: 'carriage return expected'!

digit
	^ self on: (PPCharSetPredicate on: [ :char | char isDigit ]) message: 'digit expected'!

expect: anObject
	^ self expect: anObject message: anObject printString , ' expected'!

expect: anObject message: aString
	^ self 
		on: [ :each | each = anObject ] message: aString
		negated: [ :each | each ~= anObject ] message: 'no ' , aString!

hex
	^ self 
		on: (PPCharSetPredicate on: [ :char | 
			(char between: $0 and: $9) 
				or: [ (char between: $a and: $f) 
				or: [ (char between: $A and: $F) ] ] ])
		message: 'hex digit expected'!

letter
	^ self on: (PPCharSetPredicate on: [ :char | char isLetter ]) message: 'letter expected'!

lf
	^ self char: Character lf!

lowercase
	^ self on: (PPCharSetPredicate on: [ :char | char isLowercase ]) message: 'lowercase letter expected'!

newline
	^ self chars: (String with: Character cr with: Character lf) message: 'newline expected'!

on: aBlock message: aString
	^ self on: aBlock message: aString negated: [ :each | (aBlock value: each) not ] message: 'no ' , aString!

on: aBlock message: aString negated: aNegatedBlock message: aNegatedString
	^ self new initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString!

punctuation
	^ self chars: '.,"''?!!;:#$%&()*+-/<>=@[]\^:=#()|~' message: 'punctuation expected'!

space
	^ self on: (PPCharSetPredicate on: [ :char | char isSeparator ]) message: 'separator expected'!

tab
	^ self char: Character tab message: 'tab expected'!

uppercase
	^ self on: (PPCharSetPredicate on: [ :char | char isUppercase ]) message: 'uppercase letter expected'!

word
	^ self on: (PPCharSetPredicate on: [ :char | char isAlphaNumeric ]) message: 'letter or digit expected'! !
!PPPredicateObjectParser class categoriesFor: #any!factory-objects!public! !
!PPPredicateObjectParser class categoriesFor: #anyExceptAnyOf:!factory-objects!public! !
!PPPredicateObjectParser class categoriesFor: #anyOf:!factory-objects!public! !
!PPPredicateObjectParser class categoriesFor: #between:and:!factory-objects!public! !
!PPPredicateObjectParser class categoriesFor: #blank!factory-chars!public! !
!PPPredicateObjectParser class categoriesFor: #char:!factory-chars!public! !
!PPPredicateObjectParser class categoriesFor: #char:message:!factory-chars!public! !
!PPPredicateObjectParser class categoriesFor: #chars:message:!factory-chars!public! !
!PPPredicateObjectParser class categoriesFor: #control!*petitregex-chars!public! !
!PPPredicateObjectParser class categoriesFor: #cr!factory-chars!public! !
!PPPredicateObjectParser class categoriesFor: #digit!factory-chars!public! !
!PPPredicateObjectParser class categoriesFor: #expect:!factory-objects!public! !
!PPPredicateObjectParser class categoriesFor: #expect:message:!factory-objects!public! !
!PPPredicateObjectParser class categoriesFor: #hex!factory-chars!public! !
!PPPredicateObjectParser class categoriesFor: #letter!factory-chars!public! !
!PPPredicateObjectParser class categoriesFor: #lf!factory-chars!public! !
!PPPredicateObjectParser class categoriesFor: #lowercase!factory-chars!public! !
!PPPredicateObjectParser class categoriesFor: #newline!factory-chars!public! !
!PPPredicateObjectParser class categoriesFor: #on:message:!instance creation!public! !
!PPPredicateObjectParser class categoriesFor: #on:message:negated:message:!instance creation!public! !
!PPPredicateObjectParser class categoriesFor: #punctuation!factory-chars!public! !
!PPPredicateObjectParser class categoriesFor: #space!factory-chars!public! !
!PPPredicateObjectParser class categoriesFor: #tab!factory-chars!public! !
!PPPredicateObjectParser class categoriesFor: #uppercase!factory-chars!public! !
!PPPredicateObjectParser class categoriesFor: #word!factory-chars!public! !

