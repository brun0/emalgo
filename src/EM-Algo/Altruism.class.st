Class {
	#name : #Altruism,
	#superclass : #EMStrategy,
	#category : #'EM-Algo'
}

{ #category : #control }
Altruism >> utilityMyContrib: x_i groupContrib: xm_i param: parameters [
	"comment stating purpose of instance-side message"

	"scope: class-variables  &  instance-variables"

	| alpha u |
	alpha := parameters alpha.
	u := (self uMyContrib: x_i groupContrib: xm_i)
		+
			(alpha * 7
				* (self uMyContrib: xm_i / 7 groupContrib: xm_i + x_i - (xm_i / 7))).
	^ u / 100
]
