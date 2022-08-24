//
//  ViewController.swift
//  test_map
//
//  Created by Evgeny on 19.08.2022.
//

import UIKit
import YandexMapsMobile
import CoreLocation

class MapViewController: BaseMapViewController, YMKUserLocationObjectListener {
    
    var pinManager = PinManager()
    let geocoder = CLGeocoder()
    
    private let CLUSTER_CENTERS: [YMKPoint] = [
        YMKPoint(latitude: 55.756, longitude: 37.618)
    ]
    
    private let PLACEMARKS_NUMBER = 5000
    private let FONT_SIZE: CGFloat = 15
    private let MARGIN_SIZE: CGFloat = 4
    private let STROKE_SIZE: CGFloat = 3
    
    let currentLocation = CLLocationManager()
    var currentLatitude: CLLocationDegrees = 0.0
    var currentLongitude: CLLocationDegrees = 0.0
    
    let hardLAT = 55.713451
    let hardLONG = 37.588575
    
    lazy var pinImage: UIImageView = {
        let pinImage = UIImageView()
        
        if #available(iOS 13.0, *) {
            pinImage.image = UIImage(systemName: "pin.fill")
        } else {
            pinImage.image = UIImage(named: "pin.fill")
        }
        pinImage.tintColor = .systemBlue.withAlphaComponent(0.8)
        pinImage.contentMode = .scaleAspectFill
        pinImage.translatesAutoresizingMaskIntoConstraints = false
        return pinImage
    }()
    
    lazy var targetImage: UIImage = {
        var targetImg = UIImage()
        if #available(iOS 13.0, *) {
            targetImg = UIImage(systemName: "dot.circle.and.hand.point.up.left.fill")!
        } else {
            targetImg = UIImage(named: "dot.circle.and.hand.point.up.left.fill")!
        }
        return targetImg
    }()
    
    let locationButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(getUserLocation), for: .touchUpInside)
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "location"), for: .normal)
        } else {
            button.setImage(UIImage(named: "location"), for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        } else {
            button.setImage(UIImage(named: "x.circle.fill"), for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let pointButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(getTargets), for: .touchUpInside)
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "target"), for: .normal)
        } else {
            button.setImage(UIImage(named: "target"), for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let zoomInButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(zoom), for: .touchUpInside)
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        } else {
            button.setImage(UIImage(named: "plus.circle.fill"), for: .normal)
        }
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let zoomOutButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        button.tintColor = UIColor.black
        button.tag = 0
        button.addTarget(self, action: #selector(zoom), for: .touchUpInside)
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        } else {
            button.setImage(UIImage(named: "minus.circle.fill"), for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var streetNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Здесь будет отображаться адрес"
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .systemGray.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        return label
    }()
    
    var targetsDidSet = false
    var circleMapObjectTapListener: YMKMapObjectTapListener!
    
    var points = [YMKPoint]()
    
    // MARK: - ViewDidLoad -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentLocation.requestWhenInUseAuthorization()
        currentLocation.delegate = self
        currentLocation.startUpdatingLocation()
        
        let location = YMKPoint(latitude: currentLatitude, longitude: currentLongitude)
        YMKMapKit.sharedInstance().onStart()
        mapView.mapWindow.map.addCameraListener(with: self)
        
        setupMapView()
        moveMap(to: location)
        setupLocation()
//        setupLabel()
        
        points = createPoints()
        createTappableCircle()
    }
    
    //MARK: - update label text -
    
//    func setupLabel() {
//
//
//        if CLLocationManager.locationServicesEnabled() {
//            switch CLLocationManager.authorizationStatus() {
//            case .notDetermined, .restricted, .denied:
//                print("*** No access")
//                updateLabel(location)
//            case .authorizedAlways, .authorizedWhenInUse:
//                print("*** Access")
//            }
//        } else {
//            print("*** Location services are not enabled")
//        }
//    }
    
    func updateLabel(_ target: YMKPoint) {
        streetNameLabel.text = "Wait ..."
        let newLocation = CLLocation(latitude: target.latitude, longitude: target.longitude)
        geocoder.reverseGeocodeLocation(newLocation, completionHandler: { [unowned self] (placemarks, error) in
            if error == nil, let p = placemarks, !p.isEmpty {
                if let street = p.first?.thoroughfare {
                    self.streetNameLabel.text = street
                    if let house = p.first?.subThoroughfare {
                        self.streetNameLabel.text = "\(street) \(house)"
                    }
                }
            } else {
                self.streetNameLabel.text = "Error ..."
            }
        })
    }
    
    func createPoints() -> [YMKPoint]{
       
        for _ in 0..<PLACEMARKS_NUMBER {
            let clusterCenter = CLUSTER_CENTERS.randomElement()!
            let latitude = clusterCenter.latitude + randomDouble()  - 0.5
            let longitude = clusterCenter.longitude + randomDouble()  - 0.5
            
            points.append(YMKPoint(latitude: latitude, longitude: longitude))
        }
        
        return points
    }
    
