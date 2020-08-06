"Filed out from Dolphin Smalltalk 7"!

PPDelegateParser subclass: #PPMemoizedParser
	instanceVariableNames: 'stream buffer'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPMemoizedParser guid: (GUID fromString: '{a6f51a6f-5cad-48e2-9055-57363cf1556f}')!
PPMemoizedParser comment: ''!
!PPMemoizedParser categoriesForClass!Unclassified! !
!PPMemoizedParser methodsFor!

memoized
	"Ther is no point in memoizing more than once."

	^ self!

reset: aStream
	stream := aStream.
	buffer := Array new: aStream size + 1! !
!PPMemoizedParser categoriesFor: #memoized!operators!public! !
!PPMemoizedParser categoriesFor: #reset:!public! !

