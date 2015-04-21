"
 Assignment 4
 CPSC 5135G
 Joshua Boyd <boyd_joshua@columbusstate.edu>
 Simulates the actions of a traveling salesman.
"

"
 A stack implementation using an array as the backing store. The stack
 is limited in size to 32 items.
"
Object subclass: #MyStack
    instanceVariableNames:
	'anArray top '
    classVariableNames: ''
    poolDictionaries: '' !

!MyStack class methods !
" Constructor. Sample usage: "
" stack := (MyStack new). "
new
      | s |
    s := super new.
    s setsize: 32.
    ^s! !

!MyStack methods !
"
 If the stack is not empty, removes the node from the top of the stack and
 moves head to the next node. Sample usage:
 stack := (MyStack new).
 item := stack pop.
"
pop
    | item |
    (self empty) ifTrue: [
	StackUnderflow new signal.
	StackUnderflow signal.
    ].
    item := anArray at: top.
    top := top - 1.
    ^item!

"
 Add a node to the top of the stack. Sample usage:
 stack := (MyStack new).
 stack push: foo.
"
push: item
    (self full) ifTrue: [
	StackOverflow new signal.
	StackOverflow signal.
    ].
    top := top + 1.
    anArray at: top put: item!

"
 Retrieve the top node of the stack. Sample usage:
 stack := (MyStack new).
 stack push: foo.
 bar := stack top.
"
top
    | item |
    (self empty) ifTrue: [
	StackUnderflow new signal.
	Stackunderflow signal.
    ].
    item := anArray at: top.
    ^item!

" Prints entire stack (one entry per line) starting with the top most entry. "
printOn: aStream
    aStream nextPutAll: 'Stack['.
    1 to: top do: [:i | (anArray at: i) printOn: aStream. aStream space].
    aStream nextPutAll: ']'!

" Test to see if the stack is empty or not. "
empty
    ^top == 0!

" Test to see if the stack is full or not. "
full
    ^anArray size == top!

" Set size of stack, used by the constructor. "
setsize: n
    anArray := Array new: n.
    top := 0! !

" Storage of appointment information "
Object subclass: #Card
    instanceVariableNames: 'timeReceived x y estimatedTime'
    classVariableNames: ''
    poolDictionaries: ''

!Card class methods !

new
    ^ super new! !

!Card methods !

init: item
    timeReceived := item at: 1 asInteger.
    x := item at: 2 asInteger.
    y := item at: 3 asInteger.
    estimatedTime := item at: 4 asInteger!

getTimeReceived
    ^timeReceived asInteger!

getX
    ^x asInteger!

getY
    ^y asInteger!

getEstimatedTime
    ^estimatedTime asInteger!

distance: position
    ^ ((position getX asInteger - x asInteger raisedTo: 2) + (position getY asInteger - y asInteger raisedTo: 2)) sqrt ceiling! !

" Storage of current position "
Object subclass: #Position
    instanceVariableNames: 'x y'
    classVariableNames: ''
    poolDictionaries: ''

!Position class methods !

new
    ^ super new! !

!Position methods !

init
    x := 0.
    y := 0!

setX: item
    x := item asInteger!

getX
    ^x asInteger!

setY: item
    y := item asInteger!

getY
    ^y asInteger! !

" Storage of runtime statistics "
Object subclass: #Statistics
    instanceVariableNames: 'totalTime totalCalls timeWaiting timeOnRoad timeInMeetings maxWaitTime avgWaitTime totalWaitTime'
    classVariableNames: ''
    poolDictionaries: ''

!Statistics class methods !

new
    ^ super new! !

!Statistics methods !

init
    totalTime := 0.
    totalCalls := 0.
    timeWaiting := 0.
    timeOnRoad := 0.
    timeInMeetings := 0.
    maxWaitTime := 0.
    avgWaitTime := 0.
    totalWaitTime := 0!

setTotalTime: item
    totalTime := item!

getTotalTime
    ^totalTime asInteger!

setTotalCalls: item
    totalCalls := item!

getTotalCalls
    ^totalCalls asInteger!

setTimeWaiting: item
    timeWaiting := item!

getTimeWaiting
    ^timeWaiting asInteger!

setTimeOnRoad: item
    timeOnRoad := item!

getTimeOnRoad
    ^timeOnRoad asInteger!

setTimeInMeetings: item
    timeInMeetings := item!

getTimeInMeetings
    ^timeInMeetings asInteger!

setMaxWaitTime: item
    maxWaitTime := item!

getMaxWaitTime
    ^maxWaitTime asInteger!

setAvgWaitTime: item
    avgWaitTime := item!

getAvgWaitTime
    ^avgWaitTime asInteger!

setTotalWaitTime: item
    totalWaitTime := item!

getTotalWaitTime
    ^totalWaitTime asInteger! !

