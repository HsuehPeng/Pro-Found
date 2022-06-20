//
//  MKMapView + Extension.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/20.
//

import Foundation
import MapKit
import CoreLocation

extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 5000) {
	let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius,
											  longitudinalMeters: regionRadius)
	setRegion(coordinateRegion, animated: true)
  }
}
