Class {
	#name : #Parameters,
	#superclass : #Object,
	#instVars : [
		'alpha',
		'rhoPlus',
		'rhoMoins',
		'vraisemb'
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

{ #category : #control }
Parameters >> moveA: da rM: drM rP: drP [
self alpha: ((self alpha + da) min: 0).
self rhoMoins: ((self rhoMoins + drM) min: 0).
self rhoPlus: ((self rhoPlus + drP) min: 0).
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

{ #category : #control }
Parameters >> sur: aDenominator [
| para |
para := self class new.
para alpha: self alpha / aDenominator.
para rhoPlus: self rhoPlus / aDenominator.
para rhoMoins: self rhoMoins / aDenominator.
^ para
]

{ #category : #accessing }
Parameters >> vraisemb [
	^ vraisemb
]

{ #category : #accessing }
Parameters >> vraisemb: anObject [
	vraisemb := anObject
]
