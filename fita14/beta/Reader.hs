{-# LANGUAGE TypeFamilies, MultiParamTypeClasses, FlexibleInstances, RebindableSyntax #-}

import IxMonad
import Data.HList hiding (Monad(..))
import Prelude hiding (Monad(..))

instance IxMonad (->) where
    type Inv (->) s t = Split s t

    type Unit (->) = HNil
    type Plus (->) s t = Append s t

    return x = \HNil -> x
    f >>= k = \xs -> let (s, t) = split xs
                     in (k (f s)) t

-- bind :: (a -> (r -> b)) -> (s -> b) -> (r ++ s -> b)
 
ask :: (HCons a HNil) -> a
ask = \(HCons x HNil) -> x

foo = do x <- ask
         xs <- ask
         return (x : xs)

foo_eval = foo (HCons 'a' (HCons "bc" HNil))

foo2 = do x <- ask
          y <- ask
          xs <- ask
          return (x : (y : xs))

foo2' = do x <- ask 
           xs' <- do y <- ask
                     xs <- ask
                     return (y:xs)
           return (x : xs')

foo2_eval foo2 = foo2 (HCons 'a' (HCons 'b' (HCons "c" HNil)))

-- Type-level append, and dual operations for split

class Split s t where
    type Append s t
    split :: Append s t -> (s, t)

instance Split HNil t where
    type Append HNil t = t
    split t = (HNil, t)

instance Split xs ys => Split (HCons x xs) ys where
    type Append (HCons x xs) ys = HCons x (Append xs ys)
    split (HCons x xs) = let (xs', ys') = split xs
                         in (HCons x xs', ys')