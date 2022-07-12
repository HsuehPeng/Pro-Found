//
//  ScheduleActivityListCollectionViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/16.
//

import UIKit
import Kingfisher

class ScheduleCourseListTableCell: UITableViewCell {
    
	static let reuseIdentifier = "\(ScheduleCourseListTableCell.self)"
	
	// MARK: - Properties
	
	var course: Course? {
		didSet {
			configureUI()
		}
	}
	
	var scheduledCourseWithTimeAndStudent: ScheduledCourseTime?
	
	private let classView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 16
		view.backgroundColor = .orange
		view.heightAnchor.constraint(equalToConstant: 186).isActive = true
		
		return view
	}()
	
	private let classTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 16),
												 textColor: UIColor.light60, text: "Test Title")
		return label
	}()
	
	private let timeLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: UIColor.light60, text: "Test summary")
		label.numberOfLines = 0
		return label
	}()
	
	private let instructorImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 36, height: 36)
		imageView.backgroundColor = .light50
		imageView.layer.cornerRadius = 36 / 2
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private let crossImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage.asset(.cross)?.withTintColor(.orange40)
		imageView.clipsToBounds = true
		imageView.backgroundColor = .clear
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private let studentImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 36, height: 36)
		imageView.backgroundColor = .light50
		imageView.layer.cornerRadius = 36 / 2
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private let locationLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: UIColor.light60, text: "Test address")
		label.numberOfLines = 2
		return label
	}()
	
	private let feeLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14),
												 textColor: UIColor.light60, text: "$100")
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
		contentView.addSubview(classView)
		classView.addSubview(classTitleLabel)
		classView.addSubview(feeLabel)
		classView.addSubview(timeLabel)
		classView.addSubview(locationLabel)
		
		classView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
						 right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 20, paddingBottom: 12, paddingRight: 20)
		
		classTitleLabel.anchor(top: classView.topAnchor, left: classView.leftAnchor, right: feeLabel.leftAnchor,
							   paddingTop: 20, paddingLeft: 20, paddingRight: 16)
		
		feeLabel.anchor(top: classView.topAnchor, right: classView.rightAnchor, paddingTop: 20, paddingRight: 20)
		
		timeLabel.anchor(top: classTitleLabel.bottomAnchor, left: classView.leftAnchor, right: classView.rightAnchor, paddingTop: 9, paddingLeft: 20, paddingRight: 20)
		
		let profileImageHStack = UIStackView(arrangedSubviews: [instructorImageView, crossImageView, studentImageView])
		profileImageHStack.axis = .horizontal
		profileImageHStack.spacing = 20
		profileImageHStack.distribution = .fillEqually
		classView.addSubview(profileImageHStack)
		profileImageHStack.centerX(inView: classView, topAnchor: timeLabel.bottomAnchor, paddingTop: 16)
		
		locationLabel.anchor(left: classView.leftAnchor, bottom: classView.bottomAnchor, right: classView.rightAnchor,
							paddingLeft: 20, paddingBottom: 20, paddingRight: 8)
	}
	
	// MARK: - Actions

	
	// MARK: - Helpers
	
	func configureUI() {
		guard let course = course, let scheduledCourseWithTimeAndStudent = scheduledCourseWithTimeAndStudent else { return }
		
		let dateFormatter = DateFormatter()
		let date = Date(timeIntervalSince1970: scheduledCourseWithTimeAndStudent.time)
		dateFormatter.dateFormat = "h:mm a"
		let dateString = dateFormatter.string(from: date)
		guard let tutorImageUrl = URL(string: course.tutor.profileImageURL),
			  let studentImageUrl = URL(string: scheduledCourseWithTimeAndStudent.student.profileImageURL) else { return }
		
		classTitleLabel.text = course.courseTitle
		timeLabel.text = "\(dateString) ∙ \(course.hours) hours"
		let courseFeeInt = Int(course.fee)
		feeLabel.text = "$ \(courseFeeInt)"
		instructorImageView.kf.setImage(with: tutorImageUrl)
		studentImageView.kf.setImage(with: studentImageUrl)
		locationLabel.text = course.location
		
		setSubjectButtonColor(subject: course.subject, targetView: classView)
		
	}
	
}
