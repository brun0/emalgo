Class {
	#name : #Parameters,
	#superclass : #Object,
	#instVars : [
		'alpha',
		'rhoPlus',
		'rhoMoins',
		'vraisemb',
		'lastPoint',
		'visu'
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
Parameters >> lastPoint [
	^ lastPoint
]

{ #category : #accessing }
Parameters >> lastPoint: anObject [
	lastPoint := anObject
]

{ #category : #control }
Parameters >> moveA: da rM: drM rP: drP [
self lastPoint: self copy.
self alpha: ((self alpha + da) max: 0).
self rhoMoins: ((self rhoMoins + drM) max: 0).
self rhoPlus: ((self rhoPlus + drP) max: 0).
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
Parameters >> visu [
	^ visu
]

{ #category : #accessing }
Parameters >> visu: anObject [
	visu := anObject
]

{ #category : #accessing }
Parameters >> vraisemb [
	^ vraisemb
]

{ #category : #accessing }
Parameters >> vraisemb: anObject [
	vraisemb := anObject
]
