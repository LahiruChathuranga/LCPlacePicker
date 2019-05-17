//
//  EMPlacePicker.swift
//  EMPlacePicker
//
//  Created by Lahiru Chathuranga on 5/16/19.
//  Copyright © 2019 ElegantMedia. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

class EMPlacePicker: UIViewController {
    
    let vc = PlacePickerVC()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPlacePicker() {
        vc.delegate = self
        present(vc, animated: true)
    }
}
extension EMPlacePicker: PlacePickerVCDelegate {
    func selectedLocation(location: CLLocationCoordinate2D, address: String) {
        
    }
}
