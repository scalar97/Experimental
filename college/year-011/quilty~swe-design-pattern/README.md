# Quilty

A Java program that attempts to stop procrastination, and the guilt that comes with it.

Hopefully I will finish writing it..

## System design
[How it is being imagined.](https://docs.google.com/document/d/1io-1B8Ig6a02cLTsQe2JlxrtSWwMA8imDP1uHu4xLcQ/edit?usp=sharing)
_(incl. video demo link)_

## Features

`NS`: Not Started,`S`: Started, `W`: Works(partially), `WAA`: Works As Intended, `B`: Broken.

| Name                                                                          | NS     | S   | W   | WAI | B |   |
|:------------------------------------------------------------------------------|:------:|:---:|-----|:---:|:-:|---|
| Add and remove a task                                                         |        |     | [X] |     |   |   |
| Delete items when they are N days old                                         | [X]    |     |     |     |   |   |
| Group tasks in treads                                                         | [X]    |     |     |     |   |   |
| Initialized using procrastinate.config                                        |        |     | [X] |     |   |   |
| Use peer penalty - acquire a savior                                           | [X]    |     |     |     |   |   |
| Use health penalty - the more job DONE FASTER, the better the health          | [X]    |     |     |     |   |   |
| Use both rank and peer penalty if the procrastination is so bad (recommended) | [X]    |     |     |     |   |   |
| hard worker's leader board                                                    | [X]    |     |     |     |   |   |
| wall of (panic\|shame)                                                        |        | [X] |     |     |   |   |
| Collaborative procrastination                                                 | [X]    |     |     |     |   |   |
| Allow users to follow your procrastination stack                              | [X]    |     |     |     |   |   |
| Link a thread to a git repo (get it to dynamically update a todo.md)          | [X]    |     |     |     |   |   |

## Penalties

The program will automatically stop working if more than 3 tasks go undone for N days (**'quilty' user**).
In this case,

#### Case: using peer penalty
Here is when another user gets the unlocks key to account.

```
	- send the *unlock id* via email to a user (a savior) specified in procastinate.config,
	- this user has to have their username/password registered,
	- If you are locked out and your savior is also locked out,
	  you are screwed until  he/she/it unlocks themselves first. (wall of panic)
	- NOTE: DUMMY/SUSPICIOUS USERS WILL BE EXPOSED, I AM NOT EVEN JOKING.
	- Machine learning will be used to detect dummy users.
	- Staying on the wall of panic for N days will result in panic attack 
	  a redemption in task accomplishment will need to be performed to escape this attack.
	- Your savior will be advised to drop you if you don't improve.
	  and if this is happens,(you don't want this to happen), you will be added to the wall of shame 
	  for all your followers to boo. (wall of shame)
	  NOTE: 'boo count' decreases health and/or leaves the quilty user in serious health rank problems.
```
#### Tips for choosing a savior
```
	- A willing user you will feel quilty to spam.
	- Someone who won't lock you out for fun.
	- No secondary user can be added.
```

#### Case: using health penalty
```
	- The age of a task never goes beyond N duration before it's completed.
	  (category dependent and not tweakable).
```
_is typing..._

#### Case: *noT cAse sEnsitive*
```
	- When quilty, the program will lock the database and prevent any read/write until this is resolved.
	  Any attempt to hack the database will result in being flagged as suspicious user.
	- users plead quilty of being 'dummy', will be added to the suspicious users for N days, 
	  if they keep on being suspicious, their accounts will be deleted.
	- usernames of deleted account will stay unavailable for a year.
```
