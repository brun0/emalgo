Class {
	#name : #Maximizer,
	#superclass : #Object,
	#instVars : [
		'AlgoIteration',
		'candidateParameters',
		'nbSamples',
		'nbMove',
		'nbIterations'
	],
	#category : #'EM-Algo'
}

{ #category : #accessing }
Maximizer >> algoIteration [
	^ AlgoIteration
]

{ #category : #accessing }
Maximizer >> algoIteration: anObject [
	AlgoIteration := anObject
]

{ #category : #accessing }
Maximizer >> candidateParameters [
	^ candidateParameters
]

{ #category : #accessing }
Maximizer >> candidateParameters: anObject [
	candidateParameters := anObject
]

{ #category : #control }
Maximizer >> computeVraisemblance: aParameters [
|iterationParam|
iterationParam := self algoIteration psi.
self algoIteration psi: aParameters.
self algoIteration computeDs.
self algoIteration computeToursFqs.
self algoIteration computeTiq.
self algoIteration computeG.
self algoIteration psi: iterationParam.
^ self algoIteration g.

]

{ #category : #'initailize-release' }
Maximizer >> init [
	"Generate candidate parameters"
	| para alphas rhosPlus rhosMoins |
	alphas := OrderedCollection new.
	rhosPlus := OrderedCollection new.
	rhosMoins := OrderedCollection new.
	1 to: self nbSamples do: [ :i | 
		alphas add: i / self nbSamples * self algoIteration psiMax alpha.
		rhosPlus add: i / self nbSamples * self algoIteration psiMax rhoPlus.
		rhosMoins
			add: i / self nbSamples * self algoIteration psiMax rhoMoins ].
	alphas
		do: [ :a | 
			rhosPlus
				do: [ :rP | 
					rhosMoins
						do: [ :rM | 
							para := Parameters new.
							para alpha: a.
							para rhoMoins: rM.
							para rhoPlus: rP.
							para vraisemb: (self computeVraisemblance: para).
							self candidateParameters add: para ] ] ]
]

{ #category : #initialization }
Maximizer >> initialize [ 
self nbIterations: 8.
self nbMove: 5.
self nbSamples: 5.
self candidateParameters: OrderedCollection new.
]

{ #category : #control }
Maximizer >> maximizeParams [
| movedParams |
1 to: self nbMove do: [ :mov |
	movedParams := OrderedCollection new.
	self candidateParameters do: [ :cParam |
		movedParams add: (self moveParameterCandidate: cParam)].
	self candidateParameters: movedParams.
	 ]
]

{ #category : #control }
Maximizer >> moveParameterCandidate: aParameters [
	| vParam maxis da drM drP movedParam |
	maxis := self algoIteration psiMax.
	vParam := aParameters vraisemb.
	da := ((self
		computeVraisemblance: (aParameters copy alpha: aParameters alpha + (maxis alpha / 100)))
		- vParam) sign * (maxis alpha / 20).
	drM := ((self
		computeVraisemblance:
			(aParameters copy
				rhoMoins: aParameters rhoMoins + (maxis rhoMoins / 100))) - vParam)
		sign * (maxis rhoMoins / 20).
	drP := ((self
		computeVraisemblance:
			(aParameters copy rhoPlus: aParameters rhoPlus + (maxis rhoPlus / 100)))
		- vParam) sign * (maxis rhoPlus / 20).
	movedParam := aParameters copy moveA: da rM: drM rP: drP.
	movedParam vraisemb: (self computeVraisemblance: movedParam).
	^ movedParam
]

{ #category : #accessing }
Maximizer >> nbIterations [
	^ nbIterations
]

{ #category : #accessing }
Maximizer >> nbIterations: anObject [
	nbIterations := anObject
]

{ #category : #accessing }
Maximizer >> nbMove [
	^ nbMove
]

{ #category : #accessing }
Maximizer >> nbMove: anObject [
	nbMove := anObject
]

{ #category : #accessing }
Maximizer >> nbSamples [
	^ nbSamples
]

{ #category : #accessing }
Maximizer >> nbSamples: anObject [
	nbSamples := anObject
]
