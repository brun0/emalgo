Class {
	#name : #Subject,
	#superclass : #Object,
	#instVars : [
		'tours',
		'id',
		'session',
		'possibleXs',
		'fiq'
	],
	#category : #'EM-Algo'
}

{ #category : #accessing }
Subject >> addTour: aTour [
self tours add: aTour
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
Subject >> tours [
	tours ifNil: [self tours: OrderedCollection new ].
	^ tours
]

{ #category : #accessing }
Subject >> tours: anObject [
	tours := anObject
]
