//
//  CouponsVC.swift
//  test_map
//
//  Created by Evgeny on 19.08.2022.
//

import UIKit

class CouponsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemIndigo
        } else {
            view.backgroundColor = .cyan
        }
    }
}
