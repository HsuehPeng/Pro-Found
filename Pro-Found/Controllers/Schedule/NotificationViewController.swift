//
//  NotificationViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/6.
//

import UIKit
import Lottie

class NotificationViewController: UIViewController {
	
	// MARK: - Properties
	
	let user: User
			
	var sortedScheduleCourses = [ScheduledCourseTime]() {
		didSet {
			tableView.reloadData()
		}
	}
	
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
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 16), textColor: .dark, text: "Course Applications")
		return label
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.allowsSelection = false
		tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.reuserIdentifier)
		return tableView
	}()
	
	// MARK: - Lifecycle
	
	init(user: User) {
		self.user = user
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
		fetchScheduleCourses()
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
	
	func fetchScheduleCourses() {
		UserServie.shared.getScheduledCourseIDs(userID: user.userID) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let scheduledCoursesIdWithTimes):
				let sorted = scheduledCoursesIdWithTimes.sorted(by: { $0.applicationTime > $1.applicationTime })
				self.sortedScheduleCourses = sorted
			case .failure(let error):
				print(error)
			}
		}
	}
	
}

// MARK: - UITableViewDataSource

extension NotificationViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sortedScheduleCourses.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.reuserIdentifier, for: indexPath)
				as? NotificationTableViewCell else { fatalError("Can not dequeue NotificationTableViewCell")}
		
		let scheduleCourse = sortedScheduleCourses[indexPath.row]
		cell.delegate = self
		cell.scheduleCourse = scheduleCourse
		cell.user = user
		return cell
	}
}

// MARK: - UITableViewDataSource

extension NotificationViewController: UITableViewDelegate {
	
}

// MARK: - NotificationTableViewCellDelegate

extension NotificationViewController: NotificationTableViewCellDelegate {
	func handleProfileImageTapped(_ cell: NotificationTableViewCell) {
		guard let scheduleCourse = cell.scheduleCourse else { return }
		let publicProfileVC = TutorProfileViewController(user: user, tutor: scheduleCourse.student)
		navigationController?.pushViewController(publicProfileVC, animated: true)
	}
	
	func handleCourseApplication(_ cell: NotificationTableViewCell, result: String) {
		
		guard let scheduledCouse = cell.scheduleCourse else { return }
		let loadingLottie = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		loadingLottie.loadingAnimation()
		
		UserServie.shared.updateScheduledCourseStatus(user: scheduledCouse.student, tutor: scheduledCouse.course.tutor,
													  applicationID: scheduledCouse.applicationID,
													  result: result) {
			loadingLottie.stopAnimation()
			switch result {
			case CourseApplicationState.accept.status:
				cell.toggleButtons()
				cell.statusButton.setTitle(result, for: .normal)
			case CourseApplicationState.reject.status:
				cell.toggleButtons()
				cell.statusButton.setTitle(result, for: .normal)
			default:
				break
			}
			
			UIView.animate(withDuration: 0.3) {
				cell.layoutIfNeeded()
			}
		}
	}
	
}
