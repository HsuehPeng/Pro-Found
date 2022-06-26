//
//  MapViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/20.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
	
	// MARK: - Properties
	
	let location: CLLocation
	
	private lazy var backButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.chevron_left)?.withTintColor(.white)
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(popVC), for: .touchUpInside)
		button.setDimensions(width: 36, height: 36)
		button.layer.cornerRadius = 36 / 2
		button.backgroundColor = .dark.withAlphaComponent(0.2)
		return button
	}()
	
	let locationMapView: MKMapView = {
		let mapView = MKMapView()
		mapView.setDimensions(width: 48, height: 48)
		mapView.layer.cornerRadius = 8
		mapView.backgroundColor = .gray
		
		return mapView
	}()
	
	// MARK: - Lifecycle
	
	init(location: CLLocation) {
		self.location = location
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		pinCourseLocation()
		setupNavBar()
		setupUI()

    }
	
	// MARK: - UI
	
	func setupUI() {
		
		view.addSubview(locationMapView)
		locationMapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
							   right: view.rightAnchor)
		
		view.addSubview(backButton)
		backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 18)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
		tabBarController?.tabBar.isHidden = true
	}
	
	func pinCourseLocation() {
		
		locationMapView.centerCoordinate = location.coordinate
		locationMapView.centerToLocation(location)
		
		let annotation1 = MKPointAnnotation()
		annotation1.coordinate = location.coordinate
		locationMapView.addAnnotation(annotation1)
	}
	
	// MARK: - Actions
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}


}
