---
title: Code
---

このサイトはHakskell製JekyllクローンであるHakyllで構築されているので、
修正したい場合にはhakyllをインストールする必要があります。よいこのみん
なのマシンにはHaskell Platformは既に入っていると思うので早速cabalしましょ
う。

> cabal install hakyll

site構築用のコマンドをコンパイルするには

> ghc --make site

そのあと

> ./site build

で、サイトが構築されるので、_site以下のhtmlをトップディレクトリに移動し
たらコミットしてプッシュしてください。