//MARK: - create tappable circle -
    
    func createTappableCircle() {
        let mapObjects = mapView.mapWindow.map.mapObjects
        
        for point in points {
            let circle = mapObjects.addCircle(
                with: YMKCircle(center: point, radius: 20),
                stroke: UIColor.red,
                strokeWidth: 1,
                fill: UIColor.white.withAlphaComponent(0.4))
            circle.zIndex = 100
            circle.userData = PointMapObjectUserData(id: 101, description: "Tappable circle")
            circle.addTapListener(with: self)
        }
    }
    
    // MARK: - setup user location -
    
    func setupLocation() {
        let mapKit = YMKMapKit.sharedInstance()
        let userLocationlayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
//        let scale = UIScreen.main.scale
//        userLocationlayer.setAnchorWithAnchorNormal(
//            CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.5 * mapView.frame.size.height * scale),
//            anchorCourse: CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.83 * mapView.frame.size.height * scale))
        
        userLocationlayer.setVisibleWithOn(true)
        userLocationlayer.isHeadingEnabled = true
        userLocationlayer.setObjectListenerWith(self)
    }
    
    //MARK: - setup targets on map -
    
    func setupTargets() {
        let collection = mapView.mapWindow.map.mapObjects.addClusterizedPlacemarkCollection(with: self)
        
        collection.addPlacemarks(with: points, image: targetImage, style: YMKIconStyle())
        collection.clusterPlacemarks(withClusterRadius: 50, minZoom: 19)
        collection.addTapListener(with: self)
    }
    
    // MARK: - move map -
    
    func moveMap(to location: YMKPoint?) {
        guard let location = location else { return }
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: location, zoom: 12, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 3),
            cameraCallback: nil)
    }
    
    func moveMapToUserLocation(latitude: Double, longitude: Double) {
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: latitude, longitude: longitude), zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 4),
            cameraCallback: nil)
    }
    //MARK: - setup map view -
    
    func setupMapView() {
        mapView.clearsContextBeforeDrawing = true
        mapView.mapWindow.map.isRotateGesturesEnabled = false
        
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(locationButton)
        locationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        locationButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        locationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -180).isActive = true
        locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(backButton)
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(pointButton)
        pointButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pointButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pointButton.topAnchor.constraint(equalTo: locationButton.topAnchor, constant: -60).isActive = true
        pointButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(zoomInButton)
        zoomInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        zoomInButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        zoomInButton.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 120).isActive = true
        zoomInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(zoomOutButton)
        zoomOutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        zoomOutButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        zoomOutButton.topAnchor.constraint(equalTo: zoomInButton.topAnchor, constant: 60).isActive = true
        zoomOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(streetNameLabel)
        streetNameLabel.translatesAutoresizingMaskIntoConstraints = false
        streetNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        streetNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        streetNameLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        streetNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupPinImage() {
        view.addSubview(pinImage)
        pinImage.translatesAutoresizingMaskIntoConstraints = false
        pinImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        pinImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        pinImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pinImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
    }
    
    // MARK: - button actions -
    
    @objc func backAction() {
        dismiss(animated: true)
    }
    
    @objc func getUserLocation() {
        setupPinImage()
        moveMapToUserLocation(latitude: currentLatitude, longitude: currentLongitude)
    }
    
    @objc func getTargets() {
        
        if !targetsDidSet {
            setupTargets()
        } else { return }
        
        targetsDidSet = true
    }
    
    @objc func zoom(sender: UIButton) {
        let zoomStep: Float = sender.tag == 0 ? -1 : 1
        let center = mapView.mapWindow.map.cameraPosition.target
        let position = YMKCameraPosition(target: center, zoom: mapView.mapWindow.map.cameraPosition.zoom + zoomStep, azimuth: 0, tilt: 0)
        mapView.mapWindow.map.move(with: position, animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.5), cameraCallback: nil)
    }
    
    // MARK: - setup cluster image -
    
    func clusterImage(_ clusterSize: UInt) -> UIImage {
        let scale = UIScreen.main.scale
        let text = (clusterSize as NSNumber).stringValue
        let font = UIFont.systemFont(ofSize: FONT_SIZE * scale)
        let size = text.size(withAttributes: [NSAttributedString.Key.font: font])
        let textRadius = sqrt(size.height * size.height + size.width * size.width) / 2
        let internalRadius = textRadius + MARGIN_SIZE * scale
        let externalRadius = internalRadius + STROKE_SIZE * scale
        let iconSize = CGSize(width: externalRadius * 2, height: externalRadius * 2)
        
        UIGraphicsBeginImageContext(iconSize)
        let ctx = UIGraphicsGetCurrentContext()!
        
        ctx.setFillColor(UIColor.red.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: .zero,
            size: CGSize(width: 2 * externalRadius, height: 2 * externalRadius)));
        
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: CGPoint(x: externalRadius - internalRadius, y: externalRadius - internalRadius),
            size: CGSize(width: 2 * internalRadius, height: 2 * internalRadius)));
        
        (text as NSString).draw(
            in: CGRect(
                origin: CGPoint(x: externalRadius - size.width / 2, y: externalRadius - size.height / 2),
                size: size),
            withAttributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.black])
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    //MARK: - work with objects -
    
    func onObjectAdded(with view: YMKUserLocationView) {
        if #available(iOS 13.0, *) {
            view.arrow.setIconWith(UIImage(systemName: "arrow.up.left.circle.fill")!)
        } else {
            view.arrow.setIconWith(UIImage(named: "arrow.up.left.circle.fill")!)
        }
        
        let pinPlacemark = view.pin.useCompositeIcon()
        
        if #available(iOS 13.0, *) {
            pinPlacemark.setIconWithName("figure",
                                         image: UIImage(systemName: "figure.wave")!,
                                         style:YMKIconStyle(
                                            anchor: CGPoint(x: 0, y: 0) as NSValue,
                                            rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                                            zIndex: 0,
                                            flat: true,
                                            visible: true,
                                            scale: 1.5,
                                            tappableArea: nil))
        } else {
            pinPlacemark.setIconWithName("figure",
                                         image: UIImage(named: "figure.wave")!,
                                         style:YMKIconStyle(
                                            anchor: CGPoint(x: 5, y: 5) as NSValue,
                                            rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                                            zIndex: 0,
                                            flat: true,
                                            visible: true,
                                            scale: 1.5,
                                            tappableArea: nil))
        }
        
        if #available(iOS 13.0, *) {
            pinPlacemark.setIconWithName(
                "pin",
                image: UIImage(systemName: "pin")!,
                style:YMKIconStyle(
                    anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                    rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                    zIndex: 1,
                    flat: true,
                    visible: true,
                    scale: 1,
                    tappableArea: nil))
        } else {
            pinPlacemark.setIconWithName(
                "pin",
                image: UIImage(named: "pin")!,
                style:YMKIconStyle(
                    anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                    rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                    zIndex: 1,
                    flat: true,
                    visible: true,
                    scale: 1,
                    tappableArea: nil))
        }

        view.accuracyCircle.fillColor = UIColor.blue
    }
    
    func onObjectRemoved(with view: YMKUserLocationView) {
        
    }
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {
        
    }
}

