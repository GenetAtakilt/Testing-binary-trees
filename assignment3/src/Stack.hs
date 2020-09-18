module Stack (run,run',Instructions(..)) where

-----------------------------------------------------------------------------------------------------------------------------
-- W3.2 A simple stack language

data Instructions = Push Int Instructions
               | Add Instructions
               | Mul Instructions
               | Dup Instructions
               | Swap Instructions
               | Neg Instructions
               | Pop Instructions
               | Over Instructions
               | IfZero Instructions Instructions
               | Loop (Instructions -> Instructions)
               | Halt

fact5,fact4 :: Instructions
fact5 = Push 5 $ Push 1 $ Swap $ Loop $ \ loop -> Dup $ IfZero (Pop $ Halt) $ Swap $ Over $ Mul $ Swap $ Push 1 $ Neg $ Add $ loop
fact4= Push 5 $ Push 1 $ Swap $Dup $ Neg $Pop $Over Halt

-- helper function that takes Instructions and List and do the computation for 
-- every contractor of Instructions

run' :: Instructions -> [Int] -> Maybe [Int]
run' (Push n i)   xs       = run' i (n:xs)
run' (Add _)      []       = Nothing
run' (Add _)      (x:[])   = Nothing
run' (Add i)      (x:y:ys) = run' i ((x+y):ys)
run' (Mul i)      []       = Nothing
run' (Mul i)      (x:[])   = Nothing
run' (Mul i)      (x:y:ys) = run' i ((x*y):ys)
run' (Dup i)      []       = Nothing
run' (Dup i)      (x:xs)   = run' i (x:x:xs)
run' (Swap i)     []       = Nothing
run' (Swap i)     (x:[])   = Nothing
run' (Swap i)     (x:y:ys) = run' i (y:x:ys)
run' (Neg i)      []       = Nothing
run' (Neg i)      (x:xs)   = run' i ((-x):xs)
run' (Pop i)      []       = Nothing
run' (Pop i)      (x:xs)   = run' i xs
run' (Over i)     []       = Nothing
run' (Over i)     (x:[])   = Nothing
run' (Over i)     (x:y:ys) = run' i (y:x:y:ys)
run' (IfZero i j) []       = Nothing
run' (IfZero i j) (x:xs)   = if x==0 then run' i (xs) else run' j (xs) 
run' (Loop f)      xs      = run' (f (Loop f)) xs
run' (Halt)        xs      = Just xs

run :: Instructions -> Maybe [Int]
run i = run' i []