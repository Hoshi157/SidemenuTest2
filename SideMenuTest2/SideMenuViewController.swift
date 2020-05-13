//
//  SideMenuViewController.swift
//  SideMenuTest2
//
//  Created by 福山帆士 on 2020/05/05.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    // ラッパークラス
    private let contentView = UIView(frame: .zero)
    private var contentMaxWidth: CGFloat {
        // boundsはローカルのview座標(なので固定)
        return view.bounds.width * 0.8
    }
    // 弱参照delegate。処理を任せる相手。
    weak var delegate: SidemenuViewControllerDelegate?
    private var panGestureRecognizer: UIPanGestureRecognizer!
    var isShow: Bool {
        return parent != nil
    }
    private var beganState: Bool = false
    private var beganLocation: CGPoint = .zero
    private var screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    
    // サイドメニューを閉じるボタン設置
    private var hideButton: UIButton {
        let button = UIButton(frame: CGRect(x: self.contentView.frame.maxX - 50, y: 50, width: 50, height: 50))
        button.setTitle("hide", for: .normal)
        button.frame.size = CGSize(width: 50, height: 50)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(hideButtonAction(_:)), for: .touchUpInside)
        return button
    }
    
    private var contentRatio: CGFloat {
        get{
            // maxXはcontentViewの右端の座標。そこからwidthの引いているためreturnは必ず0?
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .yellow
        
        // contentViewを設定
        var contentRect = view.bounds
        contentRect.size.width = contentMaxWidth
        contentView.frame = contentRect
        contentView.backgroundColor = .white
        contentView.autoresizingMask = .flexibleHeight
        view.addSubview(contentView)
        
        // 閉じるボタン設置
        contentView.addSubview(hideButton)
        
        // バックViewタップすると閉じる処理
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backViewTapped(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //　サイドメニューを表示する処理
    func showContentView(animated: Bool) {
        if animated {
            // trueはアニメーション
            UIView.animate(withDuration: 0.3) {
                self.contentRatio = 1.0
            }
        }else {
            // falseは表示されているためそのまま
            contentRatio = 1.0
        }
    }
    
    // サイドメニューを隠す処理(クロージャはアニメーション終了後に親子関係を解除するため)
    func hideContentView(animated: Bool, completion: ((Bool) -> Void)?) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentRatio = 0
                // completionクロージャにて終了後に呼ばれる
            }, completion: { (finished) in
                completion?(finished)
            })
        }else {
            contentRatio = 0
            completion?(true)
        }
    }
    
    // サイドメニューを隠すボタンの処理
    @objc func hideButtonAction(_ button: UIButton) {
        // delegateメソッドにて内包的にhideSidemunuを使用している。
        hideContentView(animated: true) { (_) in
            self.willMove(toParent: self)
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    // バックビューをタップした時の処理
    @objc func backViewTapped(_ sender: UITapGestureRecognizer) {
        hideContentView(animated: true) { (_) in
            self.willMove(toParent: self)
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    
    // ①mainVCを取得、②mainVCにaddGestureRecognizer
    func startPanGestureRecognizing() {
        // selfに処理を任せる。(ここではmainVCを取得している)
        if let parentViewController = self.delegate?.parentViewControllerForSidemenuViewController(self) {
            
            // SidemenuVCをpanするVCに指定(Tapは一度のみ, Panは繰り返し)
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandled(panGestureRecognizer:)))
            panGestureRecognizer.delegate = self
            // mainVCに追加する
            parentViewController.view.addGestureRecognizer(panGestureRecognizer)
            
            //　スクリーンの端をドラッグした時の認識
            screenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action:#selector(panGestureRecognizerHandled(panGestureRecognizer:)))
            screenEdgePanGestureRecognizer.edges = [.left]
            screenEdgePanGestureRecognizer.delegate = self
            parentViewController.view.addGestureRecognizer(screenEdgePanGestureRecognizer)
        }
    }
    
    // panの処理部分(アニメーション部分)
    @objc private func panGestureRecognizerHandled(panGestureRecognizer: UIPanGestureRecognizer) {
        // サイドメニューを表示すべきか(selfがSidemenuVCかどうか)
        guard  let shouldPresent = self.delegate?.shouldPresentSidemenuViewController(self), shouldPresent else {
            return
        }
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
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// デリゲートメソッド。メソッドは定義するのみで実装はしない。classに準じている。
protocol SidemenuViewControllerDelegate: class {
    func parentViewControllerForSidemenuViewController(_ sidemenuViewController: SideMenuViewController) -> UIViewController
    func shouldPresentSidemenuViewController(_ sidemenuViewController: SideMenuViewController) -> Bool
    func sidemenuViewControllerDidRequestShowing(_ sidemenuViewController: SideMenuViewController, contentAvailability: Bool, animeted: Bool)
    func sidemenuViewControllerDidRequestHiding(_ sidemenuViewController: SideMenuViewController, animeted: Bool)
    func sidemenuViewcontroller(_ sidemenuViewController: SideMenuViewController, didSelectItemAt indexPath: IndexPath)
}

extension SideMenuViewController: UIGestureRecognizerDelegate {
    
}
