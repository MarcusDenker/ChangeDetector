"
objects: Table object -> to be notiefied objects 
readOnly: Set with all objects that are really read only

What is missing: treat already read only objects correctly (and changing monitored to read-Only)
"
Class {
	#name : #ChangeDetector,
	#superclass : #Object,
	#instVars : [
		'objects',
		'readOnly'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #ChangeDetector
}

{ #category : #api }
ChangeDetector class >> isDetectingFor: anObject [
	uniqueInstance ifNil: [ ^false ].
	^self uniqueInstance isDetectingFor: anObject.
]

{ #category : #api }
ChangeDetector class >> notify: notifiedObject OnChangeIn: observedObject [
	self uniqueInstance notify: notifiedObject OnChangeIn: observedObject
]

{ #category : #api }
ChangeDetector class >> notifyChangeOf: anObject [
	self uniqueInstance notifyChangeOf: anObject.
]

{ #category : #'instance creation' }
ChangeDetector class >> reset [
	uniqueInstance := nil
]

{ #category : #api }
ChangeDetector class >> stopNotify: notifiedObject OnChangeIn: observedObject [
	uniqueInstance ifNil: [ ^self ].
	self uniqueInstance stopNotify: notifiedObject OnChangeIn: observedObject
]

{ #category : #'instance creation' }
ChangeDetector class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #initialization }
ChangeDetector >> initialize [
	objects := WeakIdentityKeyDictionary new.
	readOnly := IdentitySet new.
]

{ #category : #api }
ChangeDetector >> isDetectingFor: anObject [
	objects at: anObject ifAbsent: [ ^false ].
	^true
]

{ #category : #api }
ChangeDetector >> notify: notifiedObject OnChangeIn: observedObject [
	| observers |
	observedObject isReadOnlyObject ifTrue: [readOnly add: observedObject. ].
	
	objects 
		at: observedObject 
		ifAbsentPut: [ WeakSet new ].
	observers := objects at: observedObject.
	observers add: notifiedObject.

	observedObject beReadOnlyObject.
]

{ #category : #api }
ChangeDetector >> notifyChangeOf: anObject [
	(objects at: anObject) do: [ :each | each objectChangeNotified ]
]

{ #category : #api }
ChangeDetector >> stopNotify: notifiedObject OnChangeIn: observedObject [
	| observers |
	(self isDetectingFor: observedObject) ifFalse: [ ^self ].
	observers := objects at: observedObject.
	observers remove: notifiedObject.
	observers ifEmpty: [objects removeKey: observedObject].
	
	"if in readOnly, we keep readOnly status"
	(readOnly identityIncludes: observedObject) ifFalse: [  
		observedObject beWritableObject.
	].
	"clean readOnly list"
	observers ifEmpty: [readOnly remove: observedObject ifAbsent: []].
	objects ifEmpty: [ self class reset ].

]
