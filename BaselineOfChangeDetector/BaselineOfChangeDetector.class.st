Class {
	#name : #BaselineOfChangeDetector,
	#superclass : #BaselineOf,
	#category : #BaselineOfChangeDetector
}

{ #category : #baselines }
BaselineOfChangeDetector >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec blessing: #baseline.
			spec package: 'ChangeDetector' ]
]
