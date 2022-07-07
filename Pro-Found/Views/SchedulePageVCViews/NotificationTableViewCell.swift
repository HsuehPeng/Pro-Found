//
//  NotificationTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/6.
//

import UIKit

enum CourseApplicationState {
	case accept
	case reject
	case pending
	
	var status: String {
		switch self {
		case .accept:
			return "Accepted"
		case .reject:
			return "Rejected"
		case .pending:
			return "Pending"
		}
	}
	
	var buttonText: String {
		switch self {
		case .accept:
			return "Accept"
		case .reject:
			return "Reject"
		case .pending:
			return "Pending"
		}
	}
}

class NotificationTableViewCell: UITableViewCell {
	
	static let reuserIdentifier = "\(NotificationTableViewCell.self)"

	// MARK: - Properties
	
	var user: User? {
		didSet {
			configureUI()
		}
	}
	
	var course: Course?
	
	var scheduleCourse: ScheduledCourseTime?
	
	private let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 48, height: 48)
		imageView.layer.cornerRadius = 48 / 2
		imageView.backgroundColor = .orange10
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()
	
	private let nameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 16), textColor: .dark, text: "Name")
		return label
	}()
	
	private let timeLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12), textColor: .dark40, text: "Time")
		return label
	}()
	
	private let courseTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14), textColor: .dark40, text: "Course")
		return label
	}()
	
	private lazy var acceptButton: UIButton = {
		let button = CustomUIElements().makeMediumButton(buttonColor: .orange, buttonTextColor: .white,
														 borderColor: .clear, buttonText: CourseApplicationState.accept.buttonText)
		button.widthAnchor.constraint(equalToConstant: 120).isActive = true
		button.addTarget(self, action: #selector(handleApplicationResult), for: .touchUpInside)
		return button
	}()
	
	private lazy var rejectButton: UIButton = {
		let button = CustomUIElements().makeMediumButton(buttonColor: .dark10, buttonTextColor: .dark,
														 borderColor: .clear, buttonText: CourseApplicationState.reject.buttonText)
		button.widthAnchor.constraint(equalToConstant: 120).isActive = true
		button.addTarget(self, action: #selector(handleApplicationResult), for: .touchUpInside)
		return button
	}()
	
	private let fillView1 = UIView()
	
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
		contentView.addSubview(profileImageView)
		contentView.addSubview(nameLabel)
		contentView.addSubview(timeLabel)
		contentView.addSubview(courseTitleLabel)
		
		profileImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 14, paddingLeft: 20)
		
		nameLabel.anchor(top: contentView.topAnchor, left: profileImageView.rightAnchor, paddingTop: 14, paddingLeft: 14)
		
		timeLabel.anchor(top: contentView.topAnchor, left: nameLabel.rightAnchor, right: contentView.rightAnchor,
						 paddingTop: 14, paddingLeft: 16, paddingRight: 16)
		
		courseTitleLabel.anchor(top: nameLabel.bottomAnchor, left: profileImageView.rightAnchor, right: contentView.rightAnchor,
								paddingTop: 8, paddingLeft: 14, paddingRight: 16)
		
		let buttonHStack = UIStackView(arrangedSubviews: [acceptButton, rejectButton, fillView1])
		buttonHStack.spacing = 12
		contentView.addSubview(buttonHStack)
		buttonHStack.anchor(top: courseTitleLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: contentView.bottomAnchor,
							right: contentView.rightAnchor, paddingTop: 14, paddingLeft: 14, paddingBottom: 14, paddingRight: 14)
	}
	
	// MARK: - Actions
	
	@objc func handleApplicationResult(_ sender: UIButton) {
		guard let user = user, let course = course, let scheduledCouse = scheduleCourse else { return }
		if sender == acceptButton {
			UserServie.shared.updateScheduledCourseStatus(user: user, tutor: course.tutor, applicationID: scheduledCouse.applicationID,
														  result: CourseApplicationState.accept.status) {
				
			}
		} else {
			UserServie.shared.updateScheduledCourseStatus(user: user, tutor: course.tutor, applicationID: scheduledCouse.applicationID,
														  result: CourseApplicationState.accept.status) {
				
			}
		}
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		
	}

}
