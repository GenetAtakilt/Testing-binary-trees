{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE InstanceSigs  #-}
{-# OPTIONS_HADDOCK show-extensions #-}
module Test where
import Test.QuickCheck
import Control.Monad



data Tree a = Leaf a | Node (Tree a) (Tree a)
  deriving (Show, Eq, Functor, Ord, Read)

tree1 :: Tree Int
tree1 = Leaf 0

tree2 :: Tree Int
tree2 = Node (Leaf 2) (Leaf 4)

genTree :: Arbitrary a => Int -> Gen (Tree a)
genTree 1 = liftM Leaf arbitrary  -- generates Leaf 
genTree n
    | n>1
        = liftM2 Node (genTree ln) (genTree lr )  -- generates trees whose number of leaves equals the given argument 
               where
                 ln = n-1     --give n-1 leaf to the left tree
                 lr = n - ln  --give the rest to the right tree
                

instance Arbitrary a => Arbitrary (Tree a) where
  arbitrary = sized go  
       where
        go n
          | n <= 1 = fmap Leaf arbitrary
          | otherwise = oneof [fmap Leaf arbitrary, liftM2 Node sub sub]  --using oneof function generate arbitrary tree 
          where
           sub = go (n `div` 2)  --divide the given argument eqully to left and right node

  shrink (Leaf x)   = fmap Leaf (shrink x)
  shrink (Node l r) =  liftM2 Node (shrink l) (shrink r) 


propFunctor :: ((Int -> Int) -> Tree Int -> Tree Int) -> Tree Int -> Property
propFunctor f trr = (f id trr) === trr -- checks the first functor law 

fmap' :: (a -> b) -> Tree a -> Tree b
fmap'  f (Leaf x) =  Leaf (f x )  
fmap'  f (Node l r) = Node ( f <$> r) ( f <$>l) -- reverse the left and right tree 
    


