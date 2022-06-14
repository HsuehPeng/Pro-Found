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

extension ProfileViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileMainTableViewCell.reuseIdentifier, for: indexPath)
				as? ProfileMainTableViewCell else { return UITableViewCell() }
		return cell
	}
	
}
