//
//  CourseDetailTableViewHeader.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/20.
//

import UIKit

class CourseDetailTableViewHeader: UITableViewHeaderFooterView {

	static let reuseIdentifier = "\(TutorProfileClassTableViewHeader.self)"
	
	// MARK: - Properties
	
	var course: Course? {
		didSet {
			configureUI()
		}
	}
	
	private let titleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 16),
												 textColor: UIColor.dark60, text: "Header Title")
		return label
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
		titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
		titleLabel.anchor(left: contentView.leftAnchor, right: contentView.rightAnchor, paddingLeft: 16, paddingRight: 16)
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		guard let course = course else { return }
		titleLabel.text = course.courseTitle
	}
}
