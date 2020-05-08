//
//  ViewController.swift
//  SideMenuTest2
//
//  Created by 福山帆士 on 2020/05/05.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let sideMenuVC = SideMenuViewController()
    // ストーリーボードにてnevigation実装するとタップが反応しない
    private let contentViewController = UINavigationController(rootViewController: UIViewController())
    // sideMenuVCがrootの親だったらtrue(すなわちサイドメニューが表示されている)
    private var isShowSidemenu: Bool {
        return sideMenuVC.parent == self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .red
        
        // contentVC(navigationVC)をaddchild
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
        // contentVCの設定(viewcontrollers[0]を追加しないとボタンが表示されず)
        contentViewController.viewControllers[0].view.backgroundColor = .blue
        contentViewController.viewControllers[0].navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(menuAction(_:)))
    }
    
    // ①サイドメニュー判定 ②サイドメニューをrootの子に追加 ③viewの重なりを設定
    private func showSidemenu(contentAvailabilty: Bool = true, animated: Bool) {
        // サイドメニュー判定
        if isShowSidemenu {return}
        
        // rootVCの子VCにsideMenuVCを追加。
        self.addChild(sideMenuVC)
        sideMenuVC.view.autoresizingMask = .flexibleHeight
        // contentVCとsideMenuVCの大きさを合わせる
        sideMenuVC.view.frame = contentViewController.view.bounds
        // viewはroot→content→sideMenuの順に(contentVCの上に)
        self.view.insertSubview(sideMenuVC.view, aboveSubview: contentViewController.view)
        sideMenuVC.didMove(toParent: self)
        
        // ここで動きの処理が入る
        if contentAvailabilty {
            sideMenuVC.showContentView(animated: animated)
        }
    }
    
    // ①サイドメニュー判定 ②アニメーションが終了したらsideMenuVCの親子関係を解除
    func hideSideMenu(animated: Bool) {
        if !isShowSidemenu {return}
        
        sideMenuVC.hideContentView(animated: animated, completion: { (_) in
            self.sideMenuVC.willMove(toParent: nil)
            self.sideMenuVC.removeFromParent()
            self.sideMenuVC.view.removeFromSuperview()
        })
    }
    
    //contentViewのボタンタップ処理
    @objc func menuAction(_ button: UIBarButtonItem) {
        print("tap")
        showSidemenu(animated: true)
        
    }


}

