"Filed out from Dolphin Smalltalk 7"!

PPCompositeParser subclass: #PPCommaSeparatedParser
	instanceVariableNames: 'row cell rows endOfLine whitespace nonComma'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPCommaSeparatedParser guid: (GUID fromString: '{f51c4677-71df-4cbf-a711-6ba9be410ccf}')!
PPCommaSeparatedParser comment: ''!
!PPCommaSeparatedParser categoriesForClass!Unclassified! !
!PPCommaSeparatedParser methodsFor!

cell
	^ whitespace star , nonComma star flatten , whitespace star
		==> [ :nodes | nodes second value ]!

endOfLine
	^ #newline asParser token!

nonComma
	^ PPPredicateObjectParser anyExceptAnyOf: #(Character space  Character tab  Character cr Character lf , $  )!

number 
	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) token
		==> [ :nodes | nodes first value asNumber ]!

start
	^ rows end!

whitespace
	^ PPPredicateObjectParser anyOf: (Array with: Character space with: Character tab)! !
!PPCommaSeparatedParser categoriesFor: #cell!public! !
!PPCommaSeparatedParser categoriesFor: #endOfLine!public! !
!PPCommaSeparatedParser categoriesFor: #nonComma!public! !
!PPCommaSeparatedParser categoriesFor: #number!public! !
!PPCommaSeparatedParser categoriesFor: #start!public! !
!PPCommaSeparatedParser categoriesFor: #whitespace!public! !