// MARK: - EXT get current location -

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            currentLocation.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationSafe = locations.last {
            currentLocation.stopUpdatingLocation()
            let latitude = locationSafe.coordinate.latitude
            let longitude = locationSafe.coordinate.longitude
            self.currentLatitude = latitude
            self.currentLongitude = longitude
            print(" Latitude \(latitude) ,  Longitude \(longitude)")
        }
        
        if locations.first != nil {
            print("location:: \(locations[0])")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        
        print(error)
    }
}

// MARK: - EXT create cluster points -

extension MapViewController: YMKClusterListener, YMKClusterTapListener {
    
    func onClusterAdded(with cluster: YMKCluster) {
        cluster.appearance.setIconWith(clusterImage(cluster.size))
        cluster.addClusterTapListener(with: self)
    }
    
    func onClusterTap(with cluster: YMKCluster) -> Bool {
        let alert = UIAlertController(
            title: "Внимание!",
            message: String(format: "В этом районе %u варианта", cluster.size),
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
        return true
    }
    
    func randomDouble() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX)
    }
    
    
}


// MARK: - EXT move map and get adress -

extension MapViewController: YMKMapCameraListener {
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason cameraUpdateSource: YMKCameraUpdateReason, finished: Bool) {
        if finished {
            let latitude = cameraPosition.target.latitude
            let longitude = cameraPosition.target.longitude
            pinManager.fetchPinLocation(lan: latitude, lon: longitude)
            
            if cameraUpdateSource == YMKCameraUpdateReason.gestures {
                updateLabel(cameraPosition.target)
            }
        }
    }
}

//MARK: - EXT tap on map object -

extension MapViewController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        if let point = mapObject as? YMKCircleMapObject {
            let curGeometry = point.geometry
            point.geometry = YMKCircle(center: curGeometry.center, radius: 60)

            if let userData = point.userData as? PointMapObjectUserData {
                let message = "Можете посетить это место: \(userData.id) \(userData.description) по адресу \(streetNameLabel.text!)"
                print(message)
                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alert.view.backgroundColor = UIColor.darkGray
                alert.view.alpha = 0.8
                alert.view.layer.cornerRadius = 15

                present(alert, animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    alert.dismiss(animated: true)
                }
                point.geometry = YMKCircle(center: curGeometry.center, radius: 30)
                return true
            }
        }
        return true
    }
}

private class PointMapObjectUserData {
    let id: Int32
    let description: String
    init(id: Int32, description: String) {
        self.id = id
        self.description = description
    }
}
