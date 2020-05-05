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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .red
        
        showSidemenu(animated: true)
    }
    
    private func showSidemenu(contentAvailabilty: Bool = true, animated: Bool) {
        
        // contentVCはnavigation
        let contentVC = self.storyboard!.instantiateViewController(withIdentifier: "navi")
        // rootVCの子VCにsideMenuVCを追加。
        self.addChild(sideMenuVC)
        sideMenuVC.view.autoresizingMask = .flexibleHeight
        sideMenuVC.view.frame = contentVC.view.bounds
        sideMenuVC.didMove(toParent: self)
        
        // viewはroot→content→sideMenuの順に
        self.view.insertSubview(sideMenuVC.view, aboveSubview: contentVC.view)
        
    }


}

