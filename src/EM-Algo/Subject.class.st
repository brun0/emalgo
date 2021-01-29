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
		'tiq'
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

{ #category : #accessing }
Subject >> session [
	^ session
]

{ #category : #accessing }
Subject >> session: anObject [
	session := anObject
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
	anObject <= 0 ifTrue: [ self halt ].
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
