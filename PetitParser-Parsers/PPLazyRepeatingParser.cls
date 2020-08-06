"Filed out from Dolphin Smalltalk 7"!

PPLimitedRepeatingParser subclass: #PPLazyRepeatingParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PPLazyRepeatingParser guid: (GUID fromString: '{cefe44d4-3686-4be9-9fcc-5d8fe14bd8fa}')!
PPLazyRepeatingParser comment: 'A lazy repeating parser, commonly seen in regular expression implementations. It limits its consumption to meet the ''limit'' condition as early as possible.

This class essentially implements the iterative version of the following recursive parser composition:

	| parser |
	parser := PPChoiceParser new.
	parser setParsers: (Array
		with: (limit and ==> [ :each | OrderedCollection new ])
		with: (self , parser map: [ :each :rest | rest addFirst: each; yourself ])).
	^ parser ==> [ :rest | rest asArray ]'!
!PPLazyRepeatingParser categoriesForClass!Unclassified! !
