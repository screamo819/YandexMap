//
//  BaseMapView.swift
//  test_map
//
//  Created by Evgeny on 19.08.2022.
//

import UIKit
import YandexMapsMobile

class BaseMapView: UIView {

    var contentView = UIView()
    @objc public var mapView = YMKMapView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        mapView.mapWindow.map.mapType = .map
        contentView.insertSubview(mapView, at: 0)

    }
}
