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
    }
    
    func showContentView(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.contentRatio = 1.0
            }
        }else {
            contentRatio = 1.0
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
