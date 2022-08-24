//
//  BaseMapViewController.swift
//  test_map
//
//  Created by Evgeny on 19.08.2022.
//

import UIKit
import YandexMapsMobile

class BaseMapViewController : UIViewController {
    
    var baseMapView = BaseMapView()
    
    var mapView: YMKMapView! {
        get {
            return baseMapView.mapView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
