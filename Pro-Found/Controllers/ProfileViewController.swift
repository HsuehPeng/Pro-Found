//
//  ProfileViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import UIKit

class ProfileViewController: UIViewController {

	// MARK: - Properties
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(ProfileMainTableViewCell.self, forCellReuseIdentifier: ProfileMainTableViewCell.reuseIdentifier)
		tableView.register(ProfileClassTableViewCell.self, forCellReuseIdentifier: ProfileClassTableViewCell.reuseIdentifier)
		tableView.contentInsetAdjustmentBehavior = .never
		tableView.separatorStyle = .none
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		tableView.dataSource = self
		tableView.delegate = self
		
		setupNavBar()
		setupUI()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(tableView)
		tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
	}
	
	// MARK: - Actions
	
	// MARK: - Helpers

}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		} else {
			return 2
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let mainCell = tableView.dequeueReusableCell(withIdentifier: ProfileMainTableViewCell.reuseIdentifier)
				as? ProfileMainTableViewCell else { return UITableViewCell() }
		guard let classCell = tableView.dequeueReusableCell(withIdentifier: ProfileClassTableViewCell.reuseIdentifier)
				as? ProfileClassTableViewCell else { return UITableViewCell()}
		
		if indexPath.section == 0 {
			return mainCell
		} else {
			return classCell
		}
		
	}
	
}

extension ProfileViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
}
