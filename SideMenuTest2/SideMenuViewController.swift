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
    private var rootViewController: ViewController? {
        return self.parent as? ViewController
    }
    
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
        print("hide")
        
        // ここのエラー文はなんとかならないか？
        guard let viewVC = rootViewController else {return}
        viewVC.hideSideMenu(animated: true)
    }
    
    @objc func backViewTapped(_ sender: UITapGestureRecognizer) {
        print("backView")
        guard let viewVC = rootViewController else {return}
        viewVC.hideSideMenu(animated: true)
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
