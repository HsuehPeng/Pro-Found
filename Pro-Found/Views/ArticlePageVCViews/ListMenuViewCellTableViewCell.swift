//
//  ListMenuViewCellTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/6.
//

import UIKit

class ListMenuViewCellTableViewCell: UITableViewCell {
	
	static let reuseIdentifier = "\(ListMenuViewCellTableViewCell.self)"
	
	// MARK: - Properties
	
	let label: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 16),
												 textColor: .dark60, text: "")
		return label
	}()
	
	// MARK: - Lifecycle
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
		contentView.backgroundColor = .orange10
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		contentView.addSubview(label)
		label.center(inView: contentView)
	}


}
