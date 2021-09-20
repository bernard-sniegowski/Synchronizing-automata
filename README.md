# Synchronizing-automata
An implementation of algorithm that finds the shortest synchornizing word for a given automata

For more information read

https://en.wikipedia.org/wiki/Synchronizing_word

and

http://www.math.uni.wroc.pl/~kisiel/auto/volkov-surv.pdf

# _main.hs_
File _main.hs_ contains the algorithm written in Haskell using purely functional programming

The description of each function can be found in the comments in _main.hs_ file

# Data format
* We assume that states are numbered from 0 to 9
* An alphabet can have any amount of letters
* Letters are represented by natural numbers
* ## Input data
  * Input data should be in a file "automata.txt"
  * Input data format
    * Input file consits of several lines
    * Each line consists of positive integers separated by whitespaces
    * Number of positive integers in each line is equal to the number of states
    * n-th row tells us the transformation of consequitive states upon the n-th letter of alphabet, i.e. if in n-th line there are integers: 1 3 3 2 then upon n-th letter
      * state 0 goes to state 1
      * state 1 to state 3
      * state 2 to state 3
      * and state 3 to state 2
      * It also means that there are 4 states in our automata
    * Size of the alphabet is the number of lines
* IF AUTOMATA is synchornizing
 * Result (synchornizing word) is given as a sequence of digits (0 to 9)
* ELSE
 * Algorithm prints message "Autmaton not synchronizing"
