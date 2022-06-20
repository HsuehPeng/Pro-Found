//
//  EventDetailListTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/20.
//

import UIKit
import FirebaseAuth
import Kingfisher
import MapKit

protocol EventDetailListTableViewCellDelegate: AnyObject {
	func handleFollowing(_ cell: EventDetailListTableViewCell)
}

class EventDetailListTableViewCell: UITableViewCell {
	
	static let reuseIdentifier = "\(EventDetailListTableViewCell.self)"
	
	weak var delegate: CourseDetailListTableViewCellDelegate?
		
	// MARK: - Properties
		
	var event: Event? {
		didSet {
			configureUI()
		}
	}
	
	var courseLocation: CLLocation? {
		didSet {
			guard let courseLocation = courseLocation else { return }
			locationMapView.centerCoordinate = courseLocation.coordinate
			locationMapView.centerToLocation(courseLocation)
		}
	}
	
	var isFollow: Bool?
	
	private let tutorImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 48, height: 48)
		imageView.layer.cornerRadius = 48 / 2
		imageView.image = UIImage.asset(.account_circle)
		return imageView
	}()
	
	private let tutorNameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 14), textColor: .dark60, text: "Test Name")
		return label
	}()
	
	lazy var followButton: UIButton = {
		let button = CustomUIElements().makeSmallButton(buttonColor: .white, buttonTextColor: .orange, borderColor: .orange, buttonText: " Follow", borderWidth: 1)
		button.widthAnchor.constraint(equalToConstant: 76).isActive = true
		button.addTarget(self, action: #selector(handleFollowingAction), for: .touchUpInside)
		return button
	}()
	
	private let dividerLine1: UIView = {
		let view = UIView()
		view.backgroundColor = .dark10
		return view
	}()
	
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
	
	private let dividerLine2: UIView = {
		let view = UIView()
		view.backgroundColor = .dark10
		return view
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
		contentView.addSubview(tutorImageView)
		tutorImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 16, paddingLeft: 16)
		
		contentView.addSubview(tutorNameLabel)
		tutorNameLabel.centerY(inView: tutorImageView, leftAnchor: tutorImageView.rightAnchor, paddingLeft: 8)
		
		contentView.addSubview(followButton)
		followButton.centerY(inView: tutorImageView)
		followButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true

		contentView.addSubview(dividerLine1)
		dividerLine1.anchor(top: tutorImageView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 8, height: 1)
		
		contentView.addSubview(locationMapView)
		locationMapView.anchor(top: dividerLine1.bottomAnchor, left: contentView.leftAnchor, paddingTop: 16, paddingLeft: 16)
		
		contentView.addSubview(addressLabel)
		addressLabel.centerY(inView: locationMapView, leftAnchor: locationMapView.rightAnchor, paddingLeft: 8)
		addressLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
		
		contentView.addSubview(dividerLine2)
		dividerLine2.anchor(top: locationMapView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 8, height: 1)
	}
	
	// MARK: - Actions
	
	@objc func handleFollowingAction() {
//		delegate?.handleFollowing(self)
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		
	}

}
