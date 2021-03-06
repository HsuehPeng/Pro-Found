//
//  CourseDetailViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/20.
//

import UIKit
import FirebaseAuth
import CoreLocation
import MapKit
import Lottie

class CourseDetailViewController: UIViewController {
	
	// MARK: - Properties
	
	let course: Course
	
	let user: User
	
	var isFollow: Bool? {
		didSet {
			tableView.reloadData()
		}
	}
	
	var courseLocation: CLLocation?
	
	private let tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.separatorStyle = .none
		tableView.backgroundColor = .light60
		tableView.register(CourseDetailListTableViewCell.self, forCellReuseIdentifier: CourseDetailListTableViewCell.reuseIdentifier)
		tableView.register(CourseDetailIntroTableViewCell.self, forCellReuseIdentifier: CourseDetailIntroTableViewCell.reuseIdentifier)
		tableView.register(CourseDetailTableViewHeader.self, forHeaderFooterViewReuseIdentifier: CourseDetailTableViewHeader.reuseIdentifier)
		return tableView
	}()
	
	private let bottomBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .light60
		return view
	}()
	
	private lazy var feeLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 20), textColor: .dark, text: "$")
		label.text = "$ \(course.fee)"
		return label
	}()
	
	private lazy var scheduleCourseButton: UIButton = {
		let button = CustomUIElements().makeLargeButton(buttonColor: .orange, buttonTextColor: .light60, borderColor: .clear, buttonText: "Book Course")
		button.addTarget(self, action: #selector(handleBookCourse), for: .touchUpInside)
		button.widthAnchor.constraint(equalToConstant: 200).isActive = true
		return button
	}()
	
	// MARK: - Lifecycle
	
	init(course: Course, user: User) {
		self.course = course
		self.user = user
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .light60
		
		tableView.dataSource = self
		tableView.delegate = self
		
		setupUI()
		convertAdressToCLLocation()
		checkIfFollowed()
		checkIfScheduleButtonCanClick()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavBar()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(tableView)
		view.addSubview(bottomBarView)
		bottomBarView.addSubview(feeLabel)
		bottomBarView.addSubview(scheduleCourseButton)
		
		tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
		
		bottomBarView.anchor(top: tableView.bottomAnchor ,left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, height: 78)
		
		feeLabel.centerY(inView: bottomBarView, leftAnchor: bottomBarView.leftAnchor, paddingLeft: 16)
		feeLabel.rightAnchor.constraint(equalTo: scheduleCourseButton.leftAnchor, constant: -16).isActive = true
		
		scheduleCourseButton.centerY(inView: bottomBarView)
		scheduleCourseButton.rightAnchor.constraint(equalTo: bottomBarView.rightAnchor, constant: -16).isActive = true
	}
	
	func setupNavBar() {
		
		setupAttributeNavBar(titleText: "Course Detail")

		let leftItemImage = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal)
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftItemImage, style: .done, target: self, action: #selector(popVC))
		let rightItemImage = UIImage.asset(.more)?.withRenderingMode(.alwaysOriginal)
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightItemImage, style: .plain, target: self, action: #selector(handleReportAction))
	}
	
	// MARK: - Actions
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Helpers
	
	@objc func handleReportAction() {
		let actionSheet = UIAlertController(title: "Actions", message: nil,
											preferredStyle: .actionSheet)
		
		let reportAction = UIAlertAction(title: "Report", style: .destructive) { [weak self] action in
			guard let self = self else { return }
			let reportVC = ReportViewController(contentID: self.course.courseID, contentType: ContentTyep.course)
			if let reportSheet = reportVC.presentationController as? UISheetPresentationController {
				reportSheet.detents = [.large()]
			}
			self.present(reportVC, animated: true)
		}
		actionSheet.addAction(reportAction)
		
		if course.userID == user.userID {
			let deleteAction = UIAlertAction(title: "Archive", style: .destructive) { [weak self] action in
				guard let self = self else { return }
				CourseServie.shared.archiveCourse(courseID: self.course.courseID, userID: self.user.userID) { [weak self] error in
					guard let self = self else { return }
					if let error = error {
						self.showAlert(alertText: "Connection Error", alertMessage: "\(error)")
					} else {
						self.navigationController?.popViewController(animated: true)
					}
				}
			}
			actionSheet.addAction(deleteAction)
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		actionSheet.addAction(cancelAction)
		
		self.present(actionSheet, animated: true, completion: nil)
	}
	
	@objc func handleBookCourse() {
		
		let slideVC = SelectClassBottomSheetViewController(user: user, course: course, tutor: course.tutor)
		slideVC.modalPresentationStyle = .custom
		slideVC.transitioningDelegate = self
		present(slideVC, animated: true)
	}
	
	func checkIfFollowed() {
		UserServie.shared.checkIfFollow(senderID: user.userID, receiveriD: course.tutor.userID) { [weak self] bool in
			guard let self = self else { return }
			self.isFollow = bool
		}
	}
	
	func checkIfScheduleButtonCanClick() {
		if user.userID == course.userID || course.isdeleted {
			scheduleCourseButton.isEnabled = false
			scheduleCourseButton.backgroundColor = .dark10
		}
	}
	
	func convertAdressToCLLocation() {
		let address = course.location
		let geoCoder = CLGeocoder()
		
		geoCoder.geocodeAddressString(address) { (placemarks, error) in
			guard
				let placemarks = placemarks,
				let location = placemarks.first?.location
			else {
				print("No location found: \(String(describing: error))")
				return
			}
			self.courseLocation = location
		}
	}

}

