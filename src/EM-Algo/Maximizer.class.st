Class {
	#name : #Maximizer,
	#superclass : #Object,
	#instVars : [
		'AlgoIteration',
		'candidateParameters',
		'nbSamples',
		'nbMove',
		'nbIterations',
		'show',
		'grapher'
	],
	#category : #'EM-Algo'
}

{ #category : #control }
Maximizer class >> computeVraisemblance: aParameters [
	"Just to access the method of the same name of the sole instance of the class"

	^ self allInstances first computeVraisemblance: aParameters
]

{ #category : #accessing }
Maximizer >> algoIteration [
	^ AlgoIteration
]

{ #category : #accessing }
Maximizer >> algoIteration: anObject [
	AlgoIteration := anObject
]

{ #category : #accessing }
Maximizer >> candidateParameters [
	^ candidateParameters
]

{ #category : #accessing }
Maximizer >> candidateParameters: anObject [
	candidateParameters := anObject
]

{ #category : #control }
Maximizer >> computeVraisemblance: aParameters [
|iterationParam|
iterationParam := self algoIteration psi.
self algoIteration psi: aParameters.
self algoIteration computeDs.
self algoIteration computeToursFqs.
self algoIteration computeTiq.
self algoIteration computeG.
self algoIteration psi: iterationParam.
^ self algoIteration g.

]

{ #category : #'initailize-release' }
Maximizer >> gradientView [
| view |
view := RTView new.

]

{ #category : #accessing }
Maximizer >> grapher [
	^ grapher
]

{ #category : #accessing }
Maximizer >> grapher: anObject [
	grapher := anObject
]

{ #category : #control }
Maximizer >> hillClimCandidateParams [
| fBlock educatedGuess hillClimber result |
fBlock := [:v |
    |a rM rP|
    a := v at: 1.
    rM := v at: 2.
	 rP := v at: 3.
    Maximizer computeVraisemblance: Parameters new; alpha: a; rhoMoins: rM; rhoPlus: rP].

	self candidateParameters do: [ :cParam |
		educatedGuess := cParam asPMVector.
		self moveParameterCandidate: cParam].
	 self grapher view signalUpdate.
]

{ #category : #'initailize-release' }
Maximizer >> init [
	"Generate candidate parameters"
	| para alphas rhosPlus rhosMoins da drP drM |
	alphas := OrderedCollection new.
	rhosPlus := OrderedCollection new.
	rhosMoins := OrderedCollection new.
	da := 1 / self nbSamples * self algoIteration psiMax alpha.
	drP := 1 / self nbSamples * self algoIteration psiMax rhoPlus.
	drM := 1 / self nbSamples * self algoIteration psiMax rhoMoins.
	0 to: self nbSamples do: [ :i | 
		alphas add: i * da.
		rhosPlus add: i * drP.
		rhosMoins
			add: i * drM].
	alphas
		do: [ :a | 
			rhosPlus
				do: [ :rP | 
					rhosMoins
						do: [ :rM | 
							para := Parameters new.
							para alpha: a + ((self algoIteration rNG next) * da).
							para rhoMoins: rM + ((self algoIteration rNG next) * drM).
							para rhoPlus: rP + ((self algoIteration rNG next) * drP).
							para vraisemb: (self computeVraisemblance: para).
							self candidateParameters add: para ] ] ].
				self show ifTrue: [ ^ self initVisualization3D ].
]

{ #category : #'initailize-release' }
Maximizer >> initVisualization [
	"Create a window for following parameter move"
| b ds v |
b := RTGrapher new.
b extent: 200 @ 200.
ds := RTData new.
ds dotShape cross color: (Color red alpha: 0.3).
ds points: self candidateParameters.
ds x: #alpha.
ds y: #rhoMoins.
b add: ds.
b openIn: b view.
self grapher: b.
b view openInWindowSized:  (300 @ 300) titled: 'Parameters Maximisation'.
"b renderIn: v."
 ^ b view
]

{ #category : #'initailize-release' }
Maximizer >> initVisualization3D [
	"Create a window for following parameter move"
| g b ds b2 ds2 nCols maxV minV l e1 e2 chart c xs ys p g1 c0 zs g2 c2 z p2 |
c0 := RSCanvas new.

" alpha - rho scatterplot "
	xs := self candidateParameters collect: [:par | par alpha].
	ys := self candidateParameters collect: [:par | par rhoMoins ].
	zs := self candidateParameters collect: [:par | par rhoPlus ].
	g1 := RSGroup new.
	c := RSChart new.
	c container: g1.
	c xlabel: 'alpha'.
	c ylabel: 'RhoMoins'.
	p := RSScatterPlot new  x: xs y: ys.
	p color: Color blue translucent.
	p processBlock: [ :shapes | 
		shapes models: self candidateParameters.
		RSNormalizer color
			shapes: shapes;
			normalize: #vraisemb.
		shapes translucent ].
	c addPlot: p.

	c addDecoration: (RSHorizontalTick new doNotUseNiceLabel asFloat: 3).
	c addDecoration: RSVerticalTick new.
c build.

	g2 := RSGroup new.
	c2 := RSChart new.
	c2 container: g2.
	p2 := RSScatterPlot new  x: zs y: ys.
	p2 color: Color blue translucent.
	p2 processBlock: [ :shapes | 
		shapes models: self candidateParameters.
		RSNormalizer color
			shapes: shapes;
			normalize: #vraisemb.
		shapes translucent ].
	c2 ylabel: 'RhoMoins'.
	c2 xlabel: 'RhoPlus'.
	c2 addPlot: p2.
	c2 build.

	c0 add: g1 asShape; add: g2 asShape.
	RSHorizontalLineLayout on: c0 shapes.

	c0 @ RSCanvasController.
	^ c0 


]

{ #category : #'initailize-release' }
Maximizer >> initVisualization3DR2 [
	"Create a window for following parameter move"
| c b ds b2 ds2 nCols maxV minV l e1 e2 |
c :=  RTComposer new.
	maxV := (self candidateParameters collect: [: p | p vraisemb]) max.
	minV := (self candidateParameters collect: [: p | p vraisemb]) min.
	nCols := RTMultiLinearColor new.
	nCols colors: (RTColorPalette sequential colors: 7 scheme:'Reds').
	nCols command: [: aPar | (8 * (aPar vraisemb - minV) / (maxV)) asInteger].

" alpha - rho scatterplot "
b := RTGrapher new.
b extent: 100 @ 100.
b view: c view.
ds := RTData new.
ds interaction popup.
ds dotShape color: nCols.
ds points: self candidateParameters.
ds elements do: [ :point | point model visu: point ].
ds x: #alpha.
ds y: #rhoMoins.
b add: ds.
b build.
self candidateParameters do: [: par | 
	par lastPoint ifNotNil:[
	e1 := par visu.
	e2 := par lastPoint visu.
	l := RTArrowedLine edgeFrom: e2 to: e1.
	l shape scale: 0.5.
	l color: Color black.
	l shape head color: Color black.
	"c view addAll: (Array with: e1 with: e2 with: l)"
	c view add: l]].
	c group: #alphaRhoM.

" rhoMoins - rhoPlus scatterplot "
b2 := RTGrapher new.
b2 view: c view.
b2 extent: 100 @ 100.
ds2 := RTData new.
b2 interaction popup.
ds2 dotShape color: nCols.
ds2 points: self candidateParameters.
ds2 elements do: [ :point | point model visu: point ].
ds2 x: #rhoPlus.
ds2 y: #rhoMoins.
self candidateParameters do: [: par | 
	par lastPoint ifNotNil:[
	e1 := par visu.
	e2 := par lastPoint visu.
	l := RTArrowedLine edgeFrom: e2 to: e1.
	l shape scale: 0.5.
	l color: Color black.
	l shape head color: Color black.
	"c view addAll: (Array with: e1 with: e2 with: l)"
	"c view add: l"]].
b2 add: ds2.
b2 build.
c group: #rhoPlusRhoMoins.

"layouting"
c move: #rhoPlusRhoMoins onTheLeftOf: #alphaRhoM .
self grapher: c.
c view openInWindowSized:  (300 @ 300) titled: 'Parameters Maximisation'.
"RTMetricNormalizer new view: c view; objects: self candidateParameters; distinctColor."
c propagateHighlightToAll.
 ^ c view
]

{ #category : #'initailize-release' }
Maximizer >> initVisualization3Roassal2 [
	"Create a window for following parameter move"
| g b ds b2 ds2 nCols maxV minV l e1 e2 chart c |
g :=  RSGroup new.
	"maxV := (self candidateParameters collect: [: p | p vraisemb]) max.
	minV := (self candidateParameters collect: [: p | p vraisemb]) min.
	nCols := RSMultiLinearColor new.
	nCols colors: RSColorPalette sequential ylorrd5.
	nCols command: [: aPar | (8 * (aPar vraisemb - minV) / (maxV)) asInteger]."

" alpha - rho scatterplot "
	chart := RSChart new.
b := RSScatterPlot new.
b container: g.
ds := RSData new.
ds interaction popup.
ds dotShape color: nCols.
ds points: self candidateParameters.
ds elements do: [ :point | point model visu: point ].
ds x: #alpha.
ds y: #rhoMoins.
b add: ds.
b build.
self candidateParameters do: [: par | 
	par lastPoint ifNotNil:[
	e1 := par visu.
	e2 := par lastPoint visu.
	l := RTArrowedLine edgeFrom: e2 to: e1.
	l shape scale: 0.5.
	l color: Color black.
	l shape head color: Color black.
	"c view addAll: (Array with: e1 with: e2 with: l)"
	c view add: l]].
	c group: #alphaRhoM.

" rhoMoins - rhoPlus scatterplot "
b2 := RTGrapher new.
b2 view: c view.
b2 extent: 100 @ 100.
ds2 := RTData new.
b2 interaction popup.
ds2 dotShape color: nCols.
ds2 points: self candidateParameters.
ds2 elements do: [ :point | point model visu: point ].
ds2 x: #rhoPlus.
ds2 y: #rhoMoins.
self candidateParameters do: [: par | 
	par lastPoint ifNotNil:[
	e1 := par visu.
	e2 := par lastPoint visu.
	l := RTArrowedLine edgeFrom: e2 to: e1.
	l shape scale: 0.5.
	l color: Color black.
	l shape head color: Color black.
	"c view addAll: (Array with: e1 with: e2 with: l)"
	"c view add: l"]].
b2 add: ds2.
b2 build.
c group: #rhoPlusRhoMoins.

"layouting"
c move: #rhoPlusRhoMoins onTheLeftOf: #alphaRhoM .
self grapher: c.
c view openInWindowSized:  (300 @ 300) titled: 'Parameters Maximisation'.
"RTMetricNormalizer new view: c view; objects: self candidateParameters; distinctColor."
c propagateHighlightToAll.
 ^ c view
]

{ #category : #initialization }
Maximizer >> initialize [ 
self nbIterations: 8.
self nbMove: 2.
self nbSamples: 2.
self show: true.
self candidateParameters: OrderedCollection new.
]

{ #category : #control }
Maximizer >> maximizeParams [
|  |
1 to: self nbMove do: [ :mov |
	self candidateParameters do: [ :cParam |
		self moveParameterCandidate: cParam].
	 ]
]

{ #category : #control }
Maximizer >> moveParameterCandidate: aParameters [
	| vParam maxis da drM drP |
	maxis := self algoIteration psiMax.
	vParam := aParameters vraisemb.
	da := ((self
		computeVraisemblance: (aParameters copy alpha: aParameters alpha + (maxis alpha / 100)))
		- vParam) sign * (maxis alpha / 20).
	drM := ((self
		computeVraisemblance:
			(aParameters copy
				rhoMoins: aParameters rhoMoins + (maxis rhoMoins / 100))) - vParam)
		sign * (maxis rhoMoins / 20).
	drP := ((self
		computeVraisemblance:
			(aParameters copy rhoPlus: aParameters rhoPlus + (maxis rhoPlus / 100)))
		- vParam) sign * (maxis rhoPlus / 20).
	aParameters moveA: da rM: drM rP: drP.
	aParameters vraisemb: (self computeVraisemblance: aParameters).
	^ aParameters
]

{ #category : #accessing }
Maximizer >> nbIterations [
	^ nbIterations
]

{ #category : #accessing }
Maximizer >> nbIterations: anObject [
	nbIterations := anObject
]

{ #category : #accessing }
Maximizer >> nbMove [
	^ nbMove
]

{ #category : #accessing }
Maximizer >> nbMove: anObject [
	nbMove := anObject
]

{ #category : #accessing }
Maximizer >> nbSamples [
	^ nbSamples
]

{ #category : #accessing }
Maximizer >> nbSamples: anObject [
	nbSamples := anObject
]

{ #category : #accessing }
Maximizer >> show [
	^ show
]

{ #category : #accessing }
Maximizer >> show: anObject [
	show := anObject
]
