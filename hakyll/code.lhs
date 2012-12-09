---
title: Code
---
<div class="row">
<div class="span10 offset1">

このサイトはHakskell製JekyllクローンであるHakyllで構築されています。
よいこのみんなのマシンにはHaskell Platformは既に入っていると思うので早速cabalしましょ
う。

    cabal install hakyll

site構築用のコマンドをコンパイルするには

    ghc --make site

そのあと

> ./site build

でビルドします。ローカルでチェックするには

> ./site server

でlocalhost:8000でwebサーバーが起動するので確認してください。
問題なければ

> ./site deploy

で_site以下のhtmlをトップディレクトリに移動し
コミットしてプッシュしてください。

これでGithub Pagesが更新されます。</div></div>
