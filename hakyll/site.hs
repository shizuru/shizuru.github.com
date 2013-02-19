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

  match (fromList ["index.jade", "about.jade", "member.jade"]) $ do
    route $ setExtension "html"
    compile $ getResourceString
      >>= withItemBody (unixFilter "bin/sjade" [])
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  match (fromList ["code.markdown", "persistent.md"]) $ do
    route   $ setExtension "html"
    compile $ pandocCompiler
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

config :: Configuration
config = defaultConfiguration { deployCommand = deploy }
  where deploy = "cp -r _site/* .. && ./site clean"