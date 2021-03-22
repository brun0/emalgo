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
		'g',
		'maximizer',
		'rNG',
		'parametersEvolution'
	],
	#classVars : [
		'currentInstance',
		'possibleContribs'
	],
	#category : #'EM-Algo'
}

{ #category : #accessing }
EMAlgo class >> currentInstance [
"Nessessary for using polymath optimizer (Maximizer class)"
^ currentInstance 
]

{ #category : #accessing }
EMAlgo class >> currentInstance: anObject [

	currentInstance := anObject
]

{ #category : #examples }
EMAlgo class >> example [
	"Example with the new version of algorithm"

	| algo |
	self initT1.
	algo := self new.
	EMAlgo currentInstance: algo.
	algo init.
	algo population: Population new.
	algo population rGN: algo rNG.
	algo population 
		generateSyntheticPopOf: algo strategies 
		withParameters: (Parameters new alpha: 0.8; rhoMoins: 0.8; rhoPlus: 0.8).
	algo initPq.
	algo computeSubjectsProbasOfStrategies.
	algo updateShares.
	algo estimateParametersSimply.
	1 to: 20 do: [: i |
		algo computeSubjectsProbasOfStrategies.
		algo updateShares.
		algo estimateParametersSimply].
	^ algo
]

{ #category : #deprecated }
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

{ #category : #deprecated }
EMAlgo class >> example1 [
	"comment stating purpose of class-side message"
	
	| algo |
	algo := self new.
	algo dataFolder: '/home/bruno/git/interexpe-data/formated-data/'.
	algo population: Population new.
	algo population loadDataFile: (algo dataFolder , 'game-data.csv') asFileReference.
	
]

{ #category : #deprecated }
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

{ #category : #examples }
EMAlgo class >> exampleInitClasses [
	"Example with the new version of algorithm"

	| algo |
	self initT1.
	algo := self new.
	EMAlgo currentInstance: algo.
	algo init.
	algo population: Population new.
	algo population rGN: algo rNG.
	algo population 
		generateSyntheticPopOf: algo strategies 
		withParameters: (Parameters new alpha: 0.8; rhoMoins: 0.8; rhoPlus: 0.8).
	algo initPq.
	algo initSubjectsProbasOfStrategies.
	algo updateShares.
	algo estimateParametersSimply.
	1 to: 20 do: [: i |
		algo computeSubjectsProbasOfStrategies.
		algo updateShares.
		algo estimateParametersSimply].
	^ algo
]

{ #category : #'initailize-release' }
EMAlgo class >> initT1 [
possibleContribs := OrderedCollection new.
1 to: 25 do: [:i | self possibleContribs add: i ]
]

{ #category : #accessing }
EMAlgo class >> possibleContribs [

	^ possibleContribs
]

{ #category : #obsolete }
EMAlgo >> computeDs [
"For optimisation purposes we compute this table only once"
"Find all usefull anticipations"
|xmis dico dicoS gain |

xmis:= Set new.
self population subjects do: [: subj | subj tours 
	do:[: tour | xmis add: tour expectationOfOtherContrib ] 
	].

dico := Dictionary new.
	self strategies do: [ :strat | 
		dicoS := Dictionary new.
		xmis do: [:xmi | 
			gain := 0.
			self possibleXs do: [: x |
				gain := gain + 
				((strat utilityOf: x when: xmi withParameters: self psi) exp)].
			dicoS at: xmi put: gain].
		dico at: strat class name put: dicoS].
	self ds: dico

]

{ #category : #obsolete }
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
EMAlgo >> computeLogLikelyhood [

	self sub
]

{ #category : #control }
EMAlgo >> computeSubjectsProbasOfStrategies [
"Computes the Proba that each subejct belong to a strategy (a class) at a given iteration"

self population subjects do: [ : sub |
	self strategies do: [: strat |
		sub setProbaToBelongTo: strat to: 
		(sub probaToBelongTo: strat 
			withParameters: self psi 
			considering: self strategies) ]
 ]
]

{ #category : #obsolete }
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

{ #category : #obsolete }
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
			(s tours select: [: t | t contrib + (t expectationOfOtherContrib) > 0])
				do: [ :t | 
					t fq: Dictionary new.
					self strategies
						do: [ :strat | 
							fqx := ((strat utilityOf: t contrib when: t expectationOfOtherContrib withParameters: self psi) exp
										/ (self ds at: strat class name) at: t expectationOfOtherContrib ).
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

{ #category : #visualization }
EMAlgo >> diplaySamples [
" Display one graph per strategy with sample subjects games on porbability map "
self population showSampleOf12Subjects 
]

{ #category : #visualization }
EMAlgo >> displayProbasOf: aStrategy on: aRSChart [
]

{ #category : #visualization }
EMAlgo >> displayProbasOf: aStrategy on: aRSChart withParameters: aParameters [
| tiles othersContrib plot canvas xScale yScale|
	canvas := aRSChart canvas.
	xScale := aRSChart plots first xScale.
	yScale := aRSChart plots first yScale.
	tiles := OrderedCollection new.
	self class possibleContribs do: [:myContrib |
		self class possibleContribs do: [:aContrib |
			othersContrib := aContrib * 7.
			tiles add: (RSBox new
		position: (xScale scale: othersContrib) @ (yScale scale: myContrib);
		extent: ((((xScale scale: 0) - (xScale scale:175)) /(self class possibleContribs size)) abs)@((((yScale scale: 0) - (yScale scale:25)) /(self class possibleContribs size)) abs);
		model: (aStrategy probaOf: myContrib when: othersContrib withParameters: aParameters);
		popup;
		yourself). ]
	 	].
	tiles do: [:aTile |
		canvas addShape: aTile
		 ].
		RSNormalizer color
			shapes: tiles;
			normalize: #yourself.
]

{ #category : #visualization }
EMAlgo >> displayProbasOf: aStrategy withParameters: aParameters [

| aRSChart p1 |
aRSChart := RSChart new.
p1 := RSScatterPlot new x: #(0 10 175) y: #(0 10 25).
"p1 createXScale. 
p1 createYScale."
aRSChart addPlot: p1.
aRSChart show.
self displayProbasOf: aStrategy on: aRSChart withParameters: aParameters.
aRSChart show
]

{ #category : #visualization }
EMAlgo >> displaySomePlayersGamesOverProbasOf: aStrategy withParameters: aParameters [

| aRSChart p1 n |
aRSChart := RSChart new.
n := 12.
p1 := RSScatterPlot new x: #(0 10 175) y: #(0 10 25).
"p1 createXScale. 
p1 createYScale."
aRSChart addPlot: p1.
aRSChart build.
aRSChart addDecoration: (RSChartTitleDecoration new title: 'Game of ', (n asString) , ' subjects over proba distribution of ', (aStrategy class name asString); fontSize: 7.5).
self displayProbasOf: aStrategy on: aRSChart withParameters: aParameters.
self population showSampleOf: n on: aRSChart.
]

{ #category : #visualization }
EMAlgo >> displaySomePlayersGamesOverProbasOfStrategieswithParameters: aParameters [

self strategies do: [:strat | 
	self displaySomePlayersGamesOverProbasOf: strat  withParameters: aParameters
].
]

{ #category : #accessing }
EMAlgo >> ds [
	^ ds
]

{ #category : #accessing }
EMAlgo >> ds: anObject [
	ds := anObject
]

{ #category : #'as yet unclassified' }
EMAlgo >> estimateAltruismParameter [

| step nbStep candidates scores bestScore bestA strat|

strat := self strategies detect: [: s| s class = Altruism  ].
nbStep := 20.
bestA := self psiMax alpha.
step := (self psiMax alpha) / nbStep.
candidates := OrderedCollection new.
scores := Dictionary new.
bestScore := 100000 negated.
1 to: nbStep do: [:i |
	candidates add: i * step].
candidates do: [:alpha |  
	| score |
	score := EMAlgo currentInstance 
		logLikelyhoodTermOf: strat 
		withParameters: (Parameters new alpha: alpha).
		scores at: alpha put: score.
	score > bestScore ifTrue: [ 
		bestScore := score. 
		bestA := alpha ]
	].
^ bestA




]

{ #category : #control }
EMAlgo >> estimateParameters [

| maxim |
self strategies do: [: strat |
		maxim := Maximizer new.
		maxim algoIteration: self.
		self maximizer: maxim.
		maxim init.
		maxim hillClimMaximizeParameterOf: strat.
		strat parameterEstimations: maxim candidateParameters.
	].
]

{ #category : #control }
EMAlgo >> estimateParametersSimply [

| rhos |

parametersEvolution add: self psi copy.
self psi alpha: self estimateAltruismParameter.
rhos := self estimateReciprocityParameters.
self psi rhoMoins: rhos x.
self psi rhoPlus: rhos y.
]

{ #category : #'as yet unclassified' }
EMAlgo >> estimateReciprocityParameters [

| step nbStep candidates scores bestScore strat bestRMP |

strat := self strategies detect: [: s| s class = Reciprocity  ].
nbStep := 20.
bestRMP := (self psiMax rhoMoins) @ (self psiMax rhoPlus).
step := (self psiMax rhoMoins) / nbStep.
candidates := OrderedCollection new.
scores := Dictionary new.
bestScore := 100000 negated.
1 to: nbStep do: [:i |
	1 to: nbStep do: [:j |
	candidates add: (i * step) @ (j * step)
	]].
candidates do: [:rMP |  
	| score |
	score := EMAlgo currentInstance 
		logLikelyhoodTermOf: strat 
		withParameters: (Parameters new rhoMoins: rMP x; rhoPlus: rMP y).
		scores at: rMP put: score.
	score > bestScore ifTrue: [ 
		bestScore := score. 
		bestRMP := rMP ]
	].
^ bestRMP




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
parametersEvolution := OrderedCollection new.
self rNG: Random new.

]

{ #category : #'initailize-release' }
EMAlgo >> initParameters [
"Strategies parameters"
self psiMax: Parameters new.
self psiMax alpha: 0.999999.
self psiMax rhoMoins: 0.99999.
self psiMax rhoPlus: 0.999999.
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
EMAlgo >> initSubjectsProbasOfStrategies [
"Computes the Proba that each subejct belong to a strategy (a class) at a given iteration"
self population subjects do: [ : sub |
	self strategies do: [: strat |
		sub setProbaToBelongTo: strat to: 0.01 ].
	sub setProbaToBelongTo: self strategies atRandom to: (1 - (0.01 * (self strategies size - 1)))
 ]
]

{ #category : #'initailize-release' }
EMAlgo >> intialize [
self class currentInstance: self.
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

{ #category : #control }
EMAlgo >> logLikelyhoodTermOf: aStrategy [

	self population subjects collect: [: subject |
		subject tours collect: [: t | ]].
]

{ #category : #control }
EMAlgo >> logLikelyhoodTermOf: aStrategy withParameters: aParameters [

	^ (self population subjects collect: [: subject |
		(subject tours collect: [: t | (subject getProbaToBelongTo: aStrategy) * 
			((subject probaOfOneObs: t
				ObsConditionallyTo: aStrategy 
					withParameters: aParameters) log)]) sum]) sum.
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

{ #category : #obsolete }
EMAlgo >> updatePqs [
	"Compute new values of pqs"	

| tiqs |
self strategies do: [:strat |
	tiqs := (self population subjects asOrderedCollection collect: [:sub | sub tiq at: strat class name ]). 
	strat pq: (tiqs sumNumbers)  / (tiqs size)].
]

{ #category : #control }
EMAlgo >> updateShares [
	"Compute new values of pqs (shares of each class)"

| indivProbasOfHavingAStrat denom |
	denom := 0.
	self strategies do: [:strat | denom := denom + (self population subjects asOrderedCollection collect: [:sub | sub getProbaToBelongTo: strat]) sum].

self strategies do: [:strat |
	indivProbasOfHavingAStrat := self population subjects asOrderedCollection collect: [:sub | sub getProbaToBelongTo: strat]. 
	strat pq: (indivProbasOfHavingAStrat sumNumbers)  / denom].
]
