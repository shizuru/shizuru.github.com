---
title: Persistent入門
---

<div class="container">
<div class="span12">
# Persistent入門
[persistent](http://www.yesodweb.com/book/persistent)を単独で使えるようになるために、入門的な内容を書いてみます。

インストールしたバージョンは以下の通り

- persistent-1.1.4
- persistent-sqlite-1.1.2
- persistent-template-1.1.2.1

## Install

仮想環境で試します。

    mkvhenv persistent
    cabal install persistent
    cabal install persistent-template
    cabal install persistent-sqlite

## 使い方

まずは[サンプル](http://www.yesodweb.com/book/persistent)を動かしてみる。

    {-# LANGUAGE QuasiQuotes, TypeFamilies, GeneralizedNewtypeDeriving, TemplateHaskell,
                 OverloadedStrings, GADTs, FlexibleContexts #-}
    import Database.Persist
    import Database.Persist.TH
    import Database.Persist.Sqlite
    import Control.Monad.IO.Class (liftIO)
    import Control.Monad.Trans.Resource (runResourceT)
    
    share [mkPersist sqlSettings, mkSave "entityDefs"] [persist|
    Person
        name String
        age Int
        deriving Show
    |]
    
    main = runResourceT $ withSqliteConn ":memory:" $ runSqlConn $ do
        runMigration $ migrate entityDefs (undefined :: Person) -- this line added: that's it!
        michaelId <- insert $ Person "Michael" 26
        michael <- get michaelId
        liftIO $ print michael

言語拡張は[Haskellの言語拡張たち / rfな日記](http://d.hatena.ne.jp/rf0444/20120513/1336883141)を参考に。

## マイグレーションの秘密をさぐる

memoryじゃなくファイルに書き出します。

    {-# LANGUAGE QuasiQuotes, TemplateHaskell, TypeFamilies, OverloadedStrings #-}
    {-# LANGUAGE GADTs, FlexibleContexts #-}
    import Database.Persist
    import Database.Persist.Sqlite
    import Database.Persist.TH
    import Control.Monad.IO.Class (liftIO)
    
    share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persist|
    Person
        name String
        age Int Maybe
        loc String default="Japan"
        deriving Show
    |]
    
    main :: IO ()
    main = withSqliteConn "test.db" $ runSqlConn $ do
        runMigration migrateAll
        johnId <- insert $ Person "kzfm" (Just 20) "Fuji"
        liftIO $ print johnId

続いてEntityを変更してみる。locを追加してdefaultも付けておく。ついでにinsertのとこも修正しておく

    share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persist|
    Person
        name String
        age Int Maybe
        loc String default="Japan"
        deriving Show
    |]
    
    main :: IO ()
    main = withSqliteConn "test.db" $ runSqlConn $ do
        runMigration migrateAll
        johnId <- insert $ Person "kzfm" (Just 20) "Fuji"
        liftIO $ print johnId

実行したらdefaultは何をしているのか確かめる。続いてdefaultを設定しない場合にはmigrationに失敗することを確認する。

- フィールドのデータタイプが変更された時 。ただし変更できる時のみ
- (The datatype of a field changed. However, the database may object to this modification if the data cannot be translated.)
- フィールドが追加された時で、フィールドがnot nullの場合はdefaultが指定されている時 
- (A field was added. However, if the field is not null, no default value is supplied (we'll discuss defaults later) and there is already data in the database, the database will not allow this to happen.)
- フィールドがnot nullからnullに変更された時。逆のケースも試みるがデータベース次第 
- (A field is converted from not null to null. In the opposite case, Persistent will attempt the conversion, contingent upon the database's approval.)
- 新しいエンティティが追加された時
- (A brand new entity is added.)

## 関数

insertとかそういうやつ

- [Database.Persist の関数群を簡単に説明](http://qiita.com/items/2d57f7fe6296590faa80)


## MongoDBでもやってみたい。

時間が余ったらMongoDBでもやってみる。

- [MongoDB](http://d.hatena.ne.jp/rf0444/20120430/1335778852)

</div>
</div>
