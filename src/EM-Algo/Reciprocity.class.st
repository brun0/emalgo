Class {
	#name : #Reciprocity,
	#superclass : #EMStrategy,
	#category : #'EM-Algo'
}

{ #category : #control }
Reciprocity >> utilityOf: myContrib when: othersContrib withParameters: parameters [
	"Give the utility of investing myContrib in this situation"

	| rho u |
	myContrib >= (othersContrib / 7) ifTrue: [ rho := parameters rhoPlus.
	u := ((1 - rho) * (self whatIGet: myContrib when: othersContrib))
	     + (rho * 
				(self whatAnAverageOtherGet: myContrib when: othersContrib))]
	ifFalse:[	rho := parameters rhoMoins.
			u := ((1 - rho) * (self whatIGet: myContrib when: othersContrib))
	     - (rho * 
				(self whatAnAverageOtherGet: myContrib when: othersContrib))
			]. "My monetary gain" "The averaged monetary gain of the others"
	^ u
]
