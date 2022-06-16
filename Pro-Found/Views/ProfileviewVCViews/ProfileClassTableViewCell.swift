//
//  ProfileClassTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/14.
//

import UIKit

class ProfileClassTableViewCell: UITableViewCell {

	static let reuseIdentifier = "\(ProfileClassTableViewCell.self)"
	
	// MARK: - Properties
	
	var course: Course? {
		didSet {
			configure()
		}
	}
	
	private let classView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 16
		view.backgroundColor = .orange
		view.heightAnchor.constraint(equalToConstant: 186).isActive = true
		
		return view
	}()
	
	private let classTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 16),
												 textColor: UIColor.white, text: "Test Title")
		return label
	}()
	
	private let summaryLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 12),
												 textColor: UIColor.white, text: "Test summary")
		return label
	}()
	
	private let locationLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 12),
												 textColor: UIColor.white, text: "Test address")
		label.numberOfLines = 0
		return label
	}()
	
	private let feeLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14),
												 textColor: UIColor.white, text: "$100")
		return label
	}()
	
	private lazy var chooseCourseButton: UIButton = {
		let button = CustomUIElements().makeMediumButton(buttonColor: .white, buttonTextColor: .orange,
														 borderColor: .clear, buttonText: "Choose Course")
		button.widthAnchor.constraint(equalToConstant: 142).isActive = true
		return button
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
		contentView.addSubview(classView)
		classView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
						 right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 20, paddingBottom: 12, paddingRight: 20)
		
		classView.addSubview(classTitleLabel)
		classTitleLabel.anchor(top: classView.topAnchor, left: classView.leftAnchor, paddingTop: 20, paddingLeft: 20)
		
		classView.addSubview(feeLabel)
		feeLabel.anchor(top: classView.topAnchor, right: classView.rightAnchor, paddingTop: 20, paddingRight: 20)
		
		classView.addSubview(summaryLabel)
		summaryLabel.anchor(top: classTitleLabel.bottomAnchor, left: classView.leftAnchor, paddingTop: 9, paddingLeft: 20)

		classView.addSubview(chooseCourseButton)
		chooseCourseButton.anchor(bottom: classView.bottomAnchor, right: classView.rightAnchor, paddingBottom: 20, paddingRight: 20)
		
		classView.addSubview(locationLabel)
		locationLabel.anchor(top: chooseCourseButton.topAnchor, left: classView.leftAnchor, right: chooseCourseButton.leftAnchor, paddingLeft: 20)
	}
	
	// MARK: - Actions
	
	// MARK: - Helpers
	
	func configure() {
		guard let course = course else { return }
		classTitleLabel.text = course.courseTitle
		summaryLabel.text = course.briefIntro
		let courseFeeInt = Int(course.fee)
		feeLabel.text = "$ \(courseFeeInt)"
		locationLabel.text = course.location
	}

}
