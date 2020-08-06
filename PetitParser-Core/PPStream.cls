"Filed out from Dolphin Smalltalk 7"!

ReadStream subclass: #PPStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPStream guid: (GUID fromString: '{30c42c95-0d14-44a1-95fc-af83039ac0e9}')!
PPStream comment: ''!
!PPStream categoriesForClass!Unclassified! !
!PPStream methodsFor!

asPetitStream
	^ self!

collection
	"Answer the underlying collection."
	
	^ collection!

next: anInteger 
	"Answer the next anInteger elements of my collection.  overriden for efficiency"

	| ans endPosition |

	endPosition := position + anInteger  min:  readLimit.
	ans := collection copyFrom: position+1 to: endPosition.
	position := endPosition.
	^ans
!

peek
	"An improved version of peek, that is slightly faster than the built in version."

	^ self atEnd ifFalse: [ collection at: position + 1 ]!

position: anInteger
	"The receiver does not check for invalid arguments passed to this method, as it is solely used with valid indexes for backtracking."

	position := anInteger!

printOn: aStream 
	collection isString
		ifFalse: [^ super printOn: aStream].
	aStream
		nextPutAll: (collection copyFrom: 1 to: position);
		 nextPutAll: '.';
		
		nextPutAll: (collection copyFrom: position + 1 to: readLimit)!

uncheckedPeek
	"An unchecked version of peek that throws an error if we try to peek over the end of the stream, even faster than #peek."

	^ collection at: position + 1! !
!PPStream categoriesFor: #asPetitStream!converting!public! !
!PPStream categoriesFor: #collection!accessing!public! !
!PPStream categoriesFor: #next:!public! !
!PPStream categoriesFor: #peek!accessing!public! !
!PPStream categoriesFor: #position:!accessing!public! !
!PPStream categoriesFor: #printOn:!printing!public! !
!PPStream categoriesFor: #uncheckedPeek!accessing!public! !

