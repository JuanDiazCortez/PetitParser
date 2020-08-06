"Filed out from Dolphin Smalltalk 7"!

PPListParser subclass: #PPChoiceParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPChoiceParser guid: (GUID fromString: '{458de5f2-c1bc-440a-bb31-b122c688846d}')!
PPChoiceParser comment: ''!
!PPChoiceParser categoriesForClass!Unclassified! !
!PPChoiceParser methodsFor!

/ aRule 
	^ self copyWith: aRule!

parseOn: aStream
	"This is optimized code that avoids unnecessary block activations, do not change. When all choices fail, the last failure is answered."

	| element |
	1 to: parsers size do: [ :index |
		element := (parsers at: index)
			parseOn: aStream.
		element isPetitFailure
			ifFalse: [ ^ element ] ].
	^ element! !
!PPChoiceParser categoriesFor: #/!operators!public! !
!PPChoiceParser categoriesFor: #parseOn:!parsing!public! !

