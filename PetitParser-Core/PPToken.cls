"Filed out from Dolphin Smalltalk 7"!

Object subclass: #PPToken
	instanceVariableNames: 'collection start stop value'
	classVariableNames: 'NewLineParser'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPToken guid: (GUID fromString: '{38ab4f58-5e52-40b6-a8e9-a8f2d8bf317a}')!
PPToken comment: ''!
!PPToken categoriesForClass!Unclassified! !
!PPToken methodsFor!

= anObject
	^ self class = anObject class and: [ self parsedValue = anObject parsedValue ]!

collection
	"Answer the underlying collection of this token."

	^ collection!

column
	"Answer the column number of this token in the underlying collection."
	
	| position |
	position := 0.
	(NewLineParser , [ :stream |
		start <= stream position
			ifTrue: [ ^ start - position ].
		position := stream position ] asParser
		/ #any asParser) star
			parse: collection.
	 ^ start - position!

copyFrom: aStartInteger to: aStopInteger
	^ self class on: collection start: start + aStartInteger - 1 stop: stop + aStopInteger - 3 value: value!

hash
	^ self parsedValue hash!

initializeOn: aSequenceableCollection start: aStartInteger stop: aStopInteger value: anObject
	collection := aSequenceableCollection.
	start := aStartInteger.
	stop := aStopInteger.
	value := anObject!

inputValue
	"Answer the consumed input of this token."

	^ collection copyFrom: start to: stop!

line
	"Answer the line number of this token in the underlying collection."
	
	| line |
	line := 1.
	(NewLineParser , [ :stream |
		start <= stream position
			ifTrue: [ ^ line ].
		line := line + 1 ] asParser
		/ #any asParser) star
			parse: collection.
	^ line!

parsedValue
	"Answer the parsed value of this token."

	^ value!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $[; print: self start; nextPut: $,; print: self stop; nextPut: $].
	aStream nextPut: $(; print: self parsedValue; nextPut: $)!

size
	"Answer the size of this token in the underlying collection."

	^ stop - start + 1!

start
	"Answer the start position of this token in the underlying collection."

	^ start!

stop
	"Answer the stop position of this token in the underlying collection."
	
	^ stop!

value
	self notify: 'Token>>#value is no longer supported. Instead use Token>>#inputValue or the more pragmatic #parsedValue.'.
	^ self inputValue! !
!PPToken categoriesFor: #=!comparing!public! !
!PPToken categoriesFor: #collection!accessing!public! !
!PPToken categoriesFor: #column!public!querying! !
!PPToken categoriesFor: #copyFrom:to:!copying!public! !
!PPToken categoriesFor: #hash!comparing!public! !
!PPToken categoriesFor: #initializeOn:start:stop:value:!initialization!public! !
!PPToken categoriesFor: #inputValue!accessing-values!public! !
!PPToken categoriesFor: #line!public!querying! !
!PPToken categoriesFor: #parsedValue!accessing-values!public! !
!PPToken categoriesFor: #printOn:!printing!public! !
!PPToken categoriesFor: #size!accessing!public! !
!PPToken categoriesFor: #start!accessing!public! !
!PPToken categoriesFor: #stop!accessing!public! !
!PPToken categoriesFor: #value!accessing-values!public! !

!PPToken class methodsFor!

initialize
	"Platform independent newline sequence. LF: Unix, CR+LF: Windows, and CR: Apple."

	NewLineParser := (Character lf asParser) / (Character cr asParser , Character lf asParser optional)!

new
	self error: 'Token can only be created using a dedicated constructor.'!

on: aSequenceableCollection
	^ self on: aSequenceableCollection start: 1 stop: aSequenceableCollection size value: nil!

on: aSequenceableCollection start: aStartInteger stop: aStopInteger value: anObject
	^ self basicNew 
		initializeOn: aSequenceableCollection
		start: aStartInteger stop: aStopInteger
		value: anObject! !
!PPToken class categoriesFor: #initialize!initialization!public! !
!PPToken class categoriesFor: #new!instance creation!public! !
!PPToken class categoriesFor: #on:!instance creation!public! !
!PPToken class categoriesFor: #on:start:stop:value:!instance creation!public! !

