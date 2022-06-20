//
//  CourseDetailIntroTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/20.
//

import UIKit

class CourseDetailIntroTableViewCell: UITableViewCell {
	
	static let reuseIdentifier = "\(CourseDetailIntroTableViewCell.self)"

	// MARK: - Properties
		
	var course: Course? {
		didSet {
			configureUI()
		}
	}
	
	private let introTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14), textColor: .dark60, text: "Introduction")
		return label
	}()

	private let introContentLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14), textColor: .dark40, text: "Intro")
		return label
	}()
	
	private let detailTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14), textColor: .dark60, text: "Detail")
		return label
	}()

	private let detailContentLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14), textColor: .dark40, text: "Detail")
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
		contentView.addSubview(introTitleLabel)
		introTitleLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingLeft: 16)
		
		contentView.addSubview(introContentLabel)
		introContentLabel.anchor(top: introTitleLabel.bottomAnchor, left: contentView.leftAnchor,
								 right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 16)
		
		contentView.addSubview(detailTitleLabel)
		detailTitleLabel.anchor(top: introContentLabel.bottomAnchor, left: contentView.leftAnchor,
								right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16)
		
		contentView.addSubview(detailContentLabel)
		detailContentLabel.anchor(top: detailTitleLabel.bottomAnchor, left: contentView.leftAnchor,
								 right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 16)
		
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		guard let course = course else { return }
		introContentLabel.text = course.briefIntro
		detailContentLabel.text = course.detailIntro
	}

}
