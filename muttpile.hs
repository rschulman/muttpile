import Graphics.Vty.Widgets.All
import Graphics.Vty.Attributes
import Graphics.Vty.LLInput
import qualified Data.Text as T
import Data.Time
import System.Exit ( exitSuccess )

data Message = Message String String String UTCTime String deriving (Show)

main :: IO()
main = do
	searchText <- editWidget
	topLabel <- plainText (T.pack "Inbox:")
	emailList <- newList (black `on` white) :: List Message FormattedText 
	searchBox <- (plainText (T.pack "Search:")) <++> (return searchText)
	searchBar <- vFixed 1 searchBox 
	mainLayout <- (return topLabel) <--> hBorder <--> (return emailList) <--> (return searchBar) 

	fg <- newFocusGroup
	fg `onKeyPressed` \_ key modifiers -> do
		if key == KASCII 'q' && elem MCtrl modifiers then exitSuccess else return False
	_ <- addToFocusGroup fg mainLayout

	c <- newCollection
	_ <- addToCollection c mainLayout fg 
	runUi c defaultContext
