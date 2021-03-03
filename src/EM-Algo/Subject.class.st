Class {
	#name : #Subject,
	#superclass : #Object,
	#instVars : [
		'tours',
		'id',
		'session',
		'possibleXs',
		'fiq',
		'fi',
		'probasToBelongToStrategies',
		'label'
	],
	#category : #'EM-Algo'
}

{ #category : #accessing }
Subject >> addTour: aTour [
self tours add: aTour
]

{ #category : #deprecated }
Subject >> fi [
	^ fi
]

{ #category : #deprecated }
Subject >> fi: anObject [
anObject < 0 ifTrue: [ self halt ].
	fi := anObject
]

{ #category : #deprecated }
Subject >> fiq [
	^ fiq
]

{ #category : #deprecated }
Subject >> fiq: anObject [
	fiq := anObject
]

{ #category : #deprecated }
Subject >> fiqAt: aStratName put: aValue [
aValue <= 0 ifTrue: [ self halt].
self fiq at: aStratName put: aValue
]

{ #category : #accessing }
Subject >> getProbaToBelongTo: aStrategy [
"get the proba of the last iteration"
^ probasToBelongToStrategies at: aStrategy class name
]

{ #category : #accessing }
Subject >> id [
	^ id
]

{ #category : #accessing }
Subject >> id: anObject [
	id := anObject
]

{ #category : #init }
Subject >> init [
probasToBelongToStrategies := Dictionary new.
self tours: OrderedCollection new.
]

{ #category : #init }
Subject >> initT1 [
self possibleXs: OrderedCollection new.
1 to: 25 do: [:i | self possibleXs add: i ]
]

{ #category : #accessing }
Subject >> label [
 label ifNil: [^ 'no label' ].
	^ label
]

{ #category : #accessing }
Subject >> label: anObject [

	label := anObject
]

{ #category : #deprecated }
Subject >> possibleXs [
	^ possibleXs
]

{ #category : #deprecated }
Subject >> possibleXs: anObject [
	possibleXs := anObject
]

{ #category : #control }
Subject >> probaOf: aStrategy withParameters: aParameters [
	"Computes the probability taht the subject is of the class of the strategy conditionnaly to what he played"	
	| p |
	p := 1.
	(self tours do: [: t | 
		p *=
		aStrategy probaOf: t contrib when: t expectationOfOtherContrib withParameters: aParameters]).
	^p
]

{ #category : #control }
Subject >> probaOfObsConditionallyTo: aStrategy withParameters: aParameters [
	"Computes the probability of observations considering a given strategy"	
	| p |
	p := 1.
	(self tours do: [: t | 
		p := p * 
			(aStrategy probaOf: t contrib when: t expectationOfOtherContrib withParameters: aParameters)]).
	^p
]

{ #category : #control }
Subject >> probaOfObsForAll: strategies withParameters: aParameters [
	"Computes the probability of observations considering all strategies"	
	
	^ (strategies collect: [ :s | s pq * (self probaOfObsConditionallyTo: s withParameters: aParameters)]) sum.
]

{ #category : #control }
Subject >> probaOfOneObs: aTour ObsConditionallyTo: aStrategy withParameters: aParameters [
	"Computes the probability of one observation considering a given strategy"

		^ aStrategy probaOf: aTour contrib when: aTour expectationOfOtherContrib withParameters: aParameters.

]

{ #category : #control }
Subject >> probaToBelongTo: aStrategy withParameters: aParameters considering: allStrategies [
	"Computes the probability of a subject to belong to astragegy conditionnaly to what he played"	
	^ aStrategy pq * 
		(self probaOfObsConditionallyTo: aStrategy withParameters: aParameters) / 
			(self probaOfObsForAll: allStrategies withParameters: aParameters)
]

{ #category : #control }
Subject >> probaToBelongTo: aStrategy withParameters: aParameters consideringAll: strategies [
	"Computes the probability of a subject to belong to astragegy conditionnaly to what he played"	
	^ aStrategy pq * 
		(self probaOfObsConditionallyTo: aStrategy withParameters: aParameters) / 
			(self probaOfObsForAll: strategies withParameters: aParameters)
]

{ #category : #accessing }
Subject >> session [
	^ session
]

{ #category : #accessing }
Subject >> session: anObject [
	session := anObject
]

{ #category : #accessing }
Subject >> setProbaToBelongTo: aStrategy to: aProbaValue [
"get the proba computed of the last iteration"
aProbaValue > 1 ifTrue:[self halt].
aProbaValue < 0 ifTrue:[self halt].
^ probasToBelongToStrategies at: aStrategy class name put: aProbaValue
]

{ #category : #visualization }
Subject >> show [
	| classes c p |
	c := RSChart new.
	p := RSScatterPlot new x: (self tours collect: [:t | t expectationOfOtherContrib]) y: (self tours collect: [:t | t contrib]).
	c addPlot: p.
	
	c xlabel: 'Other contrib'.
	c ylabel: 'My Contrib'.
	c title: 'Game of:', self label.
	c addDecoration: RSHorizontalTick new integer;
		addDecoration: RSVerticalTick new integer.
	^ c
]

{ #category : #deprecated }
Subject >> tiq [
	^ tiq
]

{ #category : #deprecated }
Subject >> tiq: anObject [
	tiq := anObject
]

{ #category : #deprecated }
Subject >> tiqAt: aStratName put: anObject [
	anObject < 0 ifTrue: [ self halt ].
	tiq at: aStratName put: anObject
]

{ #category : #accessing }
Subject >> tours [
	tours ifNil: [self tours: OrderedCollection new ].
	^ tours
]

{ #category : #accessing }
Subject >> tours: anObject [
	tours := anObject
]
