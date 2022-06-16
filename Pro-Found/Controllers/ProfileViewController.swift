//
//  ProfileViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

	// MARK: - Properties
	
	var isTutor = false
	
	var user: User?
	
	var userCourses = [Course]() {
		didSet {
			tableView.reloadData()
		}
	}
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(ProfileMainTableViewCell.self, forCellReuseIdentifier: ProfileMainTableViewCell.reuseIdentifier)
		tableView.register(ProfileClassTableViewCell.self, forCellReuseIdentifier: ProfileClassTableViewCell.reuseIdentifier)
		tableView.register(ProfileClassTableViewHeader.self, forHeaderFooterViewReuseIdentifier: ProfileClassTableViewHeader.reuseIdentifier)
		tableView.contentInsetAdjustmentBehavior = .never
		tableView.separatorStyle = .none
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.sectionHeaderTopPadding = 0
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		fetchUserData()
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
	
	func fetchUserData() {
		guard let user = user else { return }
		print(user.name)
		
		UserServie.shared.getUserData(uid: user.userID) { [weak self] result in
			guard let self = self else { return }
			
			switch result {
			case.success(let user):
				self.user = user
				CourseServie.shared.fetchUserCourses(userID: user.userID) { [weak self] result in
					guard let self = self else { return }
					switch result {
					case.success(let courses):
						self.userCourses = courses
					case.failure(let error):
						print(error)
					}
				}
			case.failure(let error):
				print(error)
			}
		}
	}

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
			return userCourses.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let mainCell = tableView.dequeueReusableCell(withIdentifier: ProfileMainTableViewCell.reuseIdentifier)
				as? ProfileMainTableViewCell else { return UITableViewCell() }
		guard let courseCell = tableView.dequeueReusableCell(withIdentifier: ProfileClassTableViewCell.reuseIdentifier)
				as? ProfileClassTableViewCell else { return UITableViewCell()}
		
		if indexPath.section == 0 {
			return mainCell
		} else {
			courseCell.course = userCourses[indexPath.row]
			return courseCell
		}
	}
	
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileClassTableViewHeader.reuseIdentifier)
				as? ProfileClassTableViewHeader else { return UITableViewHeaderFooterView() }
		
		if section == 1 {
			header.delegate = self
			return header
		}
		
		return nil
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 1 {
			return 50
		}
		
		return 0
	}
	
}

extension ProfileViewController: ProfileClassTableViewHeaderDelegate {
	
	func createCourse(_ header: ProfileClassTableViewHeader) {
		guard let user = user else { return }
		let createCourseVC = CreateCourseViewController(user: user)
		navigationController?.pushViewController(createCourseVC, animated: true)
	}
	
}
