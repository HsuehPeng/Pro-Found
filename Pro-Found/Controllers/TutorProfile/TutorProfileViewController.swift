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
	
	let user: User
	
	let tutor: User
	
	var tutorCourses = [Course]() {
		didSet {
			tableView.reloadData()
		}
	}
	
	var tutorArticles = [Article]() {
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
		button.backgroundColor = .dark.withAlphaComponent(0.3)
		return button
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.register(TutorProfileMainTableViewCell.self, forCellReuseIdentifier: TutorProfileMainTableViewCell.reuseIdentifier)
		tableView.register(TutorProfileClassTableViewCell.self, forCellReuseIdentifier: TutorProfileClassTableViewCell.reuseIdentifier)
		tableView.register(ArticleListTableViewCell.self, forCellReuseIdentifier: ArticleListTableViewCell.reuseIdentifier)
		tableView.register(TutorProfileClassTableViewHeader.self, forHeaderFooterViewReuseIdentifier: TutorProfileClassTableViewHeader.reuseIdentifier)
		tableView.register(GeneralTableViewHeader.self, forHeaderFooterViewReuseIdentifier: GeneralTableViewHeader.reuseIdentifier)
		tableView.contentInsetAdjustmentBehavior = .never
		tableView.separatorStyle = .none
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.sectionHeaderTopPadding = 0
		return tableView
	}()
	
	// MARK: - Lifecycle
	
	init(user: User, tutor: User) {
		self.user = user
		self.tutor = tutor
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
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
		navigationController?.navigationBar.isHidden = true
		tabBarController?.tabBar.isHidden = false
		fetchTutorCourses()
		fetchTutorArticles()
		checkIfFollowed()
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
	
	func fetchTutorCourses() {
		CourseServie.shared.fetchUserCourses(userID: tutor.userID) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let courses):
				self.tutorCourses = courses
			case .failure(let error):
				print(error)
			}
		}
	}
	
	func fetchTutorArticles() {
		ArticleService.shared.fetchArticles { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let articles):
				self.tutorArticles = articles
			case . failure(let error):
				print(error)
			}
		}
	}
	
	func checkIfFollowed() {
		UserServie.shared.checkIfFollow(senderID: user.userID, receiveriD: tutor.userID) { [weak self] bool in
			guard let self = self else { return }
			self.isFollowed = bool
		}
	}

}

// MARK: - UITableViewDataSource

extension TutorProfileViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		} else if section == 1 {
			return tutorCourses.count
		} else {
			return tutorArticles.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let mainCell = tableView.dequeueReusableCell(withIdentifier: TutorProfileMainTableViewCell.reuseIdentifier)
				as? TutorProfileMainTableViewCell else { fatalError("Can not dequeue TutorProfileMainTableViewCell") }
		guard let courseCell = tableView.dequeueReusableCell(withIdentifier: TutorProfileClassTableViewCell.reuseIdentifier)
				as? TutorProfileClassTableViewCell else { fatalError("Can not dequeue TutorProfileClassTableViewCell")}
		guard let articleCell = tableView.dequeueReusableCell(withIdentifier: ArticleListTableViewCell.reuseIdentifier)
				as? ArticleListTableViewCell else { fatalError("Can not dequeue ArticleListTableViewCell") }
		
		if indexPath.section == 0 {
			mainCell.isFollowed = isFollowed
			mainCell.tutor = tutor
			mainCell.user = user
			return mainCell
		} else if indexPath.section == 1{
			courseCell.delegate = self
			courseCell.course = tutorCourses[indexPath.row]
			return courseCell
		} else {
			articleCell.article = tutorArticles[indexPath.row]
			return articleCell
		}
		
	}
	
}

// MARK: - UITableViewDelegate

extension TutorProfileViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 1 {
			let courseDetailVC = CourseDetailViewController(course: tutorCourses[indexPath.row], user: user)
			navigationController?.pushViewController(courseDetailVC, animated: true)
		} else if indexPath.section == 2 {
			let articleDetailVC = ArticleDetailViewController(article: tutorArticles[indexPath.row])
			navigationController?.pushViewController(articleDetailVC, animated: true)
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let courseHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: TutorProfileClassTableViewHeader.reuseIdentifier)
				as? TutorProfileClassTableViewHeader else { return UITableViewHeaderFooterView() }
		guard let articleHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: GeneralTableViewHeader.reuseIdentifier)
				as? GeneralTableViewHeader else { fatalError("Can not dequeue GeneralTableViewHeader") }
		
		
		if section == 1 {
			courseHeader.delegate = self
			courseHeader.tutor = tutor
			return courseHeader
		} else if section == 2 {
			articleHeader.titleLabel.text = "Articles"
			articleHeader.seeAllButton.isHidden = true
			return articleHeader
		}
		
		return nil
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 1 || section == 2 {
			return 50
		}
		
		return 0
	}
	
}

// MARK: - ProfileClassTableViewHeaderDelegate

extension TutorProfileViewController: ProfileClassTableViewHeaderDelegate {
	
	func createCourse(_ header: TutorProfileClassTableViewHeader) {
		let createCourseVC = CreateCourseViewController(user: user)
		navigationController?.pushViewController(createCourseVC, animated: true)
	}
}

// MARK: - ProfileClassTableViewCellDelegate

extension TutorProfileViewController: ProfileClassTableViewCellDelegate {
	func showBottomSheet(_ cell: TutorProfileClassTableViewCell) {
		guard let course = cell.course else { return }
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
