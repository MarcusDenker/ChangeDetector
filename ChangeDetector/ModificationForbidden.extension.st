Extension { #name : #ModificationForbidden }

{ #category : #'*ChangeDetector' }
ModificationForbidden >> defaultAction [
	(ChangeDetector isDetectingFor: object)
		ifTrue: [ [ object beWritableObject.
			ChangeDetector notifyChangeOf: object with: self.
			self retryModification ]
				ensure: [ object beReadOnlyObject ] ]
		ifFalse: [ UnhandledError signalForException: self ]
]
