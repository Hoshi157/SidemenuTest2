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
* backViewの処理はsidemenuVCにUITapGestureRecognizerを追加して閉じる処理。
             
## Panの処理
~~~
// 既に表示されているとき右方向のpanは無視(translation.xが0以上というのはviewが表示されていると判断)
        let translation = panGestureRecognizer.translation(in: view)
        if translation.x > 0 && contentRatio == 1.0 {
            return
        }
        
        let location = panGestureRecognizer.location(in: view)
        switch panGestureRecognizer.state {
            // 開始
        case .began:
            // 親VCがある場合ture(表示、非表示を判定)
            beganState = isShow
            beganLocation = location
            // viewが表示されている場合、
            if translation.x >= 0 {
                // 何もしない
                self.delegate?.sidemenuViewControllerDidRequestShowing(self, contentAvailability: false, animeted: false)
            }
            // 動かしている最中(繰り返し)指に追随する処理
        case .changed:
            let distance = beganState ? beganLocation.x : location.x - beganLocation.x
            if distance >= 0 {
                let ratio = distance / (beganState ? beganLocation.x : (view.bounds.width - beganLocation.x))
                let contentRatio = beganState ? 1 - ratio : ratio
                self.contentRatio = contentRatio
            }
            // 終了時(主に)最後までPanしなかったケースを想定する
        case .ended, .cancelled, .failed:
            if contentRatio >= 1.0, contentRatio <= 0 {
                // 現在の座標と開始時の座標を比べて
                if location.x > beganLocation.x {
                    showContentView(animated: true)
                }else {
                    self.delegate?.sidemenuViewControllerDidRequestHiding(self, animeted: true)
                }
            }
            beganLocation = .zero
            beganState = false
        default: break
        }
 ~~~
        
        
* sidemenuVCにUIPanGestureRecognizerを設定してmainVCにaddGestureRecognizerする。
* メソッドはmainVC側で呼ぶ
* panGestureRecognizer.stateのswicth文でアニメーションの処理部分を呼ぶ。

## ScreenEdge(両端をドラッグと反応する処理)
* sidemenuVCにUIScreenEdgePanGestureRecognizerを設定してmainVCにaddGestureRecognizerする
             
