"
Economic strategy

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #EMStrategy,
	#superclass : #Object,
	#instVars : [
		'e',
		'a',
		'b',
		'pq'
	],
	#category : #'EM-Algo'
}

{ #category : #accessing }
EMStrategy >> a [
	^ a
]

{ #category : #accessing }
EMStrategy >> a: anObject [
	a := anObject
]

{ #category : #accessing }
EMStrategy >> b [
	^ b
]

{ #category : #accessing }
EMStrategy >> b: anObject [
	b := anObject
]

{ #category : #accessing }
EMStrategy >> e [
	^ e
]

{ #category : #accessing }
EMStrategy >> e: anObject [
	e := anObject
]

{ #category : #'initailize-release' }
EMStrategy >> init [

self a: 23.
self b: 0.25.
self e: 25
]

{ #category : #'initailize-release' }
EMStrategy >> initialize [

self a: 23.
self b: 0.25.
self e: 25
]

{ #category : #accessing }
EMStrategy >> pq [
	^ pq
]

{ #category : #accessing }
EMStrategy >> pq: anObject [
	pq := anObject
]

{ #category : #control }
EMStrategy >> uMyContrib: x groupContrib: X [

	"basic utility function"

	^ e - x + (x / (x + X) * (a * (x + X) - (b * (x + (X ** 2)))))
]

{ #category : #control }
EMStrategy >> utilityMyContrib: x_i groupContrib: xm_i param: parameters [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	self subclassResponsibility 

]
