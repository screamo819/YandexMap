//
//  extButton.swift
//  test_map
//
//  Created by Evgeny on 19.08.2022.
//

import UIKit


struct ButtonModel {
    let title: String
    let closure: () -> Void
}

class NewButton : UIButton {
    
    private var closure: () -> Void
    
    init (_ model: ButtonModel) {
        
        self.closure = model.closure
        super.init(frame: .zero)
        setup(title: model.title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(title: String) {
        backgroundColor = .systemGreen
        setTitle(title, for: .normal)
        layer.cornerRadius = 28
        layer.masksToBounds = true
        addTarget(self, action: #selector(addOrder), for: .touchUpInside)
        startAnimatingPressActions()
    }
    
    @objc func addOrder() {
        closure()
    }
}


public extension UIButton {
    
    func startAnimatingPressActions() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.90, y: 0.90))
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
            button.transform = transform
        }, completion: nil)
    }
}
