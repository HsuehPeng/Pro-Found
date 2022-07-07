//
//  NotificationTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/6.
//

import UIKit
import Kingfisher

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

protocol NotificationTableViewCellDelegate: AnyObject {
	func handleCourseApplication(_ cell: NotificationTableViewCell, result: String)
	func handleProfileImageTapped(_ cell: NotificationTableViewCell)
}

class NotificationTableViewCell: UITableViewCell {
	
	static let reuserIdentifier = "\(NotificationTableViewCell.self)"
	
	var delegate: NotificationTableViewCellDelegate?

	// MARK: - Properties
	
	var user: User? {
		didSet {
			configureUI()
		}
	}
		
	var scheduleCourse: ScheduledCourseTime?
	
	private lazy var profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 48, height: 48)
		imageView.layer.cornerRadius = 48 / 2
		imageView.backgroundColor = .orange10
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
		imageView.addGestureRecognizer(tap)
		imageView.isUserInteractionEnabled = true
		
		return imageView
	}()
	
	private let nameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 16), textColor: .dark, text: "Name")
		return label
	}()
	
	private let applicationTimeLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 10), textColor: .dark40, text: "Time")
		return label
	}()
	
	private let courseTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14), textColor: .dark40, text: "Course")
		return label
	}()
	
	private let scheduleTimeLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 10), textColor: .dark40, text: "Time")
		return label
	}()
	
	lazy var acceptButton: UIButton = {
		let button = CustomUIElements().makeMediumButton(buttonColor: .orange, buttonTextColor: .white,
														 borderColor: .clear, buttonText: CourseApplicationState.accept.buttonText)
		button.widthAnchor.constraint(equalToConstant: 120).isActive = true
		button.addTarget(self, action: #selector(handleApplicationResult), for: .touchUpInside)
		return button
	}()
	
	lazy var rejectButton: UIButton = {
		let button = CustomUIElements().makeMediumButton(buttonColor: .dark10, buttonTextColor: .dark,
														 borderColor: .clear, buttonText: CourseApplicationState.reject.buttonText)
		button.widthAnchor.constraint(equalToConstant: 120).isActive = true
		button.addTarget(self, action: #selector(handleApplicationResult), for: .touchUpInside)
		return button
	}()
	
	lazy var statusButton: UIButton = {
		let button = CustomUIElements().makeMediumButton(buttonColor: .dark10, buttonTextColor: .dark,
														 borderColor: .clear, buttonText: CourseApplicationState.pending.buttonText)
		button.isHidden = true
		button.widthAnchor.constraint(equalToConstant: 120).isActive = true
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
		contentView.addSubview(applicationTimeLabel)
		contentView.addSubview(courseTitleLabel)
		contentView.addSubview(scheduleTimeLabel)
		
		profileImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 14, paddingLeft: 20)
		
		nameLabel.anchor(top: contentView.topAnchor, left: profileImageView.rightAnchor, paddingTop: 14, paddingLeft: 14)
		
		applicationTimeLabel.anchor(top: contentView.topAnchor, left: nameLabel.rightAnchor, right: contentView.rightAnchor,
						 paddingTop: 14, paddingLeft: 16, paddingRight: 16)
		
		courseTitleLabel.anchor(top: nameLabel.bottomAnchor, left: profileImageView.rightAnchor,
								paddingTop: 8, paddingLeft: 14)
		
		scheduleTimeLabel.centerY(inView: courseTitleLabel)
		scheduleTimeLabel.anchor(right: contentView.rightAnchor, paddingRight: 16)
		
		let buttonHStack = UIStackView(arrangedSubviews: [acceptButton, rejectButton, statusButton, fillView1])
		buttonHStack.spacing = 12
		contentView.addSubview(buttonHStack)
		buttonHStack.anchor(top: courseTitleLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: contentView.bottomAnchor,
							right: contentView.rightAnchor, paddingTop: 14, paddingLeft: 14, paddingBottom: 14, paddingRight: 14)
	}
	
	// MARK: - Actions
	
	@objc func handleProfileImageTapped() {
		delegate?.handleProfileImageTapped(self)
	}
	
	@objc func handleApplicationResult(_ sender: UIButton) {
		guard let user = user, let _ = scheduleCourse else { return }
		if sender == acceptButton {
			delegate?.handleCourseApplication(self, result: CourseApplicationState.accept.status)
		} else {
			delegate?.handleCourseApplication(self, result: CourseApplicationState.reject.status)
		}
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		guard let scheduledCourse = scheduleCourse, let user = user,
			  let profileImageURl = URL(string: scheduledCourse.student.profileImageURL) else { return }
		
		if scheduledCourse.student.userID == user.userID {
			toggleButtons()
			statusButton.setTitle(scheduledCourse.status, for: .normal)
			print(scheduledCourse.status)
		} else {
			if scheduledCourse.status != CourseApplicationState.pending.status {
				toggleButtons()
				statusButton.setTitle(scheduledCourse.status, for: .normal)
			}
		}
		
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.day, .hour]
		formatter.unitsStyle = .short
		let currentDate = Date().timeIntervalSince1970
		let interval = currentDate - scheduledCourse.applicationTime
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM dd, yyyy ∙ h:mm a"
		let scheduleDate = Date(timeIntervalSince1970: scheduledCourse.time)
		let scheduleDateString = dateFormatter.string(from: scheduleDate)

		profileImageView.kf.setImage(with: profileImageURl)
		nameLabel.text = scheduledCourse.student.name
		courseTitleLabel.text = scheduledCourse.course.courseTitle
		if let formattedString = formatter.string(from: interval) {
			applicationTimeLabel.text = "\(formattedString) ago"
		}
		scheduleTimeLabel.text = scheduleDateString
		
	}
	
	func toggleButtons() {
		acceptButton.isHidden = true
		rejectButton.isHidden = true
		statusButton.isHidden = false
	}
	
}
