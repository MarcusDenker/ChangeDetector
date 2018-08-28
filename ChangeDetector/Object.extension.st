Extension { #name : #Object }

{ #category : #'*ChangeDetector' }
Object >> notifyOnChange: anObject [
	ChangeDetector notify: anObject OnChangeIn: self
]

{ #category : #'*ChangeDetector' }
Object >> stopNotifyOnChange: anObject [
	ChangeDetector stopNotify: anObject OnChangeIn: self
]
