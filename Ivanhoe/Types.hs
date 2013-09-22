{-# LANGUAGE TemplateHaskell #-}


module Ivanhoe.Types where


import Database.Persist.TH
import Prelude


-- OK. There are *way* too many roles listed here. I'll chuck some out once the
-- dust starts to settle.
data Role = Owner
          | Reader
          | Author
          | Editor
          | Commentor
          deriving (Enum, Show, Read, Eq)
derivePersistField "Role"

