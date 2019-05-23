//
//  PickerView.swift
//  EMPlacePicker
//
//  Created by Lahiru Chathuranga on 5/11/19.
//  Copyright © 2019 ElegantMedia. All rights reserved.
//
import UIKit
import GoogleMaps
import GooglePlaces
import SnapKit
import FloatingPanel

@objc
public protocol PlacePickerVCDelegate {
    func selectedLocation(location: CLLocationCoordinate2D, address: String)
}

public class MyFloatingPanelLayout: FloatingPanelLayout {
    public var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 16.0 // A top inset from safe area
        case .half: return 216.0 // A bottom inset from the safe area
        case .tip: return 100.0 // A bottom inset from the safe area
        default: return nil // Or `case .hidden: return nil`
        }
    }
}


open class PlacePickerVC: UIViewController, FloatingPanelControllerDelegate {
    
    fileprivate let customMap: GMSMapView = {
        let map = GMSMapView()
        return map
    }()
    
    fileprivate let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    fileprivate let contentVC = UIViewController()
    fileprivate var fpc: FloatingPanelController!
    fileprivate var searchButton: UIBarButtonItem?
    fileprivate var cancelButton: UIBarButtonItem?
    fileprivate var marker: GMSMarker = GMSMarker()
    fileprivate var location: CLLocationCoordinate2D?
    fileprivate var address: String?
    public var delegate: PlacePickerVCDelegate?
    
    var places: [GMSAddress] = []
    lazy var userLocation: CLLocation = LocationManager.shared.userLocation ?? CLLocation(latitude: 0.0, longitude: 0.0)
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupMap()
        addSubViews()
        setupConnstraints()
        setupFloatingView()
        getPlacesAccordingToUserLocation()
    }
    
    fileprivate func getPlacesAccordingToUserLocation() {
        getLocationUsingCoordinate(lat: userLocation.coordinate.latitude , lon: userLocation.coordinate.longitude ) {
            self.tableView.reloadData()
        }
    }
    fileprivate override func viewWillAppear(_ animated: Bool) {
        fpc.addPanel(toParent: self)
    }
    
    fileprivate override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fpc.removePanelFromParent(animated: true)
    }
    
    
    fileprivate func setupUI() {
        searchButton = UIBarButtonItem(image: UIImage(named: "ic_search_search_bar"), style: .done, target: self, action: #selector(self.navToAddressPicker))
        cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.dismissView))
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        self.title = "Select a Location"
        self.navigationItem.rightBarButtonItem = searchButton
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.hidesBackButton = true
        self.tableView.backgroundColor = UIColor.clear
        
    }
    
    fileprivate func setupFloatingView() {
        fpc = FloatingPanelController()
        fpc.delegate = self
        
        //set content vc
        fpc.set(contentViewController: contentVC)
        
        //set track
        fpc.track(scrollView: tableView)
        
        
        //add bottom view to parent view
        fpc.addPanel(toParent: self)
    }
    
    fileprivate func setupMap() {
        
        let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude , longitude: userLocation.coordinate.longitude ), zoom: 17)
        customMap.camera = camera
        customMap.animate(to: camera)
        customMap.isMyLocationEnabled = true
        customMap.isBuildingsEnabled = true
        customMap.delegate = self
        
        //set table view delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        //regitering tableview cell
        tableView.register(PickerTVCell.self, forCellReuseIdentifier: "pickerCell")
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        
    }
    
    fileprivate func animateMap(location: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withTarget: location, zoom: 17)
        customMap.camera = camera
        customMap.animate(to: camera)
    }
    
    fileprivate func addSubViews() {
        view.addSubview(customMap)
        contentVC.view.addSubview(tableView)
    }
    
    fileprivate func setupConnstraints() {
        customMap.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.contentVC.view)
        }
        
    }
    
    @objc fileprivate func navToAddressPicker() {
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true)
    }
    
    @objc fileprivate func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addMarker(lat: CLLocationDegrees, lon: CLLocationDegrees ) {
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        marker.title = ""
        marker.map = customMap
    }
    
    fileprivate func getLocationUsingCoordinate(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping ()->()) {
        let geoCorder = GMSGeocoder()
        geoCorder.reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: lat, longitude: lon)) { (response, error) in
            if error != nil {
                print("Error has Occured....")
            } else {
                if let places = response?.results() {
                    self.places.removeAll()
                    self.places.append(places[0])
                    completion()
                }
            }
        }
    }
    
    //layout floating panel
    fileprivate func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return MyFloatingPanelLayout()
    }
}
extension PlacePickerVC: GMSMapViewDelegate {
    public func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        customMap.clear()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let lat = coordinate.latitude
            let lon = coordinate.longitude
            self.addMarker(lat: lat , lon: lon)
            self.location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            self.getLocationUsingCoordinate(lat: lat, lon: lon, completion: {
                self.tableView.reloadData()
                self.animateMap(location: self.location!)
            })
        }
        
    }
}
extension PlacePickerVC: GMSAutocompleteViewControllerDelegate {
    public func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if let address = place.formattedAddress {
            self.address = address
        }
        let latitude = place.coordinate.latitude
        let longitude = place.coordinate.longitude
        
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        self.customMap.clear()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.addMarker(lat: latitude, lon: longitude)
            self.getLocationUsingCoordinate(lat: latitude, lon: longitude) {
                self.tableView.reloadData()
                self.animateMap(location: self.location!)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error:", error.localizedDescription)
    }
    
    public func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension PlacePickerVC: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath) as? PickerTVCell {
            cell.InitialSetup()
            cell.placeNameLabel.text = places[indexPath.row].lines![0]
            return cell
        }
        return UITableViewCell()
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.location = CLLocationCoordinate2D(latitude: places[indexPath.row].coordinate.latitude, longitude: places[indexPath.row].coordinate.longitude)
        self.address = places[indexPath.row].lines![0]
        
        self.delegate?.selectedLocation(location: location!, address: address!)
        self.dismissView()
    }
}



