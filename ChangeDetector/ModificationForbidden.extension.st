Extension { #name : #ModificationForbidden }

{ #category : #'*ChangeDetector' }
ModificationForbidden >> defaultAction [
	(ChangeDetector isDetectingFor: object)
		ifTrue: [
			[ChangeDetector notifyChangeOf: object.
			object beWritableObject.
			self retryModification] ensure: [ object beReadOnlyObject ]]
		ifFalse: [UnhandledError signalForException: self]. 	
]
