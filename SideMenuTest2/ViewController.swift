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
    private var contentVC: UIViewController? {
        return self.storyboard?.instantiateViewController(identifier: "navi")
    }
    private var isShowSidemenu: Bool {
        return sideMenuVC.parent == self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .red
        
        addChild(contentVC!)
        view.addSubview(contentVC!.view)
        didMove(toParent: self)
    }
    
    func showSidemenu(contentAvailabilty: Bool = true, animated: Bool) {
        if isShowSidemenu {return}
        
        // rootVCの子VCにsideMenuVCを追加。
        self.addChild(sideMenuVC)
        sideMenuVC.view.autoresizingMask = .flexibleHeight
        sideMenuVC.view.frame = contentVC!.view.bounds
        // viewはroot→content→sideMenuの順に
        self.view.insertSubview(sideMenuVC.view, aboveSubview: contentVC!.view)
        sideMenuVC.didMove(toParent: self)
        
        if contentAvailabilty {
            sideMenuVC.showContentView(animated: animated)
        }
    }


}

