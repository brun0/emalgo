Class {
	#name : #Subject,
	#superclass : #Object,
	#instVars : [
		'tours',
		'id',
		'session'
	],
	#category : #'EM-Algo'
}

{ #category : #accessing }
Subject >> addTour: aTour [
self tours add: aTour
]

{ #category : #accessing }
Subject >> id [
	^ id
]

{ #category : #accessing }
Subject >> id: anObject [
	id := anObject
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