// MARK: - UITableViewDataSource

extension CourseDetailViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let listCell = tableView.dequeueReusableCell(withIdentifier: CourseDetailListTableViewCell.reuseIdentifier, for: indexPath)
				as? CourseDetailListTableViewCell else { fatalError("Can not dequeue CourseDetailListTableViewCell") }
		
		guard let introCell = tableView.dequeueReusableCell(withIdentifier: CourseDetailIntroTableViewCell.reuseIdentifier, for: indexPath)
				as? CourseDetailIntroTableViewCell else { fatalError("Can not dequeue CourseDetailListTableViewCell") }
		if indexPath.section == 0 {
			listCell.delegate = self
			listCell.courseLocation = courseLocation
			listCell.isFollow = isFollow
			listCell.course = course
			listCell.selectionStyle = .none
			return listCell
		} else {
			introCell.course = course
			return introCell
		}

	}
}

// MARK: - UITableViewDelegate

extension CourseDetailViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 && indexPath.row == 0 {
			guard let courseLocation = courseLocation else { return }
			let mapVC = MapViewController(location: courseLocation)
			navigationController?.pushViewController(mapVC, animated: true)
		}
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CourseDetailTableViewHeader.reuseIdentifier)
				as? CourseDetailTableViewHeader else { return nil }
		if section == 0 {
			header.course = course
			return header
		} else {
			return nil
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return section == 0 ? 50 : 0
	}
}

// MARK: - CourseDetailListTableViewCellDelegate

extension CourseDetailViewController: CourseDetailListTableViewCellDelegate {
	func goToPublicProfile(_ cell: CourseDetailListTableViewCell) {
		guard let course = cell.course else { return }
		let tutorProfileVC = TutorProfileViewController(user: user, tutor: course.tutor)
		navigationController?.pushViewController(tutorProfileVC, animated: true)
	}
	
	func handleFollowing(_ cell: CourseDetailListTableViewCell) {
		guard let isFollow = cell.isFollow, let uid = Auth.auth().currentUser?.uid else { return }
		let loadingLottie = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		loadingLottie.loadingAnimation()
		
		if isFollow {
			UserServie.shared.unfollow(senderID: uid, receiverID: course.tutor.userID) {
				loadingLottie.stopAnimation()
			}
			cell.followButton.setTitle("Follow", for: .normal)
			self.isFollow = false
		} else {
			UserServie.shared.follow(senderID: uid, receiverID: course.tutor.userID) {
				loadingLottie.stopAnimation()
			}
			cell.followButton.setTitle("Unfollow", for: .normal)
			self.isFollow = true
		}
	}
}

// MARK: - UIViewControllerTransitioningDelegate

extension CourseDetailViewController: UIViewControllerTransitioningDelegate {
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?,
								source: UIViewController) -> UIPresentationController? {
		return SelectClassPresentationVController(presentedViewController: presented, presenting: presenting)
	}
}
