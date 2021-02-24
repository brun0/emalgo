Class {
	#name : #Tour,
	#superclass : #Object,
	#instVars : [
		'contrib',
		'expectationOfOtherContrib',
		'payoff',
		'nb',
		'subject',
		'fq'
	],
	#category : #'EM-Algo'
}

{ #category : #accessing }
Tour >> contrib [

	^ contrib
]

{ #category : #accessing }
Tour >> contrib: anObject [

	contrib := anObject
]

{ #category : #accessing }
Tour >> expectationOfOtherContrib [

	^ expectationOfOtherContrib
]

{ #category : #accessing }
Tour >> expectationOfOtherContrib: anObject [

	expectationOfOtherContrib := anObject
]

{ #category : #accessing }
Tour >> fq [
	^ fq
]

{ #category : #accessing }
Tour >> fq: anObject [
	fq := anObject
]

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
