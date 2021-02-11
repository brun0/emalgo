Class {
	#name : #Parameters,
	#superclass : #PMVector,
	#type : #variable,
	#instVars : [
		'vraisemb',
		'lastPoint',
		'visu'
	],
	#category : #'EM-Algo'
}

{ #category : #'instance creation' }
Parameters class >> new [
^(self new: 3).
]

{ #category : #accessing }
Parameters >> alpha [
	^ self at: 1
]

{ #category : #accessing }
Parameters >> alpha: anObject [

	anObject < 0 ifTrue:[self halt].
	self at: 1 put: anObject
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
	^ self at: 2
]

{ #category : #accessing }
Parameters >> rhoMoins: anObject [
	
	anObject < 0 ifTrue:[self halt].
	self at: 2 put: anObject
]

{ #category : #accessing }
Parameters >> rhoPlus [
	^ self at: 3
]

{ #category : #accessing }
Parameters >> rhoPlus: anObject [

	anObject < 0 ifTrue:[self halt].
	self at: 3 put: anObject
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
