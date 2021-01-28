Class {
	#name : #Population,
	#superclass : #Object,
	#instVars : [
		'subjects',
		'data'
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
		^s
]

{ #category : #initalize }
Population >> createTour: anObs [
	| tour |
	tour := Tour new.
	tour x_i: (anObs at: 'player.xi').
	tour xm_i: (anObs at: 'player.anticipation' ifAbsent: [ #NA ]).
	tour nb: (anObs at: 'subsession.round_number' ifAbsent: [ #NA ]).
	tour payoff: (anObs at: 'participant.payoff' ifAbsent: [ #NA ]).
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
	| label subject |
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
					subject addTour: (self createTour: obs) ] ]
]

{ #category : #initalize }
Population >> loadDefaultFile [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	| aFileRef reader |
	aFileRef := '/home/bruno/git/interexpe/data/etudiants-T1.csv' asFileReference.
	reader := (NeoCSVReader on: aFileRef readStream) separator: $;.
	reader namedColumnsConfiguration.
	self data: reader upToEnd
]

{ #category : #accessing }
Population >> subjects [
	^ subjects
]

{ #category : #accessing }
Population >> subjects: anObject [
	subjects := anObject
]
