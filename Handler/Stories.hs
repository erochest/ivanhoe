module Handler.Stories where


import           Data.Time
import           Data.Time.Format.Human

import           Database.Persist
import           Yesod.Auth

import           Import


timeFormat :: String
timeFormat = "%FT%T%z"

getStoriesR :: Handler Html
getStoriesR = do
    stories <- runDB $ selectList [] [Desc StorySubmitted]
    defaultLayout $
        $(widgetFile "stories")

storySummary :: Story -> WidgetT App IO ()
storySummary story = $(whamletFile "templates/story_summary.hamlet")

getNewStoryR :: Handler Html
getNewStoryR = do
    userId <- requireAuthId
    now    <- liftIO getCurrentTime
    (widget, enctype) <- generateFormPost storyForm
    defaultLayout $ do
        $(widgetFile "story_form")

postNewStoryR :: Handler Html
postNewStoryR = do
    Entity userId user <- requireAuth
    ((result, widget), enctype) <- runFormPost storyForm
    case result of
        FormSuccess storyInfo -> runDB (insertStory storyInfo userId) >>= redirect . StoryR
        _ -> defaultLayout $ do
            $(widgetFile "story_form")

getStoryR :: StoryId -> Handler Html
getStoryR storyId = do
    story     <- runDB $ get404 storyId
    owner     <- runDB . get404 $ storyOwner story
    submitted <- liftIO . humanReadableTime $ storySubmitted story
    defaultLayout $ do
        $(widgetFile "story_detail")

data StoryInfo = StoryInfo Text Text Bool

storyForm :: Html -> MForm Handler (FormResult StoryInfo, Widget)
storyForm = renderBootstrap $ StoryInfo
    <$> areq textField "Title" Nothing
    <*> fmap unTextarea (areq textareaField "Content" Nothing)
    <*> areq boolField "Public" (Just False)

insertStory :: ( PersistStore m
               , PersistMonadBackend m ~ PersistEntityBackend Story
               , PersistEntity Story
               )
            => StoryInfo -> UserId -> m StoryId
insertStory (StoryInfo title content public) ownerId = do
    now <- liftIO getCurrentTime
    insert $ Story title content now ownerId public

