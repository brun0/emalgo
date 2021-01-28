Class {
	#name : #Tour,
	#superclass : #Object,
	#instVars : [
		'x_i',
		'xm_i',
		'payoff',
		'nb',
		'subject'
	],
	#category : #'EM-Algo'
}

{ #category : #accessing }
Tour >> nb [
	^ nb
]

{ #category : #accessing }
Tour >> nb: anObject [
	nb := anObject
]

{ #category : #accessing }
Tour >> payoff [
	^ payoff
]

{ #category : #accessing }
Tour >> payoff: anObject [
	payoff := anObject
]

{ #category : #accessing }
Tour >> subject [
	^ subject
]

{ #category : #accessing }
Tour >> subject: anObject [
	subject := anObject
]

{ #category : #accessing }
Tour >> x_i [
	^ x_i
]

{ #category : #accessing }
Tour >> x_i: anObject [
	x_i := anObject
]

{ #category : #accessing }
Tour >> xm_i [
	^ xm_i
]

{ #category : #accessing }
Tour >> xm_i: anObject [
	xm_i := anObject
]
