//
//  HomeViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import UIKit

class HomeViewController: UIViewController {

	// MARK: - Properties
	
	private let topBarView: UIView = {
		let view = UIView()
		return view
	}()
	
	private let profilePhotoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .gray
		imageView.setDimensions(width: 36, height: 36)
		imageView.layer.cornerRadius = 36 / 2
		return imageView
	}()
	
	private let greetingLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
											   textColor: UIColor.dark40, text: "Good morning,")
		return label
	}()
	
	private let nameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 14),
											   textColor: UIColor.dark, text: "Test Name")
		return label
	}()
	
	private lazy var messageButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.asset(.chat)?.withRenderingMode(.alwaysOriginal), for: .normal)
		return button
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(GeneralItemTableViewCell.self, forCellReuseIdentifier: GeneralItemTableViewCell.reuseidentifier)
		tableView.register(GeneralTableViewHeader.self, forHeaderFooterViewReuseIdentifier: GeneralTableViewHeader.reuseIdentifier)
		tableView.separatorStyle = .none
		return tableView
	}()
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		tableView.dataSource = self
		tableView.delegate = self
		
		setupUI()
		setupNavBar()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(topBarView)
		topBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 64)
		
		topBarView.addSubview(profilePhotoImageView)
		profilePhotoImageView.centerY(inView: topBarView, leftAnchor: topBarView.leftAnchor, paddingLeft: 16)
		
		let topBarLabelVStack = UIStackView(arrangedSubviews: [greetingLabel, nameLabel])
		topBarLabelVStack.spacing = 0
		topBarLabelVStack.axis = .vertical
		topBarView.addSubview(topBarLabelVStack)
		topBarLabelVStack.centerY(inView: topBarView, leftAnchor: profilePhotoImageView.rightAnchor, paddingLeft: 12)
		
		topBarView.addSubview(messageButton)
		messageButton.centerY(inView: topBarView)
		messageButton.anchor(right: topBarView.rightAnchor, paddingRight: 24)
		
		view.addSubview(tableView)
		tableView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
	}
	
	// MARK: - Actions
	
	// MARK: - Helpers
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: GeneralItemTableViewCell.reuseidentifier, for: indexPath)
				as? GeneralItemTableViewCell else { return UITableViewCell() }
		return cell
	}

}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 216
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: GeneralTableViewHeader.reuseIdentifier)
				as? GeneralTableViewHeader else { return  UITableViewHeaderFooterView() }
		return header
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		50
	}
}
