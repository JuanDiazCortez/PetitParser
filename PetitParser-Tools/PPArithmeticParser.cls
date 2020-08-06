"Filed out from Dolphin Smalltalk 7"!

PPCompositeParser subclass: #PPArithmeticParser
	instanceVariableNames: 'terms addition factors multiplication power primary parentheses number'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPArithmeticParser guid: (GUID fromString: '{fd2c9304-9278-4b66-bf21-7ace73e1f0bb}')!
PPArithmeticParser comment: ''!
!PPArithmeticParser categoriesForClass!Unclassified! !
!PPArithmeticParser methodsFor!

addition
	^ (factors separatedBy: ($+ asParser / $- asParser) trim) 
		foldLeft: [ :a :op :b | a perform: op asSymbol with: b ]!

factors
	^ multiplication / power!

multiplication
	^ (power separatedBy: ($* asParser / $/ asParser) trim)
		foldLeft: [ :a :op :b | a perform: op asSymbol with: b ]!

number
	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) flatten trim 
		==> [ :value | value asNumber ]!

parentheses
	^ $( asParser trim , terms , $) asParser trim
		==> [ :nodes | nodes second ]!

power
	^ (primary separatedBy: $^ asParser trim)
		foldRight: [ :a :op :b | a raisedTo: b ]!

primary
	^ number / parentheses!

start
	^ terms end!

terms
	^ addition / factors! !
!PPArithmeticParser categoriesFor: #addition!grammar!public! !
!PPArithmeticParser categoriesFor: #factors!grammar!public! !
!PPArithmeticParser categoriesFor: #multiplication!grammar!public! !
!PPArithmeticParser categoriesFor: #number!grammar!public! !
!PPArithmeticParser categoriesFor: #parentheses!grammar!public! !
!PPArithmeticParser categoriesFor: #power!grammar!public! !
!PPArithmeticParser categoriesFor: #primary!grammar!public! !
!PPArithmeticParser categoriesFor: #start!accessing!public! !
!PPArithmeticParser categoriesFor: #terms!grammar!public! !

