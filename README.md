# SidemenuTest2
* サイドメニューの実装という記事をもとにtwitterの様なサイドメニューを実装した

## データ構造
* mainVCのchildVCにcontentVC(navigationVC)を追加する
* サイドメニューが表示されるときSidemenuVCをmainVCのchildVCに追加してviewのならびをmain→content(navigation)→sidemenuの順にする

## 動きのアニメーション
```
private var contentRatio: CGFloat {
        get{
            // maxXはcontentViewの右端の座標を取得。
            return contentView.frame.maxX / contentMaxWidth
        }
        set{
            // ratioを0~1前としてnewValueはcontentRatio
            let ratio = min(max(newValue, 0), 1)
            // 左端の座標を設定(origin.x)
            contentView.frame.origin.x = contentMaxWidth * ratio - contentView.frame.width
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowRadius = 3.0
            contentView.layer.shadowOpacity = 0.8
            
            // backViewを透けさせて影が掛かった様に見せる
            view.backgroundColor = UIColor(white: 0, alpha: 0.3 * ratio)
        }
    }
    
  ```
* contentView(ラッパークラスUIView)をsidemenuVCのwide0.8として表示させてcontentView.frame.origin.xにて左端の座標を設定しアニメーションしている。
* contentRatioに0 or 1を入れることでアニメーションとなる
    
## サイドメニューを閉じる処理(backViewをタップ、Sidemenuのボタンをタップ)
* サイドメニューに閉じるボタンを設置した
* mainVCのメソッド、インスタンスなどが必要なときはdelegateメソッドが非常に便利だった。
             
            
