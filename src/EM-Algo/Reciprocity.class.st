Class {
	#name : #Reciprocity,
	#superclass : #EMStrategy,
	#category : #'EM-Algo'
}

{ #category : #control }
Reciprocity >> utilityMyContrib: x_i groupContrib: xm_i param: parameters [
	"Basic utility function"

	| rho |
	rho := parameters rhoMoins.
	x_i >= (xm_i / 7)
		ifTrue: [ rho := parameters rhoPlus ].
	^ (self uMyContrib: x_i groupContrib: xm_i)
		+
			(rho * 7 * (self
				uMyContrib: xm_i / 7
				groupContrib: xm_i + x_i - (xm_i / 7)))
]
