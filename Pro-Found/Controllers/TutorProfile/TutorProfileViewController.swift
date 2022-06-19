//
//  ProfileViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import UIKit
import FirebaseAuth

class TutorProfileViewController: UIViewController {

	// MARK: - Properties
	
	var isTutor = false
	
	var user: User?
	
	var tutor: User?
	
	var tutorCourses = [Course]() {
		didSet {
			tableView.reloadData()
		}
	}
	var isFollowed: Bool = false {
		didSet {
			tableView.reloadData()
		}
	}
	
	private let backButtonView: UIView = {
		let view = UIView()
		view.backgroundColor = .dark
		return view
	}()
	
	private lazy var backButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.chevron_left)?.withTintColor(.white)
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(popVC), for: .touchUpInside)
		button.setDimensions(width: 36, height: 36)
		button.layer.cornerRadius = 36 / 2
		button.backgroundColor = .dark.withAlphaComponent(0.2)
		return button
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(TutorProfileMainTableViewCell.self, forCellReuseIdentifier: TutorProfileMainTableViewCell.reuseIdentifier)
		tableView.register(TutorProfileClassTableViewCell.self, forCellReuseIdentifier: TutorProfileClassTableViewCell.reuseIdentifier)
		tableView.register(TutorProfileClassTableViewHeader.self, forHeaderFooterViewReuseIdentifier: TutorProfileClassTableViewHeader.reuseIdentifier)
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
		checkIfFollowed()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		fetchUserData()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(tableView)
		tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
		
		view.addSubview(backButton)
		backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 18)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
	}
	
	// MARK: - Actions
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Helpers
	
	func fetchUserData() {
		guard let user = tutor else { return }
		print(user.name)
		
		UserServie.shared.getUserData(uid: user.userID) { [weak self] result in
			guard let self = self else { return }
			
			switch result {
			case.success(let user):
				self.tutor = user
				CourseServie.shared.fetchUserCourses(userID: user.userID) { [weak self] result in
					guard let self = self else { return }
					switch result {
					case.success(let courses):
						self.tutorCourses = courses
					case.failure(let error):
						print(error)
					}
				}
			case.failure(let error):
				print(error)
			}
		}
	}
	
	func checkIfFollowed() {
		guard let user = user, let tutor = tutor else { return }
		UserServie.shared.checkIfFollow(sender: user, receiver: tutor) { [weak self] bool in
			guard let self = self else { return }
			self.isFollowed = bool
		}
	}

}

// MARK: - UITableViewDataSource

extension TutorProfileViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		} else {
			return tutorCourses.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let mainCell = tableView.dequeueReusableCell(withIdentifier: TutorProfileMainTableViewCell.reuseIdentifier)
				as? TutorProfileMainTableViewCell else { return UITableViewCell() }
		guard let courseCell = tableView.dequeueReusableCell(withIdentifier: TutorProfileClassTableViewCell.reuseIdentifier)
				as? TutorProfileClassTableViewCell else { return UITableViewCell()}
		
		if indexPath.section == 0 {
			mainCell.tutor = tutor
			mainCell.user = user
			mainCell.isFollowed = isFollowed
			return mainCell
		} else {
			courseCell.delegate = self
			courseCell.course = tutorCourses[indexPath.row]
			return courseCell
		}
	}
	
}

// MARK: - UITableViewDelegate

extension TutorProfileViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TutorProfileClassTableViewHeader.reuseIdentifier)
				as? TutorProfileClassTableViewHeader else { return UITableViewHeaderFooterView() }
		
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

// MARK: - ProfileClassTableViewHeaderDelegate

extension TutorProfileViewController: ProfileClassTableViewHeaderDelegate {
	
	func createCourse(_ header: TutorProfileClassTableViewHeader) {
		guard let user = tutor else { return }
		let createCourseVC = CreateCourseViewController(user: user)
		navigationController?.pushViewController(createCourseVC, animated: true)
	}
}

// MARK: - ProfileClassTableViewCellDelegate

extension TutorProfileViewController: ProfileClassTableViewCellDelegate {
	func showBottomSheet(_ cell: TutorProfileClassTableViewCell) {
		guard let course = cell.course, let user = user, let tutor = tutor else { return }
		let slideVC = SelectClassBottomSheetViewController(user: user, course: course, tutor: tutor)
		slideVC.modalPresentationStyle = .custom
		slideVC.transitioningDelegate = self
		present(slideVC, animated: true)
	}
}

// MARK: - UIViewControllerTransitioningDelegate

extension TutorProfileViewController: UIViewControllerTransitioningDelegate {
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?,
								source: UIViewController) -> UIPresentationController? {
		return SelectClassPresentationVController(presentedViewController: presented, presenting: presenting)
	}
}
