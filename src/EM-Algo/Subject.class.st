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
		'probasToBelongToStrategies'
	],
	#category : #'EM-Algo'
}

{ #category : #accessing }
Subject >> addTour: aTour [
self tours add: aTour
]

{ #category : #accessing }
Subject >> fi [
	^ fi
]

{ #category : #accessing }
Subject >> fi: anObject [
anObject < 0 ifTrue: [ self halt ].
	fi := anObject
]

{ #category : #accessing }
Subject >> fiq [
	^ fiq
]

{ #category : #accessing }
Subject >> fiq: anObject [
	fiq := anObject
]

{ #category : #accessing }
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
Subject >> initT1 [
self possibleXs: OrderedCollection new.
1 to: 25 do: [:i | self possibleXs add: i ]
]

{ #category : #accessing }
Subject >> possibleXs [
	^ possibleXs
]

{ #category : #accessing }
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
		p *=
		aStrategy probaOf: t contrib when: t expectationOfOtherContrib withParameters: aParameters]).
	^p
]

{ #category : #control }
Subject >> probaOfObsForAll: strategies withParameters: aParameters [
	"Computes the probability of observations considering all strategies"	
	
	^ (strategies collect: [ :s | s pq * (self probaOfObsConditionallyTo: s withParameters: aParameters)]) sum.
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
aProbaValue >= 1 ifTrue:[self halt].
aProbaValue <= 0 ifTrue:[self halt].
^ probasToBelongToStrategies at: aStrategy class name put: aProbaValue
]

{ #category : #accessing }
Subject >> tiq [
	^ tiq
]

{ #category : #accessing }
Subject >> tiq: anObject [
	tiq := anObject
]

{ #category : #accessing }
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
