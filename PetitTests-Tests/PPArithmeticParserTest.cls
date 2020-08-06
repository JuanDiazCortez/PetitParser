"Filed out from Dolphin Smalltalk 7"!

PPCompositeParserTest subclass: #PPArithmeticParserTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPArithmeticParserTest guid: (GUID fromString: '{9e596696-3ecc-495a-876a-7dd70c00f270}')!
PPArithmeticParserTest comment: ''!
!PPArithmeticParserTest categoriesForClass!Unclassified! !
!PPArithmeticParserTest methodsFor!

parserClass
	^ PPArithmeticParser!

testAdd
	self assert: '1 + 2' is: 3.
	self assert: '2 + 1' is: 3.
	self assert: '1 + 2.3' is: 3.3.
	self assert: '2.3 + 1' is: 3.3.
	self assert: '1 + -2' is: -1.
	self assert: '-2 + 1' is: -1!

testAddMany

	self assert: '1' is: 1.
	self assert: '1 + 2' is: 3.
	self assert: '1 + 2 + 3' is: 6.
	self assert: '1 + 2 + 3 + 4' is: 10.
	self assert: '1 + 2 + 3 + 4 + 5' is: 15!

testBrackets
	self assert: '(1)' is: 1.
	self assert: '(1 + 2)' is: 3.
	
	self assert: '((1))' is: 1.
	self assert: '((1 + 2))' is: 3.

	self assert: '2 * (3 + 4)' is: 14.
	self assert: '(2 + 3) * 4' is: 20.
	self assert: '6 / (2 + 4)' is: 1.
	self assert: '(2 + 6) / 2' is: 4!

testDiv
	self assert: '12 / 3' is: 4.
	self assert: '-16 / -4' is: 4!

testDivMany
	self assert: '100 / 2' is: 50.
	self assert: '100 / 2 / 2' is: 25.
	self assert: '100 / 2 / 2 / 5' is: 5.
	self assert: '100 / 2 / 2 / 5 / 5' is: 1
	!

testMul
	self assert: '2 * 3' is: 6.
	self assert: '2 * -4' is: -8!

testMulMany
	self assert: '1 * 2' is: 2.
	self assert: '1 * 2 * 3' is: 6.
	self assert: '1 * 2 * 3 * 4' is: 24.
	self assert: '1 * 2 * 3 * 4 * 5' is: 120!

testNum
	self assert: '0' is: 0.
	self assert: '0.0' is: 0.0.
	self assert: '1' is: 1.
	self assert: '1.2' is: 1.2.
	self assert: '34' is: 34.
	self assert: '56.78' is: 56.78.
	self assert: '-9' is: -9.
	self assert: '-9.9' is: -9.9!

testPow
	self assert: '2 ^ 3' is: 8.
	self assert: '-2 ^ 3' is: -8.
	self assert: '-2 ^ -3' is: -0.125!

testPowMany
	self assert: '4 ^ 3' is: 64.
	self assert: '4 ^ 3 ^ 2' is: 262144.
	self assert: '4 ^ 3 ^ 2 ^ 1' is: 262144.
	self assert: '4 ^ 3 ^ 2 ^ 1 ^ 0' is: 262144!

testPriority
	self assert: '2 * 3 + 4' is: 10.
	self assert: '2 + 3 * 4' is: 14.
	self assert: '6 / 3 + 4' is: 6.
	self assert: '2 + 6 / 2' is: 5!

testSub
	self assert: '1 - 2' is: -1.
	self assert: '1.2 - 1.2' is: 0.
	self assert: '1 - -2' is: 3.
	self assert: '-1 - -2' is: 1!

testSubMany
	self assert: '1' is: 1.
	self assert: '1 - 2' is: -1.
	self assert: '1 - 2 - 3' is: -4.
	self assert: '1 - 2 - 3 - 4' is: -8.
	self assert: '1 - 2 - 3 - 4 - 5' is: -13! !
!PPArithmeticParserTest categoriesFor: #parserClass!accessing!public! !
!PPArithmeticParserTest categoriesFor: #testAdd!public!testing/operations!testing-operations! !
!PPArithmeticParserTest categoriesFor: #testAddMany!public!testing/operations!testing-operations! !
!PPArithmeticParserTest categoriesFor: #testBrackets!public!testing/expression!testing-expression! !
!PPArithmeticParserTest categoriesFor: #testDiv!public!testing/operations!testing-operations! !
!PPArithmeticParserTest categoriesFor: #testDivMany!public!testing/operations!testing-operations! !
!PPArithmeticParserTest categoriesFor: #testMul!public!testing/operations!testing-operations! !
!PPArithmeticParserTest categoriesFor: #testMulMany!public!testing/operations!testing-operations! !
!PPArithmeticParserTest categoriesFor: #testNum!public!testing! !
!PPArithmeticParserTest categoriesFor: #testPow!public!testing/operations!testing-operations! !
!PPArithmeticParserTest categoriesFor: #testPowMany!public!testing/operations!testing-operations! !
!PPArithmeticParserTest categoriesFor: #testPriority!public!testing/expression!testing-expression! !
!PPArithmeticParserTest categoriesFor: #testSub!public!testing/operations!testing-operations! !
!PPArithmeticParserTest categoriesFor: #testSubMany!public!testing/operations!testing-operations! !

