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
	tour contrib: (anObs at: 'player.xi') asNumber.
	tour expectationOfOtherContrib: (anObs at: 'player.anticipation' ifAbsent: [  ^nil ]) asNumber.
	tour nb: (anObs at: 'subsession.round_number' ifAbsent: [ ^nil ]) asNumber.
	tour payoff: (anObs at: 'participant.payoff' ifAbsent: [ ^nil ]) asNumber.
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
							t subject: subject ] ] ]
]

{ #category : #initalize }
Population >> loadDataFile: aFileRef [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	| reader |
	reader := (NeoCSVReader on: aFileRef readStream) separator: $;.
	reader namedColumnsConfiguration.
	self data: reader upToEnd
]

{ #category : #initalize }
Population >> loadDefaultFile [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	self loadDataFile: '/home/bruno/git/interexpe/data/etudiants-T1.csv' asFileReference
]

{ #category : #accessing }
Population >> subjects [
	^ subjects
]

{ #category : #accessing }
Population >> subjects: anObject [
	subjects := anObject
]
