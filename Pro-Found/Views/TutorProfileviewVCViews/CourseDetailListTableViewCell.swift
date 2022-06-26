//
//  CourseDetailListTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/20.
//

import UIKit
import FirebaseAuth
import Kingfisher
import MapKit

protocol CourseDetailListTableViewCellDelegate: AnyObject {
	func handleFollowing(_ cell: CourseDetailListTableViewCell)
}

class CourseDetailListTableViewCell: UITableViewCell {
	
	static let reuseIdentifier = "\(CourseDetailListTableViewCell.self)"
	
	weak var delegate: CourseDetailListTableViewCellDelegate?
	
	// MARK: - Properties
		
	var course: Course? {
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
	
	private lazy var tutorImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 48, height: 48)
		imageView.layer.cornerRadius = 48 / 2
		imageView.image = UIImage.asset(.account_circle)
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private let tutorNameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 14), textColor: .dark60, text: "Test Name")
		return label
	}()
	
	lazy var followButton: UIButton = {
		let button = CustomUIElements().makeSmallButton(buttonColor: UIColor.light60, buttonTextColor: UIColor.orange,
														borderColor: .orange, buttonText: "Follow")
		button.setTitleColor(UIColor.dark20, for: .disabled)
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
	
	private let subjectTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14), textColor: .dark60, text: "Subject")
		return label
	}()
	
	private let subjectLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12), textColor: .dark40, text: "Test subject")
		return label
	}()
	
	private let durationTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14), textColor: .dark60, text: "Duration")
		return label
	}()
	
	private let durationLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12), textColor: .dark40, text: "Test hours")
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
		
		let subjectVStack = UIStackView(arrangedSubviews: [subjectTitleLabel, subjectLabel])
		subjectVStack.axis = .vertical
		subjectVStack.spacing = 8
		subjectVStack.alignment = .center

		
		let durationVStack = UIStackView(arrangedSubviews: [durationTitleLabel, durationLabel])
		durationVStack.axis = .vertical
		durationVStack.spacing = 8
		durationVStack.alignment = .center
		
		let HStack = UIStackView(arrangedSubviews: [subjectVStack, durationVStack])
		HStack.axis = .horizontal
		HStack.distribution = .fillEqually
		
		contentView.addSubview(HStack)
		HStack.anchor(top: dividerLine2.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
							 right: contentView.rightAnchor, paddingTop: 24, paddingBottom: 8)
		
	}
	
	// MARK: - Actions
	
	@objc func handleFollowingAction() {
		delegate?.handleFollowing(self)
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		guard let course = course, let isFollow = isFollow, let uid = Auth.auth().currentUser?.uid else { return }
		let tutorImageUrl = URL(string: course.tutor.profileImageURL)
		tutorImageView.kf.setImage(with: tutorImageUrl)
		tutorNameLabel.text = course.tutorName
		addressLabel.text = course.location
		subjectLabel.text = course.subject
		durationLabel.text = "\(course.hours) hour"
		
		if course.userID == uid {
			followButton.isEnabled = false
			followButton.layer.borderColor = UIColor.dark20.cgColor
		}
		
		if isFollow {
			followButton.setTitle("Unfollow", for: .normal)
		} else {
			followButton.setTitle("Follow", for: .normal)
		}
	}

}
