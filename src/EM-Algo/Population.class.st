Class {
	#name : #Population,
	#superclass : #Object,
	#instVars : [
		'subjects',
		'data',
		'rGN'
	],
	#category : #'EM-Algo'
}

{ #category : #initalize }
Population >> createSubjectLabel: aString fromObs: anObs [
	| s |
	s := Subject new.
		self subjects at: aString put: s.
		s id: anObs.
		s session: (anObs at: 'session.code').
		s init.
		^s
]

{ #category : #initalize }
Population >> createTour: anObs [
	| tour |
	tour := Tour new.
	tour contrib: (anObs at: 'player.xi') asNumber.
	tour expectationOfOtherContrib: (anObs at: 'player.anticipation' ifAbsent: [  ^nil ]) asNumber.
	tour nb: (anObs at: 'subsession.round_number' ifAbsent: [ ^nil ]) asNumber.
	tour payoff: (anObs at: 'participant.payoff' ifAbsent: [ ^nil ]) asNumber.
	(tour contrib == 0 and: [ tour expectationOfOtherContrib == 0 ]) ifTrue: [^ nil].
	^ tour
]

{ #category : #accessing }
Population >> data [
	^ data
]

{ #category : #accessing }
Population >> data: anObject [
	data := anObject
]

{ #category : #initalize }
Population >> generatePopulation [
	| label subject t |
	self loadDefaultFile.
	self subjects: Dictionary new.
	self data asOrderedCollection
		do: [ :obs | 
			label := obs at: 'participant.label' ifAbsent: [ #unknown ].
			self subjects
				at: label
				ifAbsent: [ self createSubjectLabel: label fromObs: obs ].
			(obs includesKey: 'player.xi')
				ifTrue: [ subject := self subjects at: label.
					t := self createTour: obs.
					t ifNotNil: [ subject addTour: t.
							t subject: subject ] ] ].
				self subjects keysAndValuesRemove: [:key :sub | sub tours isEmpty ]
]

{ #category : #initalize }
Population >> generateSyntheticPopOf: strategies withParameters: aParameters [ 
"Generate subjects of all strategies with noise"
" |strats| strats := OrderedCollection new. strats add: Altruism new. strats add: Reciprocity new. Population new generateSyntheticPopOf: strats withParameters: (Parameters new alpha: 5; rhoMoins: 5;rhoPlus:5) >>> 'the population to be inspected' "

	| subject tour normalError |
	normalError := PMNormalDistribution new.
	self subjects: Dictionary new.
	strategies do: [: aStrat |
		1 to: 15 do: [: i |
			subject := Subject new.
			subject init.
			subject label: (aStrat class name , '_', i asString).
			self subjects at: subject label put: subject.
			1 to: 20 do: [:tn | tour := Tour new.
			tour expectationOfOtherContrib: (EMAlgo possibleContribs atRandom) * 7 .
			tour contrib: (aStrat bestChoiceWhen: tour expectationOfOtherContrib whenParameters: aParameters) + (normalError random).
			tour nb: tn.
			subject addTour: tour.
			 ]]
		 ]
]

{ #category : #initalize }
Population >> loadDataFile: aFileRef [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	| reader |
	reader := (NeoCSVReader on: aFileRef readStream) separator: $;.
	reader namedColumnsConfiguration.
	self data: reader upToEnd.
]

{ #category : #initalize }
Population >> loadDefaultFile [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	self loadDataFile: '/home/bruno/git/interexpe/data/etudiants-T1.csv' asFileReference
]

{ #category : #accessing }
Population >> rGN [

	^ rGN
]

{ #category : #accessing }
Population >> rGN: anObject [

	rGN := anObject
]

{ #category : #accessing }
Population >> subjects [
	^ subjects
]

{ #category : #accessing }
Population >> subjects: anObject [
	subjects := anObject
]
