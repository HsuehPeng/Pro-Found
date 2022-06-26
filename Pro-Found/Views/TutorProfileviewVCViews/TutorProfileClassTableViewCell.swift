//
//  ProfileClassTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/14.
//

import UIKit
import FirebaseAuth

enum CourseColor {
	
}

protocol ProfileClassTableViewCellDelegate: AnyObject {
	func showBottomSheet(_ cell: TutorProfileClassTableViewCell)
	func goCourseDetail(_ cell: TutorProfileClassTableViewCell)
}

class TutorProfileClassTableViewCell: UITableViewCell {

	static let reuseIdentifier = "\(TutorProfileClassTableViewCell.self)"
	
	weak var delegate: ProfileClassTableViewCellDelegate?
	
	// MARK: - Properties
	
	var course: Course? {
		didSet {
			configureUI()
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
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: UIColor.white, text: "Test summary")
		label.numberOfLines = 0
		return label
	}()
	
	private let locationLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: UIColor.white, text: "Test address")
		label.numberOfLines = 0
		return label
	}()
	
	private let feeLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14),
												 textColor: UIColor.white, text: "$100")
		return label
	}()
	
	private lazy var goToCourseDetailButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = .light60
		button.layer.cornerRadius = 36 / 2
		button.setImage(UIImage.asset(.arrow_right)?.withTintColor(.orange), for: .normal)
		button.setDimensions(width: 36, height: 36)
		button.addTarget(self, action: #selector(goCourseDetail), for: .touchUpInside)
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
		summaryLabel.anchor(top: classTitleLabel.bottomAnchor, left: classView.leftAnchor, right: classView.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingRight: 20)

		classView.addSubview(goToCourseDetailButton)
		goToCourseDetailButton.anchor(bottom: classView.bottomAnchor, right: classView.rightAnchor, paddingBottom: 20, paddingRight: 20)
		
		classView.addSubview(locationLabel)
		locationLabel.anchor(top: goToCourseDetailButton.topAnchor, left: classView.leftAnchor, right: goToCourseDetailButton.leftAnchor, paddingTop: 8, paddingLeft: 20, paddingRight: 16)
	}
	
	// MARK: - Actions
	
	@objc func goCourseDetail() {
		delegate?.goCourseDetail(self)
	}
	
	@objc func showBottomSheet() {
		delegate?.showBottomSheet(self)
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		guard let course = course else { return }
		
		setSubjectButtonColor(subject: course.subject, targetView: classView)
		
		classTitleLabel.text = course.courseTitle
		summaryLabel.text = course.briefIntro
		let courseFeeInt = Int(course.fee)
		feeLabel.text = "$ \(courseFeeInt)"
		locationLabel.text = course.location
	}

}
