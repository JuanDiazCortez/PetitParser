"Filed out from Dolphin Smalltalk 7"!

PPCompositeParserTest subclass: #PPSqlGrammarTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPSqlGrammarTests guid: (GUID fromString: '{ae1fa3c8-706a-4970-b31f-ae395fcc03ef}')!
PPSqlGrammarTests comment: ''!
!PPSqlGrammarTests categoriesForClass!PetitSQL-Tests! !
!PPSqlGrammarTests methodsFor!

parserClass
	^ PPSqlGrammar!

testCreate1
	self parse: 'CREATE foo (a) WITH VALUES (1)'!

testCreate2
	self parse: 'CREATE foo (a, b) WITH VALUES (1, 2)'!

testCreate3
	self parse: 'CREATE foo (a, b, c) WITH VALUES (1, 2, "foo bar")'!

testDelete1
	self parse: 'DELETE FROM foo'!

testDelete2
	self parse: 'DELETE FROM "ZorkCommander" WHERE a = 43'!

testInsert1
	self parse: 'INSERT INTO foo (a) VALUES ("This is a longer string")'!

testInsert2
	self parse: 'INSERT INTO foo ("a", b) VALUES (1, "2")'!

testInsert3
	self parse: 'INSERT INTO foo (a, b, c) VALUES (1, 2, 3)'!

testSelect1
	self parse: 'SELECT * FROM foo'!

testSelect2
	self parse: 'SELECT a, b, c FROM foo'!

testSelect3
	self parse: 'SELECT * FROM foo WHERE a !!= b'!

testSelect4
	self parse: 'SELECT * FROM foo LIMIT 13'!

testSelect5
	self parse: 'SELECT * FROM foo WHERE a > 12 LIMIT 13'!

testUpdate1
	self parse: 'UPDATE foo SET a = 12'!

testUpdate2
	self parse: 'UPDATE foo SET a = 12 WHERE b >= 13'! !
!PPSqlGrammarTests categoriesFor: #parserClass!accessing!public! !
!PPSqlGrammarTests categoriesFor: #testCreate1!public!testing! !
!PPSqlGrammarTests categoriesFor: #testCreate2!public!testing! !
!PPSqlGrammarTests categoriesFor: #testCreate3!public!testing! !
!PPSqlGrammarTests categoriesFor: #testDelete1!public!testing! !
!PPSqlGrammarTests categoriesFor: #testDelete2!public!testing! !
!PPSqlGrammarTests categoriesFor: #testInsert1!public!testing! !
!PPSqlGrammarTests categoriesFor: #testInsert2!public!testing! !
!PPSqlGrammarTests categoriesFor: #testInsert3!public!testing! !
!PPSqlGrammarTests categoriesFor: #testSelect1!public!testing! !
!PPSqlGrammarTests categoriesFor: #testSelect2!public!testing! !
!PPSqlGrammarTests categoriesFor: #testSelect3!public!testing! !
!PPSqlGrammarTests categoriesFor: #testSelect4!public!testing! !
!PPSqlGrammarTests categoriesFor: #testSelect5!public!testing! !
!PPSqlGrammarTests categoriesFor: #testUpdate1!public!testing! !
!PPSqlGrammarTests categoriesFor: #testUpdate2!public!testing! !

