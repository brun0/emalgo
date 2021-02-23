Class {
	#name : #SelfInterst,
	#superclass : #EMStrategy,
	#category : #'EM-Algo'
}

{ #category : #control }
SelfInterst >> utilityOf: myContrib when: othersContrib withParameters: parameters [
	"Give the utility of investing myContrib in this situation"
	| u |
	u := self whatIGet: myContrib when: othersContrib.
	^ u
]
