Class {
	#name : #SelfInterst,
	#superclass : #EMStrategy,
	#category : #'EM-Algo'
}

{ #category : #control }
SelfInterst >> utilityMyContrib: x_i groupContrib: xm_i param: parameters [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	| u |
	u := self uMyContrib: x_i groupContrib: xm_i.
	^ u
]
