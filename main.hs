import System.IO 

-- Node - nodes are represented as subsets of the set of states of automata
-- so notes are simply lists of Ints (in ascending order)
-- while Node directly represents a node in a power automata
-- we also create new data - Vertex, to store additional data about a vertex
-- it'll be needed to find the shortest path by going backwards

type Node = [Int]

-- new data type so that vertex stores some additional important info
-- so "node" is an actual node in power graph (subset of the set of
-- nodes of the original graph)
-- and "vertex" is new data representing a given node
-- together with some additional info
data Vertex = Vertex { vertexLabel :: Node -- vertex "key"
                     , vertexPredecessor :: Node -- "key" of it's predecessor
                     , edgeWithPredecessor :: Char -- to be filled during bfs1
                     , vertex_isRoot :: Bool -- same as above
                     } deriving (Show)

--bfs1::discovered -> queue -> transition -> final_node
bfs1 :: [Vertex] -> [Vertex] -> [[Int]] -> (Vertex, [Vertex])
bfs1 discovered [] _ = (Vertex [] [] 'a' False, discovered)
bfs1 discovered (dequeued:rest) transition =
  if len dequeued == 1
    then (dequeued, discovered)
    else bfs1 (discovered ++ not_discovered) (rest ++ not_discovered) transition
  where not_discovered = [x | x <- get_neighbours1 (dequeued, transition), notElement x discovered]

-- check if a vertex is not an elemnt of a list of vertices
notElement :: Vertex -> [Vertex] -> Bool
notElement v vertices = vertexLabel v `notElem` [vertexLabel vertex | vertex <- vertices]

-- make sure every element in a list is unique
unique [] = []
unique (x:xs) = if x `elem` xs
                  then unique xs
                  else [x] ++ (unique xs)

get_neighbours1 :: (Vertex, [[Int]]) -> [Vertex]
get_neighbours1 (v, transition) =
  [Vertex (quicksort $ unique [(transition !! n !! state) | state <- node]) node (show n !! 0) False | n <- [0..tr_len-1]]
  where tr_len = length(transition)
        node = vertexLabel v

-- get length of node of a vertex (as list of Ints)
len :: Vertex -> Int
len vertex = length $ vertexLabel vertex

-- simply a quicksort :) - every node must be a sorted list of Int
-- for comparison reasons
quicksort :: [Int] -> [Int]
quicksort [] = []
quicksort (x:xs) = quicksort [t | t <- xs, t < x] ++ [x] ++ quicksort [t | t <- xs, t > x]

-- make a "transition function" for power automata
-- by converting string from file to list of Nodes (which are lists of Ints)
make_transition :: [String] -> [Node]
make_transition content = [convert_to_Int line | line <- content]

-- convert String (Ints separated by whitespaces) to list of Ints
convert_to_Int :: String -> [Int]
convert_to_Int str = [read [x] :: Int | x <- str, x /= ' ']

-- get synchronizing word after bfs1 is performed
get_synch_word :: (Vertex, [Vertex]) -> String
get_synch_word (v, vertices) =
  if vertexLabel v == []
    then "Automaton is not synchronizing"
  else if vertex_isRoot v
    then []
    else [edgeWithPredecessor v] ++ get_synch_word ((find_vertex  (vertexPredecessor v) vertices), vertices)

-- find vertex with a given node in a list of vertices
find_vertex :: Node -> [Vertex] -> Vertex
find_vertex node vertex = extract_from_list [v | v <- vertex, vertexLabel v == node]

-- get firs vertex from a list of vertices
extract_from_list :: [Vertex] -> Vertex
extract_from_list (x:xs) = x

main = do
    automata <- openFile "automata.txt" ReadMode
    content <- hGetContents automata
    -- does not work with the line below
    putStrLn content
    hClose automata
    let transition = make_transition (lines content)
        n = ((length $ lines content !! 0) + 1) `div` 2 - 1
        root = (Vertex [0,1,2] [] ' ' True)
    putStrLn $ get_synch_word $ bfs1 [root] [root] transition
