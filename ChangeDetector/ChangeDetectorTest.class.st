"
Test for ChangeDetector.

This needs a fix to be green (purely for running the tests): ModificationForbidden should not be a Error subclass:

Exception subclass: #ModificationForbidden
	instanceVariableNames: 'object fieldIndex newValue retrySelector'
	classVariableNames: ''
	package: 'Kernel-Exceptions'
"
Class {
	#name : #ChangeDetectorTest,
	#superclass : #TestCase,
	#instVars : [
		'flag'
	],
	#category : #ChangeDetector
}

{ #category : #flag }
ChangeDetectorTest >> objectChangeNotified [
	flag := #yes
]

{ #category : #running }
ChangeDetectorTest >> tearDown [
	flag := nil.
]

{ #category : #tests }
ChangeDetectorTest >> testObserveObjectNoModification [
	"check that the internal datastructure of the ChangeDetector are correct"
	|observed observer objects |
	observed := 'test'.
	observer := self.
	observed notifyOnChange: observer.
	
	objects := ChangeDetector uniqueInstance instVarNamed: #objects.
	self assert: (objects includesKey: observed).
	self assert: (observed isReadOnlyObject).
	
	observed stopNotifyOnChange: observer.
	self deny: (objects includesKey: observed).
	self deny: (observed isReadOnlyObject).
]

{ #category : #tests }
ChangeDetectorTest >> testObserveObjectWithModification [
	| observed observer |
	observed := 'test2'.
	observer := self.
	observed notifyOnChange: observer.
	"the observed object is now read only"
	self assert: (observed isReadOnlyObject).
	"but we can change it!"
	observed at: 1 put: $T.

	self assert: observed equals: 'Test2'.
	"and the method #objectChangeNotified was called, setting flag"
	self assert: flag equals: #yes.
	
	observed stopNotifyOnChange: observer.
	self deny: (observed isReadOnlyObject).

	
]
