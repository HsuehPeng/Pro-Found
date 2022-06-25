//
//  GeneralMapCellTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/20.
//

import UIKit
import MapKit
import CoreLocation

class GeneralMapCellTableViewCell: UITableViewCell {

	static let reuseIdentifier = "\(GeneralMapCellTableViewCell.self)"
	
	// MARK: - Properties
	
	var event: Event? {
		didSet {
			guard let event = event else { return }
			addressLabel.text = event.location
		}
	}
	
	var location: CLLocation?
	
	var eventLocation: CLLocation? {
		didSet {
			guard let eventLocation = eventLocation else { return }
			locationMapView.centerCoordinate = eventLocation.coordinate
			locationMapView.centerToLocation(eventLocation)
		}
	}
	
	let locationMapView: MKMapView = {
		let mapView = MKMapView()
		mapView.setDimensions(width: 48, height: 48)
		mapView.layer.cornerRadius = 8
		mapView.backgroundColor = .gray
		
		return mapView
	}()
	
	private let addressLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12), textColor: .dark40, text: "Test Address")
		label.numberOfLines = 0
		return label
	}()
	
	// MARK: - Lifecycle
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		contentView.addSubview(locationMapView)
		locationMapView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
							   paddingTop: 8, paddingLeft: 16, paddingBottom: 8)
		
		contentView.addSubview(addressLabel)
		addressLabel.centerY(inView: locationMapView, leftAnchor: locationMapView.rightAnchor, paddingLeft: 8)
	}
	
	// MARK: - Actions
	
	// MARK: - Helpers

}
