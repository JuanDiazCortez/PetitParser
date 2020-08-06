"Filed out from Dolphin Smalltalk 7"!

Object subclass: #PPFailure
	instanceVariableNames: 'message position'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPFailure guid: (GUID fromString: '{f5c861e2-7b2d-4818-b3a4-548b5e1a34dd}')!
PPFailure comment: ''!
!PPFailure categoriesForClass!Unclassified! !
!PPFailure methodsFor!

initializeMessage: aString at: anInteger
	message := aString.
	position := anInteger!

isPetitFailure
	"I am the only class that should implement this method to return true."

	^ true!

message
	"Answer a human readable error message of this parse failure."
	
	^ message!

position
	"Answer the position in the source string that caused this parse failure."

	^ position!

printOn: aStream
	aStream nextPutAll: self message; nextPutAll: ' at '; print: position!

reason: aMessage  at:aIndex

	^self initializeMessage: aMessage at: aIndex! !
!PPFailure categoriesFor: #initializeMessage:at:!initialization!public! !
!PPFailure categoriesFor: #isPetitFailure!public! !
!PPFailure categoriesFor: #message!accessing!public! !
!PPFailure categoriesFor: #position!accessing!public! !
!PPFailure categoriesFor: #printOn:!printing!public! !
!PPFailure categoriesFor: #reason:at:!public! !

!PPFailure class methodsFor!

message: aString at: anInteger
	^ self basicNew initializeMessage: aString at: anInteger!

reason: aString at: anInteger
	^ self basicNew initializeMessage: aString at: anInteger! !
!PPFailure class categoriesFor: #message:at:!instance creation!public! !
!PPFailure class categoriesFor: #reason:at:!instance creation!public! !

