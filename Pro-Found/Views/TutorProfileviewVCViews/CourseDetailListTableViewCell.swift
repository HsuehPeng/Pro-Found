//
//  CourseDetailListTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/20.
//

import UIKit
import FirebaseAuth
import Kingfisher

protocol CourseDetailListTableViewCellDelegate: AnyObject {
	func handleFollowing(_ cell: CourseDetailListTableViewCell)
}

class CourseDetailListTableViewCell: UITableViewCell {
	
	static let reuseIdentifier = "\(CourseDetailListTableViewCell.self)"
	
	weak var delegate: CourseDetailListTableViewCellDelegate?
	
	// MARK: - Properties
		
	var course: Course? {
		didSet {
			configureuI()
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
	
	private let locationImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 48, height: 48)
		imageView.layer.cornerRadius = 48 / 2
		return imageView
	}()
	
	private let addressLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12), textColor: .dark40, text: "Test Address")
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
	
	private let underlineView: UIView = {
		let view = UIView()
		view.backgroundColor = .dark40
		
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
		
		contentView.addSubview(locationImageView)
		locationImageView.anchor(top: dividerLine1.bottomAnchor, left: contentView.leftAnchor, paddingTop: 16, paddingLeft: 16)
		
		contentView.addSubview(addressLabel)
		addressLabel.centerY(inView: locationImageView, leftAnchor: locationImageView.rightAnchor, paddingLeft: 8)
		addressLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 16).isActive = true
		
		contentView.addSubview(dividerLine2)
		dividerLine2.anchor(top: locationImageView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 8, height: 1)
		
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
		HStack.anchor(top: dividerLine2.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 24)
		
		contentView.addSubview(underlineView)
		underlineView.anchor(top: HStack.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
							 right: contentView.rightAnchor, paddingTop: 16, paddingBottom: 8, height: 1)
		
	}
	
	// MARK: - Actions
	
	@objc func handleFollowingAction() {
		delegate?.handleFollowing(self)
	}
	
	// MARK: - Helpers
	
	func configureuI() {
		guard let course = course, let isFollow = isFollow else { return }
		let tutorImageUrl = URL(string: course.tutor.profileImageURL)
		tutorImageView.kf.setImage(with: tutorImageUrl)
		tutorNameLabel.text = course.tutorName
		addressLabel.text = course.location
		subjectLabel.text = course.subject
		durationLabel.text = "\(course.hours) hour"
		if isFollow {
			followButton.setTitle("Unfollow", for: .normal)
		} else {
			followButton.setTitle("Follow", for: .normal)
		}
	}

}
