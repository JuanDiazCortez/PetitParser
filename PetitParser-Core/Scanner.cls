"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Scanner
	instanceVariableNames: 'source mark hereChar aheadChar token tokenType currentComment buffer typeTable'
	classVariableNames: 'AllowBlockArgumentAssignment AllowUnderscoreAssignments AllowUnderscoreSelectors AllowUnicharSymbol DoItCharacter TypeTable'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Scanner guid: (GUID fromString: '{3bf72dbf-4155-44c4-a9c9-22ea30a389fc}')!
Scanner comment: 'I scan a string or text, picking out Smalltalk syntactic tokens. I look one character ahead. I put each token found into the instance variable, token, and its type (a Symbol) into the variable, tokenType. At the end of the input stream, I pretend to see an endless sequence of special characters called doIts.

Instance Variables
	aheadChar:		<Character>
	buffer:		<WriteStream>
	currentComment:		<OrderedCollection>
	hereChar:		<Character>
	mark:		<Integer>
	source:		<ReadStream>
	token:		<Symbol|String|NumberCharacter|Boolean|nil>
	tokenType:		<Symbol>
	typeTable:		<Array>

aheadChar
	- the next character in the input stream

buffer
	- a reusable WriteStream on a String which is used for building strings. Shouldn''t be used from multiple methods without resetting.

currentComment
	- an OrderedCollection of strings which contain all comments between the current token and the previous token or the beginning of the source.

hereChar
	- the current character

mark
	- the position of the current token in the source stream

source
	- the input stream of characters

token
	- the current token

tokenType
	- the type of the current token. The possible token types are: #binary, #character, #colon, #doIt, #keyword, #leftArrow, #leftBrace, #leftBracket, #leftParenthesis, #literal, #period, #rightBrace, #rightBracket, #rightParenthesis, #semicolon, #string, #upArrow, #verticalBar, #word, #xBinary, #xColon, #xDelimiter, #xDigit, #xDollar, #xDoubleQuote, #xLetter, #xLitQuote, #xSingleQuote, #xUnderscore

typeTable
	- an array that maps each an evaluable tokenType to each character with asciiValue between 0 and 255'!
!Scanner categoriesForClass!Kernel-Objects! !
!Scanner methodsFor!

advance

	| prevToken |
	prevToken := token.
	self scanToken.
	^prevToken!

allowUnderscoreAssignments
	"Query preference"
	^self class allowUnderscoreAsAssignment!

allowUnderscoreSelectors
	"Query preference"
	^self class prefAllowUnderscoreSelectors!

ambiguousSelector: aString inRange: anInterval
	"Compile with backward compatibility: $- is part of literal argument.."
	
	token := token asSymbol.
	^self!

initialize

	super initialize.
	buffer := WriteStream on: (String new: 40).
	typeTable := TypeTable!

