Class {
	#name : #Altruism,
	#superclass : #EMStrategy,
	#category : #'EM-Algo'
}

{ #category : #control }
Altruism >> utilityOf: myContrib when: othersContrib withParameters: parameters [
	"Give the utility of investing myContrib in this situation"

	| alpha u |
	alpha := parameters alpha.
	u := (self whatIGet: myContrib when: othersContrib) "My monetary gain"
		+ (alpha * 
			(self whatAnAverageOtherGet: myContrib when: othersContrib)). "The averaged monetary gain of the others"
	^ u
]
