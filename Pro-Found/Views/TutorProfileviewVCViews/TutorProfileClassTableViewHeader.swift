//
//  ProfileClassTableViewHeader.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import UIKit
import FirebaseAuth

protocol ProfileClassTableViewHeaderDelegate: AnyObject {
	func createCourse(_ header: TutorProfileClassTableViewHeader)
}

class TutorProfileClassTableViewHeader: UITableViewHeaderFooterView {
	
	static let reuseIdentifier = "\(TutorProfileClassTableViewHeader.self)"
	
	// MARK: - Properties
	
	var tutor: User? {
		didSet {
			configure()
		}
	}
	
	weak var delegate: ProfileClassTableViewHeaderDelegate?
	
	private let titleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 16), textColor: UIColor.dark60, text: "Courses")
		return label
	}()
	
	private lazy var createCourseButton: UIButton = {
		let button = UIButton()
		button.setTitle("Create Course", for: .normal)
		button.titleLabel?.font = UIFont.customFont(.interBold, size: 14)
		button.setTitleColor(UIColor.orange, for: .normal)
		button.isHidden = true
		button.addTarget(self, action: #selector(createCourse), for: .touchUpInside)
		return button
	}()
	
	// MARK: - Lifecycle
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		contentView.addSubview(titleLabel)
		titleLabel.centerY(inView: contentView, leftAnchor: contentView.leftAnchor, paddingLeft: 16)
		
		contentView.addSubview(createCourseButton)
		createCourseButton.centerY(inView: contentView)
		createCourseButton.anchor(right: contentView.rightAnchor, paddingRight: 16)
	}
	
	// MARK: - Actions
	
	@objc func createCourse() {
		delegate?.createCourse(self)
	}
	
	// MARK: - Helpers
	
	func configure() {
		guard let uid = Auth.auth().currentUser?.uid, let tutor = tutor else { return }
		if tutor.userID == uid && tutor.isTutor {
			createCourseButton.isHidden = false
		}
	}

}
