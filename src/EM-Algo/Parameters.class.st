Class {
	#name : #Parameters,
	#superclass : #Object,
	#instVars : [
		'alpha',
		'rhoPlus',
		'rhoMoins'
	],
	#category : #'EM-Algo'
}

{ #category : #accessing }
Parameters >> alpha [
	^ alpha
]

{ #category : #accessing }
Parameters >> alpha: anObject [
	alpha := anObject
]

{ #category : #accessing }
Parameters >> rhoMoins [
	^ rhoMoins
]

{ #category : #accessing }
Parameters >> rhoMoins: anObject [
	rhoMoins := anObject
]

{ #category : #accessing }
Parameters >> rhoPlus [
	^ rhoPlus
]

{ #category : #accessing }
Parameters >> rhoPlus: anObject [
	rhoPlus := anObject
]
