module Handler.Fay where

import Import
import Yesod.Fay
import Fay.Convert (readFromFay)

onCommand :: CommandHandler App
onCommand render command =
    case readFromFay command of
      Just (Echo input r) -> render r $ input
      Nothing               -> invalidArgs ["Invalid command"]
