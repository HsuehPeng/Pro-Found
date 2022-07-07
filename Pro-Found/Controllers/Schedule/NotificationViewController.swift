//
//  NotificationViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/6.
//

import UIKit

class NotificationViewController: UIViewController {
	
	// MARK: - Properties
	
	let user: User
	
	let courses: [Course]
	
	let scheduleCourses: [ScheduledCourseTime]
	
	private let topBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .light60
		return view
	}()
	
	private lazy var backButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal).withTintColor(.dark40)
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(popVC), for: .touchUpInside)
		return button
	}()
	
	private let titleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 16), textColor: .dark, text: "Notification")
		return label
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.allowsSelection = false
		tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.reuserIdentifier)
		return tableView
	}()
	
	// MARK: - Lifecycle
	
	init(user: User, courses: [Course], scheduleCourses: [ScheduledCourseTime]) {
		self.user = user
		self.courses = courses
		self.scheduleCourses = scheduleCourses
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .light60
		tabBarController?.tabBar.isHidden = true
		
		tableView.delegate = self
		tableView.dataSource = self
		
		setupUI()
		
		courses.forEach { course in
			print(course.courseID)
		}
		
		scheduleCourses.forEach { courseTime in
			print(courseTime.courseID)
		}
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		tabBarController?.tabBar.isHidden = false
	}
	
	// MARK: - UI
	
	private func setupUI() {
		view.addSubview(topBarView)
		topBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 48)
		
		topBarView.addSubview(backButton)
		backButton.anchor(left: topBarView.leftAnchor, paddingLeft: 18)
		backButton.centerY(inView: topBarView)
		
		topBarView.addSubview(titleLabel)
		titleLabel.center(inView: topBarView)
		
		view.addSubview(tableView)
		tableView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
	}
	
	// MARK: - Actions
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Helpers
	
}

// MARK: - UITableViewDataSource

extension NotificationViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return scheduleCourses.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.reuserIdentifier, for: indexPath)
				as? NotificationTableViewCell else { fatalError("Can not dequeue NotificationTableViewCell")}
		return cell
	}
}

// MARK: - UITableViewDataSource

extension NotificationViewController: UITableViewDelegate {
	
}
