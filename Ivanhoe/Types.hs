
module Ivanhoe.Types where


import Data.Text (pack, unpack)
import Database.Persist.Class
import Database.Persist.Sql
import Prelude


-- OK. There are *way* too many roles listed here. I'll chuck some out once the
-- dust starts to settle.
data Role = Owner
          | Reader
          | Author
          | Editor
          | Commentor
          deriving (Enum, Show, Read, Eq)

instance PersistField Role where
    toPersistValue = PersistText . pack . show

    fromPersistValue (PersistText v) = Right . read $ unpack v
    fromPersistValue _               = Left "Invalid value for Role."

instance PersistFieldSql Role where
    sqlType _ = SqlString

