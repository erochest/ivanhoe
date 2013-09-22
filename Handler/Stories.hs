module Handler.Stories where


import Database.Persist

import Import


getStoriesR :: Handler Html
getStoriesR = do
    stories <- runDB $ selectList [] [Desc StorySubmitted]
    defaultLayout $
        $(widgetFile "stories")

storySummary :: Story -> WidgetT App IO ()
storySummary story = $(whamletFile "templates/story_summary.hamlet")

