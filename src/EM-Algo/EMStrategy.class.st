"
̀EMStrategỳ is the abstract super-class of EM-algo for representing theoretical economic behaviours as utility function

## Responsibility:
I know and compute the production function of the economic game, telling how much the subject get according to what he plays and what the other players play.

I provide abstract methods of utility computation in order for my subclasses to specify the theoretical behaviours.

## Collaborators: 

My subclasses to compute the production function.

# Public API and Key Messages

- Production function:  `EMStrategy>>#whatIGet:when:` (Compute how much I get when I invest myContrib and the other of the group invest othersContrib)


- Utility function: `EMStrategy>>#utilityOf:when:withParameters:` (Abstract method for my sublcasses. Give the utility of a choice according to a each behaviour)

- Computation of average gain of others: `EMStrategy>>#whatAnAverageOtherGet:when:`


## Example
```
""Compute how much I get when I invest 10 and the other of the group invest 30""
self whatIGet: 10 when: 30
```

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

{ #category : #'initailize-release' }
EMStrategy >> init [
"Parameterizing the production function once and for all, it is the definition of the Economic problem"
a:= 23.
b:= 0.25.
e:= 25
]

{ #category : #'initailize-release' }
EMStrategy >> initialize [

	self init
]

{ #category : #accessing }
EMStrategy >> pq [
	"for subclasses: tells the probability that a random subject belong to this strategy"
	^ pq
]

{ #category : #accessing }
EMStrategy >> pq: anObject [
	pq := anObject
]

{ #category : #control }
EMStrategy >> probaOf: myContrib when: othersContrib withParameters: parameters [
" Probability conditionnal on type q determined as a logit function "
"TODO: Algo may be optimized by saving d only the first time it is computed for these parameters"
 | choiceUtility d |

	choiceUtility := self utilityOf: myContrib when: othersContrib withParameters: parameters.
	d := (EMAlgo possibleContribs collect: [:potentialContrib |		 
				(self utilityOf: potentialContrib when: othersContrib withParameters: parameters) exp.
				]) sum.
			^ (choiceUtility exp) / d
]

{ #category : #control }
EMStrategy >> utilityOf: myContrib when: othersContrib withParameters: parameters [
	self subclassResponsibility 

]

{ #category : #control }
EMStrategy >> whatAnAverageOtherGet: myContrib when: othersContrib [
	"Give the average gain of others in this situation. It is used by some 'other regarding preferences' strategies"
	
	| groupContrib anAverageOtherContrib averageOtherGain |
	
	groupContrib := myContrib + othersContrib.
	anAverageOtherContrib := othersContrib / 7.
	averageOtherGain := self whatIGet: anAverageOtherContrib when: groupContrib - anAverageOtherContrib.
	^ averageOtherGain
]

{ #category : #control }
EMStrategy >> whatIGet: myContrib when: othersContrib [
	"Basic production function"
	"Example below for basic parametrisation a = 23, b = 0.25 and e = 25"
	"EMStrategy new whatIGet: 10 when: 50 >>> 95"
	
	| groupContrib |
	groupContrib := myContrib + othersContrib.
	
	^ e "basic endowment"
		- myContrib "what I put in the system"
		+ ((myContrib / groupContrib) "My proportion of contribution"
			* ((a * groupContrib) - (b * (groupContrib ** 2)))) "The whole group production"
]