initScannerForTokenization
	"Use a version of typeTable that doesn't raise xIllegal when enocuntering an _"
	| underscoreIndex |
	underscoreIndex := typeTable identityIndexOf: #xUnderscore ifAbsent: [^self].
	typeTable := typeTable copy.
	typeTable at: underscoreIndex put: #xUnderscoreForTokenization.
	typeTable at: (typeTable identityIndexOf: #xLitQuote) put: #xLitQuoteForTokenization!

nextLiteral
	"Same as advance, but -4 comes back as a number instead of two tokens"

	| prevToken |
	prevToken := self advance.
	(prevToken == #- and: [token isKindOf: Number])
		ifTrue: 
			[^self advance negated].
	^prevToken!

notify: string 
	"Refer to the comment in Object|notify:." 
	self error: string!

notify: string at: posiiton
	"Parser compatible message"
	 
	^self notify: string !

offEnd: aString 
	"Parser overrides this"

	^self notify: aString!

scan: inputStream 
	"Bind the input stream, fill the character buffers and first token buffer."

	source := inputStream.
	self step.
	self step.
	self scanToken!

scanAllTokenPositionsInto: aBlock
	"Evaluate aBlock with the start and end positions of all separate non-white-space tokens, including comments."

	| lastMark |
	lastMark := 1.
	[currentComment ifNotNil:
		[currentComment do:
			[:cmnt| | idx |
			 idx := source originalContents indexOfSubCollection: cmnt startingAt: lastMark.
			 (idx > 0 and: [idx < mark]) ifTrue:
				[aBlock value: idx - 1 value: (lastMark := idx + cmnt size)]].
		 currentComment := nil].
	mark ifNotNil:
		[(token == #- 
		  and: [(self typeTableAt: hereChar) == #xDigit]) ifTrue:
			[| savedMark |
			 savedMark := mark.
			 self scanToken.
			 token := token negated.
			 mark := savedMark].
		"Compensate for the fact that the parser uses two character lookahead.  Normally we must
		  remove the extra two characters.  But this mustn't happen for the last token at the end of stream."
		 aBlock
			value: mark
			value: source position - (aheadChar == DoItCharacter
				ifTrue: [hereChar == DoItCharacter
					ifTrue: [0]
					ifFalse: [1]]
				ifFalse: [2])].
	 (tokenType == #rightParenthesis
	  or: [tokenType == #doIt]) ifTrue:
		[^self].
	tokenType == #leftParenthesis
		ifTrue: 
			[self scanToken; scanAllTokenPositionsInto: aBlock]
		ifFalse: 
			[(tokenType == #word or: [tokenType == #keyword or: [tokenType == #colon]])
				ifTrue: 
					[self scanLitWord.
					 token == #true ifTrue: [token := true].
					 token == #false ifTrue: [token := false].
					 token == #nil ifTrue: [token := nil]]
				ifFalse:
					[(token == #- 
					  and: [(self typeTableAt: hereChar) == #xDigit])
						ifTrue: 
							[self scanToken.
							 token := token negated]]].
		self scanToken ] repeat!

scanFieldNames: stringOrArray
	"Answer an Array of Strings that are the identifiers in the input string, 
	stringOrArray. If passed an Array, just answer with that Array, i.e., 
	assume it has already been scanned."

	| strm |
	(stringOrArray isMemberOf: Array)
		ifTrue: [^stringOrArray].
	self scan: (ReadStream on: stringOrArray asString).
	strm := WriteStream on: (Array new: 10).
	[tokenType == #doIt]
		whileFalse: 
			[tokenType == #word ifTrue: [strm nextPut: token].
			self scanToken].
	^strm contents

	"Scanner new scanFieldNames: 'abc  def ghi' ('abc' 'def' 'ghi' )"!

scanLitByteVec
	| stream |
	stream := (ByteArray new: 16) writeStream.
	[ tokenType == #rightBracket or: [ tokenType == #doIt ] ] whileFalse: [
		tokenType == #word
			ifTrue: [ self scanLitWord ].
		(token isInteger and: [ token between: 0 and: 255 ])
			ifFalse: [ ^ self offEnd: '8-bit integer or right bracket expected' ].
		stream nextPut: token.
		self scanToken ].
	token := stream contents!

scanLitVec
	| s |
	s := WriteStream on: (Array new: 16).
	[tokenType == #rightParenthesis or: [tokenType == #doIt]] whileFalse:
		[tokenType == #leftParenthesis
			ifTrue: 
				[self scanToken; scanLitVec]
			ifFalse: 
				[(tokenType == #word or: [tokenType == #keyword or: [tokenType == #colon]])
					ifTrue: 
						[self scanLitWord.
						token == #true ifTrue: [token := true].
						token == #false ifTrue: [token := false].
						token == #nil ifTrue: [token := nil]]
					ifFalse:
						[(token isCharacter and: [tokenType ~~ #character])
							ifTrue: [token := token asSymbol]
							ifFalse: [(token == #- 
								  and: [(self typeTableAt: hereChar) == #xDigit]) ifTrue: 
									[self scanToken.
									 token := token negated]]]].
		s nextPut: token.
		self scanToken].
	token := s contents!

scanLitWord
	"Accumulate keywords and asSymbol the result."

	token := (String streamContents: [ :stream |
		stream nextPutAll: token.
		[ (self typeTableAt: hereChar) == #xLetter ] whileTrue: [
			self xLetter.
			stream nextPutAll: token ] ]) asSymbol!

scanMessageParts: sourceString
	"Return an array of the form (comment keyword comment arg comment keyword comment arg comment) for the message pattern of this method.  Courtesy of Ted Kaehler, June 1999"

	| coll nonKeywords |
	coll := OrderedCollection new.
	self scan: (ReadStream on: sourceString asString).
	nonKeywords := 0.
	[tokenType == #doIt] whileFalse:
		[(currentComment == nil or: [currentComment isEmpty])
			ifTrue: [coll addLast: nil]
			ifFalse: [coll addLast: currentComment removeFirst.
				[currentComment isEmpty] whileFalse:
					[coll at: coll size put: (coll last, ' ', currentComment removeFirst)]].
		(token numArgs < 1 or: [token = #| and: [ coll size > 1 ] ])
			ifTrue: [(nonKeywords := nonKeywords + 1) > 1 ifTrue: [^ coll]]
						"done with header"
			ifFalse: [nonKeywords := 0].
		coll addLast: token.
		self scanToken].
	(currentComment == nil or: [currentComment isEmpty])
		ifTrue: [coll addLast: nil]
		ifFalse: [coll addLast: currentComment removeFirst.
			[currentComment isEmpty] whileFalse: [
				coll at: coll size put: (coll last, ' ', currentComment removeFirst)]].
	^ coll!

scanStringStruct

	| s |
	s := WriteStream on: (Array new: 16).
	[tokenType == #rightParenthesis or: [tokenType == #doIt]]
		whileFalse: 
			[tokenType == #leftParenthesis
				ifTrue: 
					[self scanToken; scanStringStruct]
				ifFalse: 
					[tokenType == #word ifFalse:
						[^self error: 'only words and parens allowed']].
			s nextPut: token.
			self scanToken].
	token := s contents!

scanStringStruct: textOrString 
	"The input is a string whose elements are identifiers and parenthesized
	 groups of identifiers.  Answer an array reflecting that structure, representing
	 each identifier by an uninterned string."

	self scan: (ReadStream on: textOrString asString).
	self scanStringStruct.
	^token

	"Scanner new scanStringStruct: 'a b (c d) (e f g)'"!

scanToken

	[(tokenType := self typeTableAt: hereChar) == #xDelimiter]
		whileTrue: [self step].  "Skip delimiters fast, there almost always is one."
	mark := aheadChar == DoItCharacter
		ifTrue: [hereChar == DoItCharacter
			ifTrue: [source position + 1]
			ifFalse: [source position]]
		ifFalse: [source position - 1].
	(tokenType at: 1) == $x "x as first letter"
		ifTrue: [self perform: tokenType "means perform to compute token & type"]
		ifFalse: [token := self step "else just unique the first char"].
	^token!

scanTokenPositionsIn: textOrString into: aBlock
	"Evaluate aBlock with the start and end positions of all separate non-white-space tokens, including comments, in textOrString."

	self initScannerForTokenization.
	source := (ReadStream on: textOrString asString).
	self step.
	self step.
	self scanAllTokenPositionsInto: aBlock

	"| code |
	code := '       #( 1 2 #( 3 4 ))  16r123 123 123.0  ', (Scanner sourceCodeAt: #scanTokenPositionsIn:into:).
	Scanner new scanTokenPositionsIn: code into: [:start :end| Transcript cr; nextPut: $_; nextPutAll: (code copyFrom: start to: end); nextPut: $_; endEntry]"

	"CodeDiffBuilder buildDisplayPatchFrom:  (Scanner sourceCodeAt: #scanTokenPositionsIn:into:) to:  ((Scanner sourceCodeAt: #scanTokenPositionsIn:into:) copyReplaceAll: (String with: Character cr) with: '')"

	"CodeDiffBuilder buildDisplayPatchFrom:  'colorTable ^colorTable ifNil: [colorTable _ ST80ColorTable]' to:'colorTable ^colorTable ifNil: [colorTable _ ST80ColorTable]'"!

scanTokens: textOrString 
	"Answer an Array that has been tokenized as though the input text, 
	textOrString, had appeared between the array delimitors #( and ) in a 
	Smalltalk literal expression."

	self scan: (ReadStream on: textOrString asString).
	self scanLitVec.
	^token

	"Scanner new scanTokens: 'identifier keyword: 8r31 ''string'' .'"!

step

	| c |
	c := hereChar.
	hereChar := aheadChar.
	source atEnd
		ifTrue: [aheadChar := DoItCharacter]
		ifFalse: [aheadChar := source next].
	^c!

typedScan: textOrString do: aBinaryBlock
	"Evaluate aBinaryBlock with the token and its type for the first token in input,
	 mapping literals to type #literal and anything else to type #word."
	| theTokensType atNumber theToken |
	self initScannerForTokenization.
	self scan: (ReadStream on: textOrString asString).
	atNumber := hereChar notNil and: [hereChar isDigit].
	theTokensType := tokenType.
	theToken := self advance.
	(theToken == #- and: [atNumber and: [token isNumber]]) ifTrue:
		[theToken := self advance negated].
	theToken isNumber ifTrue: [theTokensType := #number].
	^aBinaryBlock
		value: theToken
		value: ((#(number string literal character) includes: theTokensType)
				ifTrue: [#literal]
				ifFalse: [#word])!

typedScanTokens: textOrString 
	"Answer an Array that has been tokenized with literals mapped to literals,
	 special characters mapped to symbols and variable names and keywords
	 to strings. This methiod accepts _ (underscore) as an assignment token
	 irrespective of whether the system prefers := as the assignment token."
	| s |
	self initScannerForTokenization.
	self scan: (ReadStream on: textOrString asString).
	s := WriteStream on: (Array new: 16).
	[tokenType == #doIt] whileFalse:
		[(token == #- 
		  and: [(self typeTableAt: hereChar) == #xDigit]) ifTrue: 
			[self scanToken.
			 token := token negated].
		s nextPut: token.
		self scanToken].
	^s contents

	"Scanner new typedScanTokens: (Scanner sourceCodeAt: #typedScanTokens:)"!

typeTableAt: aCharacter
	^typeTable
		at: aCharacter charCode
		ifAbsent:
			[aCharacter == DoItCharacter
				ifTrue: [#doIt]
				ifFalse: [#xLetter]]!

xBinary

	| startOfToken |
	tokenType := #binary.
	startOfToken := mark.
	token := String with: self step.
	[(self typeTableAt: hereChar) == #xBinary or: [(self typeTableAt: hereChar) == #verticalBar]] whileTrue:
		[(hereChar == $- and: [(self typeTableAt: aheadChar) == #xDigit])
			ifTrue: [^self ambiguousSelector: (token , '-')
					inRange: (startOfToken to: source position - 1).].
		token := token, (String with: self step)].
	token := token asSymbol!

xColon
	"Allow := for assignment"
	
	aheadChar == $= ifTrue:
		[self step.
		tokenType := #leftArrow.
		self step.
		^ token := #':='].
	"Otherwise, just do what normal scan of colon would do"
	tokenType := #colon.
	^ token := self step asSymbol!

xDelimiter
	"Ignore blanks, etc."

	self scanToken!

xDigit
	"Form a number."

	tokenType := #number.
	aheadChar == DoItCharacter
		ifTrue: [source skip: -1 "Read off the end last time"]
		ifFalse: [source skip: -2].
	token := (SqNumberParser on: source)
		failBlock: [:errorString :position | self notify: errorString at:position];
		nextNumber.
	self step; step!

xDollar
	"Form a Character literal."

	aheadChar == DoItCharacter
		ifTrue:
			[mark := mark + 1. "Let the notification lie behind the dollar"
			^self offEnd: 'A Character was expected'].
	self step. "pass over $"
	token := self step.
	tokenType := #character!

xDoubleQuote
    "Collect a comment."

	buffer reset.
	self step.
	[ hereChar == $" ] whileFalse: [
		hereChar == DoItCharacter ifTrue: [
			^self offEnd: 'Unmatched comment quote' ].
		buffer nextPut: self step ].
	self step.
	(currentComment ifNil: [ 
		currentComment := OrderedCollection new ])
			add: buffer contents.
	self scanToken!

xIllegal
	"An illegal character was encountered"
	self notify: 'Illegal character (char code ' , hereChar charCode , ' ' , hereChar charCode storeStringHex , ')' at: mark!

xLetter
	"Form a word or keyword."

	| type |
	buffer reset.
	[(type := self typeTableAt: hereChar) == #xLetter
		or: [type == #xDigit
		or: [type == #xUnderscore and:[self allowUnderscoreSelectors]]]] whileTrue:
			["open code step for speed"
			buffer nextPut: hereChar.
			hereChar := aheadChar.
			aheadChar := source atEnd
							ifTrue: [DoItCharacter]
							ifFalse: [source next]].
	tokenType := (type == #xColon and: [aheadChar ~~ $=])
					ifTrue: 
						[buffer nextPut: self step.
						"Allow any number of embedded colons in literal symbols"
						[(self typeTableAt: hereChar) == #xColon] whileTrue:
							[buffer nextPut: self step].
						#keyword]
					ifFalse: 
						[#word].
	token := buffer contents!

xLitQuote
	"Symbols and vectors: #(1 (4 5) 2 3) #ifTrue:ifFalse: #'abc'."
	| start |
	start := mark.
	self step. "litQuote"
	self scanToken.
	tokenType == #leftParenthesis
		ifTrue: [self scanToken; scanLitVec.
			mark := start + 1.
			tokenType == #doIt
				ifTrue: [self offEnd: 'Unmatched parenthesis']]
		ifFalse: [tokenType == #leftBracket
				ifTrue: [self scanToken; scanLitByteVec.
					mark := start + 1.
					tokenType == #doIt
						ifTrue: [self offEnd: 'Unmatched bracket']]
				ifFalse: [(tokenType == #word or: [tokenType == #keyword or: [tokenType == #colon]])
						ifTrue: [self scanLitWord]
						ifFalse: [(tokenType == #string or: [ tokenType == #verticalBar ])
							ifTrue: [token := token asSymbol]
							ifFalse: [tokenType == #binary 
								ifFalse: [(token isCharacter and: [tokenType ~~ #character and: [self class prefAllowUnicharSymbol]])
									ifTrue: [token := token asSymbol]
									ifFalse: [self notify: 'Invalid literal character' at: start + 1]]]]]].
	mark := start.
	tokenType := #literal

	"#(Pen)
	#Pen
	#'Pen'
	"!

xLitQuoteForTokenization
	"Parse underscores as per the regular parser when following a # symbol, so that e.g. #_WIN32 is correctly tokenized."
	| index |
	index :=  typeTable identityIndexOf: #xUnderscoreForTokenization ifAbsent: [^self xLitQuote].
	typeTable at: index put: #xUnderscore.
	[self xLitQuote] ensure:
		[typeTable at: index put: #xUnderscoreForTokenization]!

xSingleQuote
	"String."

	self step.
	buffer reset.
	[hereChar == $' 
		and: [aheadChar == $' 
				ifTrue: [self step. false]
				ifFalse: [true]]]
		whileFalse: 
			[hereChar == DoItCharacter
				ifTrue: [^self offEnd: 'Unmatched string quote'].
			buffer nextPut: self step].
	self step.
	token := buffer contents.
	tokenType := #string!

xUnderscore
	self allowUnderscoreAssignments ifTrue:
		"Figure out if x _foo (no space between _ and foo) should be a selector or assignment."
		[(self allowUnderscoreSelectors
		  and: [#(xLetter xDigit xUnderscore xColon) includes: (self typeTableAt: aheadChar)])
			ifFalse:
				[self step.
				 tokenType := #leftArrow.
				 ^token := #'_']].
	self allowUnderscoreSelectors ifTrue:
		[^self xLetter].
	^self xIllegal!

xUnderscoreForTokenization
	"Parse underscores as assignments so as to be able to correctly tokenize ancient source code."
	self step.
	tokenType := #leftArrow.
	^token := #'_'! !
!Scanner categoriesFor: #advance!expression types!public! !
!Scanner categoriesFor: #allowUnderscoreAssignments!private! !
!Scanner categoriesFor: #allowUnderscoreSelectors!private! !
!Scanner categoriesFor: #ambiguousSelector:inRange:!error handling!public! !
!Scanner categoriesFor: #initialize!initialize/release!public! !
!Scanner categoriesFor: #initScannerForTokenization!initialize/release!public! !
!Scanner categoriesFor: #nextLiteral!*Etoys/Squeakland/expression types!public! !
!Scanner categoriesFor: #notify:!error handling!public! !
!Scanner categoriesFor: #notify:at:!error handling!public! !
!Scanner categoriesFor: #offEnd:!error handling!public! !
!Scanner categoriesFor: #scan:!initialize/release!public! !
!Scanner categoriesFor: #scanAllTokenPositionsInto:!expression types!public! !
!Scanner categoriesFor: #scanFieldNames:!public!public access! !
!Scanner categoriesFor: #scanLitByteVec!expression types!public! !
!Scanner categoriesFor: #scanLitVec!expression types!public! !
!Scanner categoriesFor: #scanLitWord!expression types!public! !
!Scanner categoriesFor: #scanMessageParts:!public!public access! !
!Scanner categoriesFor: #scanStringStruct!expression types!public! !
!Scanner categoriesFor: #scanStringStruct:!public!public access! !
!Scanner categoriesFor: #scanToken!expression types!public! !
!Scanner categoriesFor: #scanTokenPositionsIn:into:!public!public access! !
!Scanner categoriesFor: #scanTokens:!public!public access! !
!Scanner categoriesFor: #step!expression types!public! !
!Scanner categoriesFor: #typedScan:do:!public!public access! !
!Scanner categoriesFor: #typedScanTokens:!public!public access! !
!Scanner categoriesFor: #typeTableAt:!multi/character scans!public! !
!Scanner categoriesFor: #xBinary!multi/character scans!public! !
!Scanner categoriesFor: #xColon!multi/character scans!public! !
!Scanner categoriesFor: #xDelimiter!multi/character scans!public! !
!Scanner categoriesFor: #xDigit!multi/character scans!public! !
!Scanner categoriesFor: #xDollar!multi/character scans!public! !
!Scanner categoriesFor: #xDoubleQuote!multi/character scans!public! !
!Scanner categoriesFor: #xIllegal!multi/character scans!public! !
!Scanner categoriesFor: #xLetter!multi/character scans!public! !
!Scanner categoriesFor: #xLitQuote!multi/character scans!public! !
!Scanner categoriesFor: #xLitQuoteForTokenization!multi/character scans!public! !
!Scanner categoriesFor: #xSingleQuote!multi/character scans!public! !
!Scanner categoriesFor: #xUnderscore!multi/character scans!public! !
!Scanner categoriesFor: #xUnderscoreForTokenization!multi/character scans!public! !

!Scanner class methodsFor!

allowBlockArgumentAssignment
	"Accessor for the system-wide preference"
	
	"<preference: 'Allow block argument assignment.'
		category: 'Compiler'
		description: 'If enabled, the compiler will allow assignment into block arguments.
This provides backward compatibility with the pre-closure compiler.'
		type: #Boolean>"
	^AllowBlockArgumentAssignment ifNil: [ false ]!

allowBlockArgumentAssignment: aBoolean
	"Accessor for the system-wide preference"
	
	AllowBlockArgumentAssignment := aBoolean!

allowUnderscoreAsAssignment
	"Accessor for the system-wide preference"
	
	^AllowUnderscoreAssignments ifNil:[true]!

allowUnderscoreAsAssignment: aBool
	"Accessor for the system-wide preference"
	AllowUnderscoreAssignments := aBool!

initialize
	
	self initializeTypeTable.
	"The unicode ending with FFFE or FFFF are non characters and can be used by applications if they wish.
	We use last legal unicode 16r10FFFF to encode the end of source stream"
	"DoItCharacter := Character value: 16r10FFFF"!

initializeTypeTable
	"self initializeTypeTable"

	| newTable |
	newTable := Array new: 256 withAll: #xBinary. "default"
	newTable atAll: #(9 10 12 13 32 ) put: #xDelimiter. "tab lf ff cr space"
	newTable atAll: ($0 asciiValue to: $9 asciiValue) put: #xDigit.

	1 to: 255
		do: [:index |
			(Character value: index) isLetter
				ifTrue: [newTable at: index put: #xLetter]].

	newTable at: $" asciiValue put: #xDoubleQuote.
	newTable at: $# asciiValue put: #xLitQuote.
	newTable at: $$ asciiValue put: #xDollar.
	newTable at: $' asciiValue put: #xSingleQuote.
	newTable at: $: asciiValue put: #xColon.
	newTable at: $( asciiValue put: #leftParenthesis.
	newTable at: $) asciiValue put: #rightParenthesis.
	newTable at: $. asciiValue put: #period.
	newTable at: $; asciiValue put: #semicolon.
	newTable at: $[ asciiValue put: #leftBracket.
	newTable at: $] asciiValue put: #rightBracket.
	newTable at: ${ asciiValue put: #leftBrace.
	newTable at: $} asciiValue put: #rightBrace.
	newTable at: $^ asciiValue put: #upArrow.
	newTable at: $_ asciiValue put: #xUnderscore.
	newTable at: $| asciiValue put: #verticalBar.
	TypeTable := newTable "bon voyage!!"!

inviolateInstanceVariableNames
	"Answer a list of instance variable names not to be used.  (Place holder for real list)"
	^ #('thisContext' 'self')!

isLegalInstVarName: aString
	"Answer whether aString is a legal instance variable name."

	^ ((self isLiteralSymbol: aString) and: [(aString includes: $:) not]) and:
		[(self inviolateInstanceVariableNames includes:  aString) not]!

isLiteralSymbol: aSymbol 
	"Test whether a symbol can be stored as # followed by its characters.  
	Symbols created internally with asSymbol may not have this property, 
	e.g. '3' asSymbol."

	| i ascii type next last |
	i := aSymbol size.
	i = 0 ifTrue: [^ false].

	"TypeTable should have been origined at 0 rather than 1 ..."
	ascii := (aSymbol at: 1) asciiValue.
	type := TypeTable at: ascii ifAbsent: [^false].
	type == #xLetter ifTrue: [
		next := last := nil.
		[i > 1]
				whileTrue: 
					[ascii := (aSymbol at: i) asciiValue.
					type := TypeTable at: ascii ifAbsent: [^false].
					(type == #xLetter or: [type == #xDigit or: [type == #xColon
							and: [
								next == nil
									ifTrue: [last := #xColon. true] 
									ifFalse: [last == #xColon and: [next ~~ #xDigit and: [next ~~ #xColon]]]]]])
						ifFalse: [^ false].
					next := type.
					i := i - 1].
			^ true].
	type == #xBinary ifTrue:
		[^(2 to: i) allSatisfy: [:j |
			ascii := (aSymbol at: j) asciiValue.
			(TypeTable at: ascii ifAbsent: []) == #xBinary]].
	type == #verticalBar ifTrue: [^i = 1].
	^false!

prefAllowUnderscoreAssignments
	"Accessor for the system-wide preference"
	
	self deprecated: 'Use #allowUnderscoreAsAssignment'.
	^self allowUnderscoreAsAssignment!

prefAllowUnderscoreAssignments: aBool
	"Accessor for the system-wide preference"
	
	self deprecated: 'Use #allowUnderscoreAsAssignment:'.
	self allowUnderscoreAsAssignment: aBool!

prefAllowUnderscoreSelectors
	"Accessor for the system-wide preference"
	"<preference: 'Allow underscore selectors'
		category: 'Compiler'
		description: 'When true, underscore can be used in selectors and varibable names'
		type: #Boolean>"
	^AllowUnderscoreSelectors ifNil:[false]!

prefAllowUnderscoreSelectors: aBool
	"Accessor for the system-wide preference"
	AllowUnderscoreSelectors := aBool.
	
	"Reinitialize String's tokenish character map"
	String initialize!

prefAllowUnicharSymbol
	"Accessor for the system-wide preference"
	"<preference: 'Allow symbols with unique character like #,'
		category: 'Compiler'
		description: 'When true, the historical syntax #, #; or #. is allowed.'
		type: #Boolean>"
	^AllowUnicharSymbol ifNil: [false]!

prefAllowUnicharSymbol: aBoolean
	"Accessor for the system-wide preference"
	AllowUnicharSymbol := aBoolean!

wellFormedInstanceVariableNameFrom: aString
	"Answer a legal instance variable name, derived from aString"

	| cleansedString |
	cleansedString := aString select: [:ch | ch isDigit or: [ch isLetter]].
	(cleansedString isEmpty or: [cleansedString first isDigit])
		ifTrue: [cleansedString := 'a', cleansedString]
		ifFalse:	[cleansedString := cleansedString withFirstCharacterDownshifted].

	[self isLegalInstVarName: cleansedString] whileFalse:
		[cleansedString := cleansedString, 'x'].
	^ cleansedString

"Scanner wellFormedInstanceVariableNameFrom:  '234 xx\ Uml /ler42342380-4'"! !
!Scanner class categoriesFor: #allowBlockArgumentAssignment!preferences!public! !
!Scanner class categoriesFor: #allowBlockArgumentAssignment:!preferences!public! !
!Scanner class categoriesFor: #allowUnderscoreAsAssignment!preferences!public! !
!Scanner class categoriesFor: #allowUnderscoreAsAssignment:!preferences!public! !
!Scanner class categoriesFor: #initialize!initialization!public! !
!Scanner class categoriesFor: #initializeTypeTable!initialization!public! !
!Scanner class categoriesFor: #inviolateInstanceVariableNames!public!testing! !
!Scanner class categoriesFor: #isLegalInstVarName:!public!testing! !
!Scanner class categoriesFor: #isLiteralSymbol:!public!testing! !
!Scanner class categoriesFor: #prefAllowUnderscoreAssignments!preferences!public! !
!Scanner class categoriesFor: #prefAllowUnderscoreAssignments:!preferences!public! !
!Scanner class categoriesFor: #prefAllowUnderscoreSelectors!preferences!public! !
!Scanner class categoriesFor: #prefAllowUnderscoreSelectors:!preferences!public! !
!Scanner class categoriesFor: #prefAllowUnicharSymbol!preferences!public! !
!Scanner class categoriesFor: #prefAllowUnicharSymbol:!preferences!public! !
!Scanner class categoriesFor: #wellFormedInstanceVariableNameFrom:!public!testing! !

