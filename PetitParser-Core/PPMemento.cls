"Filed out from Dolphin Smalltalk 7"!

Object subclass: #PPMemento
	instanceVariableNames: 'result count position'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPMemento guid: (GUID fromString: '{c9c56b7c-9c81-4de0-be20-acc1f8166e2c}')!
PPMemento comment: ''!
!PPMemento categoriesForClass!Unclassified! !
!PPMemento methodsFor!

count
	^ count!

increment
	count := count + 1!

initialize
	count := 0!

position
	^ position!

position: anInteger
	position := anInteger!

result
	^ result!

result: anObject
	result := anObject! !
!PPMemento categoriesFor: #count!accessing-readonly!public! !
!PPMemento categoriesFor: #increment!actions!public! !
!PPMemento categoriesFor: #initialize!initialization!public! !
!PPMemento categoriesFor: #position!accessing!public! !
!PPMemento categoriesFor: #position:!accessing!public! !
!PPMemento categoriesFor: #result!accessing!public! !
!PPMemento categoriesFor: #result:!accessing!public! !

!PPMemento class methodsFor!

new
	^ self basicNew initialize! !
!PPMemento class categoriesFor: #new!instance creation!public! !

