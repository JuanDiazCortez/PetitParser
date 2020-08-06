"Filed out from Dolphin Smalltalk 7"!

PPCompositeParser subclass: #PPLambdaParser
	instanceVariableNames: 'expression abstraction application variable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPLambdaParser guid: (GUID fromString: '{3f6b942a-5e81-423b-a075-fbf75c8fab98}')!
PPLambdaParser comment: ''!
!PPLambdaParser categoriesForClass!Unclassified! !
!PPLambdaParser methodsFor!

abstraction
	^ $\ asParser trim , variable , $. asParser trim , expression ==> [ :node | Array with: node second with: node fourth ]!

application
	^ $( asParser trim , expression , expression , $) asParser trim ==> [ :node | Array with: node second with: node third ]!

expression
	^ variable / abstraction / application!

start
	^ expression end!

variable
	^ (#letter asParser , #word asParser star) flatten trim! !
!PPLambdaParser categoriesFor: #abstraction!productions!public! !
!PPLambdaParser categoriesFor: #application!productions!public! !
!PPLambdaParser categoriesFor: #expression!productions!public! !
!PPLambdaParser categoriesFor: #start!accessing!public! !
!PPLambdaParser categoriesFor: #variable!productions!public! !

!PPLambdaParser class methodsFor!

and
	^ self parse: '\p.\q.((p q) p)'!

false
	^ self parse: '\x.\y.y'!

ifthenelse
	^ self parse: '\p.p'!

not
	^ self parse: '\p.\a.\b.((p b) a)'!

or
	^ self parse: '\p.\q.((p p) q)'!

true
	^ self parse: '\x.\y.x'! !
!PPLambdaParser class categoriesFor: #and!curch-booleans!public! !
!PPLambdaParser class categoriesFor: #false!curch-booleans!public! !
!PPLambdaParser class categoriesFor: #ifthenelse!curch-booleans!public! !
!PPLambdaParser class categoriesFor: #not!curch-booleans!public! !
!PPLambdaParser class categoriesFor: #or!curch-booleans!public! !
!PPLambdaParser class categoriesFor: #true!curch-booleans!public! !

