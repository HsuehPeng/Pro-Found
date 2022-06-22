//
//  CalendarCollectionViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/16.
//

import UIKit

protocol CalendarCollectionViewCellDelegate: AnyObject {
	func cellSelectedWithFillColor(_ cell: CalendarCollectionViewCell) -> UIColor
}

class CalendarCollectionViewCell: UICollectionViewCell {
    
	static let reuseIdentifier = "\(CalendarCollectionViewCell.self)"
	
	weak var delegate: CalendarCollectionViewCellDelegate?
	
	// MARK: - Properties
	
	let dateLabel = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14),
														 textColor: UIColor.dark, text: "1")
	
	let backGroundView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		return view
	}()
	
	let badgeDot: UIView = {
		let view = UIView()
		view.backgroundColor = .orange
		view.setDimensions(width: 5, height: 5)
		view.layer.cornerRadius = 5 / 2
		view.isHidden = true
		return view
	}()
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		contentView.addSubview(backGroundView)
		backGroundView.center(inView: contentView)
		backGroundView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
		backGroundView.widthAnchor.constraint(equalTo: backGroundView.heightAnchor).isActive = true
		backGroundView.layer.cornerRadius = contentView.frame.size.height * 0.4
		
		backGroundView.addSubview(dateLabel)
		dateLabel.center(inView: backGroundView)
		
		backGroundView.addSubview(badgeDot)
		badgeDot.centerX(inView: backGroundView)
	}
	
	// MARK: - Helpers
	
	func configureUI() {

		
	}
	
}
