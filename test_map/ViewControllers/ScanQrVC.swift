//
//  ScanQrVC.swift
//  test_map
//
//  Created by Evgeny on 19.08.2022.
//

import UIKit

class ScanQrVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let qrButton = NewButton(.init(title: "Посмотреть на карте", closure: getQR))
      
        let label = UITextView()
        let string = NSMutableAttributedString(string: "Условия использования Яндекс.Карт")
        string.addAttribute(.link, value: "https://yandex.ru/legal/maps_termsofuse", range: NSRange(location: 22, length: 11))
        
        label.attributedText = string
        label.textAlignment = .center
        
        if #available(iOS 13.0, *) {
            func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextInteraction) -> Bool {
            UIApplication.shared.open(URL)
            return false
        }
        } else {
//            if let url = URL(string: label.text!) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
        } 
        
        view.addSubview(qrButton)
        view.addSubview(label)
        setupQrButton()
        setupLabel()
        
        func setupQrButton() {
            qrButton.translatesAutoresizingMaskIntoConstraints = false
            qrButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            qrButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            qrButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
        }
        
        func setupLabel() {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
            label.heightAnchor.constraint(equalToConstant: 24).isActive = true
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        }
    }
}

private extension ScanQrVC {
    
    private func getQR() {
        print("QR-code scanned")
        
        // go to map view controller
        let mapVC = MapViewController()
        mapVC.modalPresentationStyle = .fullScreen
        present(mapVC, animated: true)
       
    }
}
