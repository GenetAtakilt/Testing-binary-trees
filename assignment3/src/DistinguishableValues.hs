module DistinguishableValues where

data A = OneBool Bool
        | EitherBool Bool Bool
        | PairBool (Bool,Bool)
        | Maybe Bool
        deriving(Eq, Show)


f :: A -> Int
f (OneBool a1)        = if a1 == True
                        then 1
                        else 0
f (EitherBool a1 a2)
                        | a1 == True && a2 == False = 1
                        | a1 == True && a2 == True  = 0
                        | otherwise                 = undefined
{- f (Maybe a)
                        | Just a == True  = 1
                        | Just a == False = 0
                        | otherwise  = Nothing -}


f (PairBool(a1,a2))
                        | (a1,a2) == (True,True)       = 0
                        | (a1,a2) == (False,False)     = 0
                        | (a1,a2) == (True,False)      = 1
                        | (a1,a2) == (False,True)      = 1
                        | (a1,a2) == (undefined,True)  = undefined
                        | (a1,a2) == (False,undefined) = undefined
