"Filed out from Dolphin Smalltalk 7"!

PPParser subclass: #PPFailingParser
	instanceVariableNames: 'message'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPFailingParser guid: (GUID fromString: '{15cc9219-d678-4867-ae6e-e0a15c4047ab}')!
PPFailingParser comment: ''!
!PPFailingParser categoriesForClass!Unclassified! !
!PPFailingParser methodsFor!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self message = aParser message ]!

message
	"Answer the error message of the receiving parser."

	^ message!

printNameOn: aStream
	super printNameOn: aStream.
	aStream nextPutAll: ', '; print: message!

setMessage: aString
	message := aString! !
!PPFailingParser categoriesFor: #match:inContext:seen:!*petitanalyzer-matching!public! !
!PPFailingParser categoriesFor: #message!accessing!public! !
!PPFailingParser categoriesFor: #printNameOn:!printing!public! !
!PPFailingParser categoriesFor: #setMessage:!initialization!public! !

!PPFailingParser class methodsFor!

message: aString
	^ self new setMessage: aString! !
!PPFailingParser class categoriesFor: #message:!instance creation!public! !

