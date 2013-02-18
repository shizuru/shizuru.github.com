{-# LANGUAGE OverloadedStrings #-}
import Hakyll

main :: IO ()
main = hakyllWith config $ do
  match "images/*" $ do
    route   idRoute
    compile copyFileCompiler

  match "css/*" $ do
    route   idRoute
    compile compressCssCompiler

  match "templates/*" $ compile templateCompiler

  match "bootstrap/bootstrap/**" $ do
    route $ gsubRoute "bootstrap/bootstrap/" (const "")
    compile copyFileCompiler

  match (fromList ["index.html", "about.html", "member.html"]) $ do
    route   idRoute
    compile $ getResourceBody
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  match (fromList ["code.markdown"]) $ do
    route   $ setExtension "html"
    compile $ pandocCompiler
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

config :: Configuration
config = defaultConfiguration { deployCommand = deploy }
  where deploy = "cp -r _site/* .. && ./site clean"