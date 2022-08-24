//
//  TabBarController.swift
//  test_map
//
//  Created by Evgeny on 19.08.2022.
//

import UIKit

class TabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        tabBar.tintColor = .orange
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = 5
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.layer.borderWidth = 0
        self.tabBar.clipsToBounds = false
        
        if #available(iOS 13.0, *) {
            self.tabBar.backgroundColor = UIColor.systemBackground
        } else {
            self.tabBar.backgroundColor = UIColor.white
        }
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        if #available(iOS 13.0, *) {
            UITabBar.appearance().barTintColor = .systemBackground
        } else {
            self.tabBar.backgroundColor = UIColor.white
        }
        
        setupVCs()
    }
    
    func setupVCs () {
        if #available(iOS 13.0, *) {
            viewControllers = [
                createNavController(for: MainVC(), title: NSLocalizedString("Главная", comment: ""), image: UIImage(systemName: "house.fill")!),
                createNavController(for: CouponsVC(), title: NSLocalizedString("Купоны", comment: ""), image: UIImage(systemName: "tag")!),
                createNavController(for: ScanQrVC(), title: NSLocalizedString("Сканировать", comment: ""), image: UIImage(systemName: "qrcode.viewfinder")!),
                createNavController(for: SupportVC(), title: NSLocalizedString("Поддержка", comment: ""), image: UIImage(systemName: "person.wave.2.fill")!),
                createNavController(for: ProfileVC(), title: NSLocalizedString("Профиль", comment: ""), image: UIImage(systemName: "person")!)
            ]
        } else {
            viewControllers = [
                createNavController(for: MainVC(), title: NSLocalizedString("Главная", comment: ""), image: UIImage(named: "house.fill")!),
                createNavController(for: CouponsVC(), title: NSLocalizedString("Купоны", comment: ""), image: UIImage(named: "tag")!),
                createNavController(for: ScanQrVC(), title: NSLocalizedString("Сканировать", comment: ""), image: UIImage(named: "qrcode.viewfinder")!),
                createNavController(for: SupportVC(), title: NSLocalizedString("Поддержка", comment: ""), image: UIImage(named: "person.wave.2.fill")!),
                createNavController(for: ProfileVC(), title: NSLocalizedString("Профиль", comment: ""), image: UIImage(named: "person")!)
            ]
        }
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = false
        navController.navigationBar.layer.masksToBounds = false
        
        var rigthButton1, rigthButton2, menuButton : UIBarButtonItem?
        
        if #available(iOS 13.0, *) {
             rigthButton1 = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(rightHandAction1))
        } else {
             rigthButton1 = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(rightHandAction1))
        }
        
        if #available(iOS 13.0, *) {
             rigthButton2 = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(rightHandAction2))
        } else {
             rigthButton2 = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(rightHandAction2))
        }
        
        if #available(iOS 13.0, *) {
             menuButton = UIBarButtonItem(image: UIImage(systemName: "menucard"), style: .plain, target: self, action: #selector(leftHandAction))
        } else {
             menuButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(leftHandAction))
        }
        
        rootViewController.navigationItem.setLeftBarButtonItems([menuButton!], animated: true)
        rootViewController.navigationItem.setRightBarButtonItems([rigthButton1!, rigthButton2!], animated: true)
        rootViewController.navigationItem.title = "TEST_APP"
        
        return navController
    }
    
    @objc func rightHandAction1() {
        print("right bar button action #1")
    }
    
    @objc func rightHandAction2() {
        print("right bar button action #2")
    }
    
    @objc func leftHandAction() {
        print("OPEN MENU")
    }
    
}
