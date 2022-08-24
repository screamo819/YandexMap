//
//  ProfileVC.swift
//  test_map
//
//  Created by Evgeny on 19.08.2022.
//
import UIKit

class ProfileVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 15.0, *) {
            view.backgroundColor = .systemMint
        } else {
            view.backgroundColor = .blue
        }
        
//        let enterVC = EnterViewController()
//        present(enterVC, animated: true)
    }
}

class EnterViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
