//
//  ListMenuView.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/6.
//

import UIKit

enum TextFormateType: String {
	case heading1
	case heading2
	case title1
	case title2
	case text
	
	var description: String {
		switch self {
		case .heading1:
			return "Heading 1"
		case .heading2:
			return "Heading 2"
		case .title1:
			return "Title 1"
		case .title2:
			return "Title 2"
		case .text:
			return "Text"
		}
	}
	
	var font: UIFont {
		
		switch self {
		case .heading1:
			return UIFont.systemFont(ofSize: 24, weight: .semibold)
		case .heading2:
			return UIFont.systemFont(ofSize: 20, weight: .semibold)
		case .title1:
			return UIFont.systemFont(ofSize: 20, weight: .medium)
		case .title2:
			return UIFont.systemFont(ofSize: 18, weight: .medium)
		case .text:
			return UIFont.systemFont(ofSize: 16, weight: .regular)
		}
	}
}

enum TextFormateColor {
	case dark
	case ocean
	case orange
	case light
	case red
	case green
	case yellow
	case skyblue
	
	var color: UIColor {
		switch self {
		case .dark:
			return UIColor.dark60
		case .ocean:
			return UIColor.ocean
		case .orange:
			return UIColor.orange
		case .light:
			return UIColor.light
		case .red:
			return UIColor.red
		case .green:
			return UIColor.green
		case .yellow:
			return UIColor.yellow
		case .skyblue:
			return UIColor.skyBlue
		}
	}
}

protocol ListMenuViewDelegate: AnyObject {
	func listMenuView(_ view: ListMenuView, for SelectedTextFormateType: TextFormateType)
	func listMenuView(_ View: ListMenuView, for selectedTextColorType: TextFormateColor)
}

class ListMenuView: UIView {
	
	weak var delegate: ListMenuViewDelegate?

	var textFormateOptions = [TextFormateType]()
	
	var textColorOptions = [TextFormateColor]()
		
	var isUp = false
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(ListMenuViewCellTableViewCell.self,
						   forCellReuseIdentifier: ListMenuViewCellTableViewCell.reuseIdentifier)
		return tableView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.layer.cornerRadius = 10
		self.clipsToBounds = true
		
		tableView.delegate = self
		tableView.dataSource = self
		self.addSubview(tableView)
		tableView.addConstraintsToFillView(self)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

// MARK: - UITableViewDataSource

extension ListMenuView: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if textFormateOptions.isEmpty {
			return textColorOptions.count
		} else {
			return textFormateOptions.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ListMenuViewCellTableViewCell.reuseIdentifier, for: indexPath)
				as? ListMenuViewCellTableViewCell else { fatalError("Can not dequeue ListMenuViewCellTableViewCell") }
		
		if textFormateOptions.isEmpty {
			cell.contentView.backgroundColor = textColorOptions[indexPath.row].color
		} else {
			cell.label.text = textFormateOptions[indexPath.row].description
		}
		
		return cell
	}
}

extension ListMenuView: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		if textFormateOptions.isEmpty {
			let textColorType = textColorOptions[indexPath.row]
			delegate?.listMenuView(self, for: textColorType)
		} else {
			let textFormateType = textFormateOptions[indexPath.row]
			delegate?.listMenuView(self, for: textFormateType)
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 40
	}
}
