'Indexed comonads' 

For more details see "Coeffects: Unified static analysis of context-dependence"
by Petricek, Orchard, Mycroft:
http://www.cl.cam.ac.uk/~dao29/publ/coeffects-icalp13.pdf

%if False

> {-# LANGUAGE TypeFamilies #-}
> {-# LANGUAGE ConstraintKinds #-}

> module IxComonad where 

> import GHC.Prim

%endif

> class IxComonad (c :: * -> * -> *) where
>     type Inv c s t :: Constraint -- invariants (i.e. restrict to a subcategory of Hask)
>     type Inv c s t = ()

>     type Unit c 
>     type Plus c s t
>
>     iextract :: c (Unit c) a -> a
>     iextend :: Inv c s t => (c t a -> b) -> c (Plus c s t) a -> c t b