" Class for reading user input and writing out statistics "
Object subclass: #IO
    instanceVariableNames: 'input output'
    classVariableNames: ''
    poolDictionaries: ''

!IO class methods !

new
	^ super new! !

!IO methods !
init
	[input := FileSelectionBrowser open asFilename readStream.]
	       on: Error
	       do: [ :exception |
		    Dialog warn: 'Unable to open file'.
		    exception retry.
		].
	[output := FileSelectionBrowser open asFilename writeStream.]
		on: Error
		do: [ :exception |
		    Dialog warn: 'Unable to open file'.
		    exception retry.
		]. !

read
	| data line collection card|
	collection := OrderedCollection new.
	[ input atEnd ] whileFalse: [
	    line := input nextLine.
	    data := line tokensBasedOn: Character space.
	    card := (Card new).
	    card init: data.
	    collection add: card.
	].
	input close.
	^collection!

write: stats
	output nextPutAll: 'It took '.
	output nextPutAll: stats getTotalTime asString.
	output nextPutAll: ' minutes for the salesman to process '.
	output nextPutAll: stats getTotalCalls asString.
	output nextPutAll: ' calls.'; cr.

	output nextPutAll: 'The salesman spent '.
	output nextPutAll: stats getTimeWaiting asString.
	output nextPutAll: ' minutes in bookstores, '.
	output nextPutAll: stats getTimeOnRoad asString.
	output nextPutAll: ' minutes on the road, and '.
	output nextPutAll: stats getTimeInMeetings asString.
	output nextPutAll: ' minutes in meetings with clients.'; cr.

	output nextPutAll: 'Clients spent an average of '.
	output nextPutAll: stats getAvgWaitTime asString.
	output nextPutAll: ' minutes waiting for the salesperson to see them.'; cr.

	output nextPutAll: 'The maximum amount of time any client spent waiting was '.
	output nextPutAll: stats getMaxWaitTime asString.
	output nextPutAll: '.'; cr.

	output close! !

" Main class "
Object subclass: #Salesman
    instanceVariableNames: 'stack io statistics position'
    classVariableNames: ''
    poolDictionaries: ''

!Salesman class methods !
new
	^ super new! !

!Salesman methods !
init
	stack := (MyStack new).
	statistics := (Statistics new init).
	position := (Position new init).
	io := (IO new init)!

run
	| userInput inputToAdd timeInMeetings|
	userInput := io read.

	timeInMeetings := 0.
	userInput do: [:a | timeInMeetings := timeInMeetings + a getEstimatedTime asInteger].
	statistics setTimeInMeetings: timeInMeetings.

	[ (userInput isEmpty not) | (stack empty not)] whileTrue: [
	    inputToAdd := userInput select: [:a | a getTimeReceived asInteger <= statistics getTotalTime].
	    inputToAdd do: [:a | stack push: a].

	    userInput := userInput select: [:a | a getTimeReceived asInteger > statistics getTotalTime].

	    (stack empty) ifFalse: [
		| firstCard cardToProcess distance waitTime|
		firstCard := stack top.
		cardToProcess := firstCard.
		stack pop.

		(stack empty) ifFalse: [
		    | secondCard d1 d2|
		    secondCard := stack top.
		    stack pop.

		    d1 := (firstCard distance: position).
		    d2 := (secondCard distance: position).

		    d1 < d2 ifTrue: [ stack push: secondCard. ].

		    d1 == d2 ifTrue: [
			firstCard getTimeReceived asInteger > secondCard getTimeReceived asInteger ifTrue: [
			    cardToProcess := secondCard.
			    stack push: firstCard.
			]
		    ].

		    d1 > d2 ifTrue: [
			cardToProcess := secondCard.
			stack push: firstCard.
		    ].
		].

		distance :=  cardToProcess distance: position.
		statistics setTimeOnRoad: (statistics getTimeOnRoad + distance).
		statistics setTotalTime: (statistics getTotalTime + distance).

		waitTime := statistics getTotalTime - cardToProcess getTimeReceived.

		(waitTime > statistics getMaxWaitTime) ifTrue: [ statistics setMaxWaitTime: waitTime. ].

		statistics setTotalTime: (statistics getTotalTime + cardToProcess getEstimatedTime).

		position setX: cardToProcess getX.
		position setY: cardToProcess getY.

		statistics setAvgWaitTime: ((statistics getTotalWaitTime) + waitTime)/ (statistics getTotalCalls + 1).
		statistics setTotalWaitTime: statistics getTotalWaitTime + waitTime.
		statistics setTotalCalls: statistics getTotalCalls + 1.
	    ]
	    ifTrue: [
		statistics setTimeWaiting: (statistics getTimeWaiting + 1).
		statistics setTotalTime: (statistics getTotalTime + 1).
	    ].
	].

	io write: statistics.

! !
