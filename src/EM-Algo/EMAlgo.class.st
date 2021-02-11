"
Algo to associate subjects and strategies by Expectation Maximization

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
	#name : #EMAlgo,
	#superclass : #Object,
	#instVars : [
		'population',
		'strategies',
		'dataFolder',
		'psi',
		'psiMax',
		'ds',
		'possibleXs',
		'g',
		'maximizer',
		'rNG'
	],
	#category : #'EM-Algo'
}

{ #category : #examples }
EMAlgo class >> example0 [
	"comment stating purpose of class-side message"

	| algo maxim |
	algo := self new.
	algo population: Population new.
	algo population
		loadDefaultFile;
		generatePopulation.
	algo init.
	algo initT1.
	algo computeDs.
	algo initPq.
	algo computeToursFqs.
	algo computeTiq.
	algo computeG.
	maxim := Maximizer new.
	maxim algoIteration: algo.
	algo maximizer: maxim.
	maxim init.
	maxim maximizeParams.
	^maxim
	"algo updatePqs.
	^algo"
]

{ #category : #examples }
EMAlgo class >> example1 [
	"comment stating purpose of class-side message"
	
	| algo |
	algo := self new.
	algo dataFolder: '/home/bruno/git/interexpe-data/formated-data/'.
	algo population: Population new.
	algo population loadDataFile: (algo dataFolder , 'game-data.csv') asFileReference.
	
]

{ #category : #examples }
EMAlgo class >> exampleHill0 [
	"comment stating purpose of class-side message"

	| algo maxim |
	algo := self new.
	algo population: Population new.
	algo population
		loadDefaultFile;
		generatePopulation.
	algo init.
	algo initT1.
	algo computeDs.
	algo initPq.
	algo computeToursFqs.
	algo computeTiq.
	algo computeG.
	maxim := Maximizer new.
	maxim algoIteration: algo.
	algo maximizer: maxim.
	maxim init.
	maxim hillClimMaximizeParams.
	^maxim
	"algo updatePqs.
	^algo"
]

{ #category : #control }
EMAlgo >> computeDs [
"For optimisation purposes we compute this table only once"
"Find all usefull anticipations"
|xmis dico dicoS gain |

xmis:= Set new.
self population subjects do: [: subj | subj tours 
	do:[: tour | xmis add: tour xm_i] 
	].

dico := Dictionary new.
	self strategies do: [ :strat | 
		dicoS := Dictionary new.
		xmis do: [:xmi | 
			gain := 0.
			self possibleXs do: [: x |
				gain := gain + 
				((strat utilityMyContrib: x groupContrib: xmi param: self psi) exp)].
			dicoS at: xmi put: gain].
		dico at: strat class name put: dicoS].
	self ds: dico

]

{ #category : #control }
EMAlgo >> computeG [
	| fiq |
	self g: 0.
	self population subjects
		do: [ :sub | 
			self strategies
				do: [ :strat | 
					fiq := sub fiq at: strat class name.
					fiq <= 0 ifTrue: [ self halt].
					self
						g:
							self g + ((sub tiq at: strat class name)
								* (strat pq log + ((fiq) log)))]]
]

{ #category : #control }
EMAlgo >> computeTiq [
"Proba d'appartenance au type q de l'individu i à cette itération"
	| denom |
self population subjects do: [ : sub |
	sub tiq: Dictionary new.
	denom := 0.
	self strategies do: [ :strat |
		denom := denom + ((strat pq) * (sub fiq at: strat class name)).
	].
	self strategies do: [ :strat |
		sub tiqAt: strat class name put: ((strat pq) * (sub fiq at: strat class name)) / denom  ]
 ]
]

{ #category : #control }
EMAlgo >> computeToursFqs [
	"Compute fq for each turn "

	| fqx fiq |
	self population subjects
		do: [ :s | 
			s fi: 0.
			s fiq: Dictionary new.
			self strategies
					do: [ :strat | 
						s fiqAt: strat class name put: 1].
			(s tours select: [: t | t x_i + (t xm_i) > 0])
				do: [ :t | 
					t fq: Dictionary new.
					self strategies
						do: [ :strat | 
							fqx := ((strat utilityMyContrib: t x_i groupContrib: t xm_i param: self psi) exp
										/ (self ds at: strat class name) at: t xm_i).
							t fq
								at: strat class name
								put: fqx.
								fiq := (s fiq at: strat class name) * fqx.
								s fiqAt: strat class name put: fiq.]
									 ] 
								].
	self population subjects
		do: [ :s | 
			s fi: 0.
			self strategies
				do: [ :strat | 
			s fi: s fi + ((s fiq at: strat class name) * (strat pq) )
			]]
					
				
]

{ #category : #accessing }
EMAlgo >> dataFolder [
	^ dataFolder
]

{ #category : #accessing }
EMAlgo >> dataFolder: anObject [
	dataFolder := anObject
]

{ #category : #accessing }
EMAlgo >> ds [
	^ ds
]

{ #category : #accessing }
EMAlgo >> ds: anObject [
	ds := anObject
]

{ #category : #accessing }
EMAlgo >> g [
	^ g
]

{ #category : #accessing }
EMAlgo >> g: anObject [
	g := anObject
]

{ #category : #'initailize-release' }
EMAlgo >> init [
self intializeStrategies.
self initParameters.
self rNG: Random new.

]

{ #category : #'initailize-release' }
EMAlgo >> initParameters [
"Strategies parameters"
self psiMax: Parameters new.
self psiMax alpha: 1/5.
self psiMax rhoMoins: 1/5.
self psiMax rhoPlus: 1/5.
self psi: (self psiMax sur: 2).

]

{ #category : #'initailize-release' }
EMAlgo >> initPq [
"Probas (proportions of individuals from each strategy)"
| nbStrat |
nbStrat := self strategies size.
self strategies do: [:s | s pq: 1 / nbStrat ].

]

{ #category : #'initailize-release' }
EMAlgo >> initT1 [
self possibleXs: OrderedCollection new.
1 to: 25 do: [:i | self possibleXs add: i ]
]

{ #category : #'initailize-release' }
EMAlgo >> intializeStrategies [
| alt si rec|
	alt := Altruism new.
	si := SelfInterst new.
	rec := Reciprocity new.
	self strategies add: alt.
	self strategies add: si.
	self strategies add: rec.
]

{ #category : #accessing }
EMAlgo >> maximizer [
	^ maximizer
]

{ #category : #accessing }
EMAlgo >> maximizer: anObject [
	maximizer := anObject
]

{ #category : #accessing }
EMAlgo >> population [
	^ population
]

{ #category : #accessing }
EMAlgo >> population: anObject [
	population := anObject
]

{ #category : #accessing }
EMAlgo >> possibleXs [
	^ possibleXs
]

{ #category : #accessing }
EMAlgo >> possibleXs: anObject [
	possibleXs := anObject
]

{ #category : #accessing }
EMAlgo >> psi [
	^ psi
]

{ #category : #accessing }
EMAlgo >> psi: anObject [
	psi := anObject
]

{ #category : #accessing }
EMAlgo >> psiMax [
	^ psiMax
]

{ #category : #accessing }
EMAlgo >> psiMax: anObject [
	psiMax := anObject
]

{ #category : #accessing }
EMAlgo >> rNG [
	^ rNG
]

{ #category : #accessing }
EMAlgo >> rNG: anObject [
	rNG := anObject
]

{ #category : #accessing }
EMAlgo >> strategies [

	^ strategies ifNil: [self strategies: Set new. ^ strategies]
]

{ #category : #accessing }
EMAlgo >> strategies: anObject [
	strategies := anObject
]

{ #category : #control }
EMAlgo >> updatePqs [
	"Compute new values of pqs"	

| tiqs |
self strategies do: [:strat |
	tiqs := (self population subjects asOrderedCollection collect: [:sub | sub tiq at: strat class name ]). 
	strat pq: (tiqs sumNumbers)  / (tiqs size)].
]
