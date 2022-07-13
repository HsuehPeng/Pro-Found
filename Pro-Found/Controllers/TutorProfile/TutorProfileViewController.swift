//
//  ProfileViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import UIKit
import FirebaseAuth
import PhotosUI
import Lottie

class TutorProfileViewController: UIViewController {

	// MARK: - Properties
	
	var user: User
	
	var tutor: User
	
	var tutorCourses = [Course]() {
		didSet {
			tableView.reloadData()
		}
	}
	
	var tutorArticles = [Article]()
	
	var tutorEvents = [Event]()
	
	var tutorPosts = [Post]()
	
	var currentContent = "Articles" {
		didSet {
			tableView.reloadSections([2], with: .fade)
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
		let image = UIImage.asset(.chevron_left)?.withTintColor(.light60)
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(popVC), for: .touchUpInside)
		button.setDimensions(width: 36, height: 36)
		button.layer.cornerRadius = 36 / 2
		button.backgroundColor = .dark.withAlphaComponent(0.3)
		return button
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.backgroundColor = .light60
		tableView.register(TutorProfileMainTableViewCell.self, forCellReuseIdentifier: TutorProfileMainTableViewCell.reuseIdentifier)
		tableView.register(TutorProfileClassTableViewCell.self, forCellReuseIdentifier: TutorProfileClassTableViewCell.reuseIdentifier)
		tableView.register(ArticleListTableViewCell.self, forCellReuseIdentifier: ArticleListTableViewCell.reuseIdentifier)
		tableView.register(EventListTableViewCell.self, forCellReuseIdentifier: EventListTableViewCell.reuseIdentifier)
		tableView.register(PostPageFeedCell.self, forCellReuseIdentifier: PostPageFeedCell.reuseIdentifier)
		tableView.register(TutorProfileClassTableViewHeader.self, forHeaderFooterViewReuseIdentifier: TutorProfileClassTableViewHeader.reuseIdentifier)
		tableView.register(TutorProfileContentHeader.self, forHeaderFooterViewReuseIdentifier: TutorProfileContentHeader.reuseIdentifier)
		tableView.register(PostPageVideoCell.self, forCellReuseIdentifier: PostPageVideoCell.reuserIdentifier)
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
		view.backgroundColor = .light60
		
		tableView.dataSource = self
		tableView.delegate = self
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = true
		tabBarController?.tabBar.isHidden = false
		fetchTutorCourses()
		fetchTutorArticles()
		fetchTutorEvents()
		fetchTutorPosts()
		checkIfFollowed()
		setupNavBar()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		let cells = tableView.visibleCells
		cells.forEach { cell in
			guard let cell = cell as? PostPageVideoCell else { return }
			cell.looper = nil
			cell.avQueueplayer.pause()
			cell.avQueueplayer.removeAllItems()
		}
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(tableView)
		tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
		
		view.addSubview(backButton)
		backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 18)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
		tabBarController?.tabBar.isHidden = true
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
				self.showAlert(alertText: "Error", alertMessage: "Internate connection issue")
				print(error)
			}
		}
	}
	
	func fetchTutorArticles() {
		ArticleService.shared.fetchArticles { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let articles):
				let filteredArticles = articles.filter { article in
					if article.userID == self.tutor.userID {
						return true
					}
					return false
				}
				self.tutorArticles = filteredArticles
			case . failure(let error):
				self.showAlert(alertText: "Error", alertMessage: "Internate connection issue")
				print(error)
			}
		}
	}
	
	func fetchTutorEvents() {
		EventService.shared.fetchEvents { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let events):
				let filteredEvents = events.filter { event in
					if event.organizer.userID == self.tutor.userID {
						return true
					}
					return false
				}
				self.tutorEvents = filteredEvents
			case . failure(let error):
				self.showAlert(alertText: "Error", alertMessage: "Internate connection issue")
				print(error)
			}
		}
	}
	
	func fetchTutorPosts() {
		PostService.shared.getPosts { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let posts):
				let filteredPosts = posts.filter { post in
					if post.userID == self.tutor.userID {
						return true
					}
					return false
				}
				self.tutorPosts = filteredPosts.sorted(by: {$0.timestamp > $1.timestamp})
			case . failure(let error):
				self.showAlert(alertText: "Error", alertMessage: "Internate connection issue")
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
	
	func toggleSelectedSubjectButton(buttons: [UIButton], selectedButton: UIButton) {
		for i in 0...buttons.count - 1 {
			buttons[i].isSelected = false
		}
		
		selectedButton.isSelected = true
	}
	
	func handleDeletingContent() {
		
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
			switch currentContent {
			case "Articles":
				return tutorArticles.count
			case "Events":
				return tutorEvents.count
			case "Posts":
				return tutorPosts.count
			default:
				return 0
			}
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let mainCell = tableView.dequeueReusableCell(withIdentifier: TutorProfileMainTableViewCell.reuseIdentifier)
				as? TutorProfileMainTableViewCell else { fatalError("Can not dequeue TutorProfileMainTableViewCell") }
		guard let courseCell = tableView.dequeueReusableCell(withIdentifier: TutorProfileClassTableViewCell.reuseIdentifier)
				as? TutorProfileClassTableViewCell else { fatalError("Can not dequeue TutorProfileClassTableViewCell")}
		guard let articleCell = tableView.dequeueReusableCell(withIdentifier: ArticleListTableViewCell.reuseIdentifier)
				as? ArticleListTableViewCell else { fatalError("Can not dequeue ArticleListTableViewCell") }
		guard let eventCell = tableView.dequeueReusableCell(withIdentifier: EventListTableViewCell.reuseIdentifier)
				as? EventListTableViewCell else { fatalError("Can not dequeue TutorProfileClassTableViewCell")}
		guard let postCell = tableView.dequeueReusableCell(withIdentifier: PostPageFeedCell.reuseIdentifier)
				as? PostPageFeedCell else { fatalError("Can not dequeue ArticleListTableViewCell") }
		guard let postVideoCell = tableView.dequeueReusableCell(withIdentifier: PostPageVideoCell.reuserIdentifier)
				as? PostPageVideoCell else { fatalError("Can not dequeue PostPageVideoCell") }
		
		if indexPath.section == 0 {
			mainCell.delegate = self
			mainCell.isFollowed = isFollowed
			mainCell.tutor = tutor
			mainCell.user = user
			mainCell.selectionStyle = .none
			return mainCell
		} else if indexPath.section == 1 {
			courseCell.delegate = self
			courseCell.course = tutorCourses[indexPath.row]
			courseCell.selectionStyle = .none
			return courseCell
		} else {
			switch currentContent {
			case "Articles":
				articleCell.delegate = self
				articleCell.article = tutorArticles[indexPath.row]
				articleCell.selectionStyle = .none
				return articleCell
			case "Events":
				eventCell.event = tutorEvents[indexPath.row]
				eventCell.selectionStyle = .none
				eventCell.delegate = self
				return eventCell
			case "Posts":
				let post = tutorPosts[indexPath.row]
				
				if post.videoURL?.count ?? 0 > 0 {
					postVideoCell.delegate = self
					postVideoCell.user = user
					postVideoCell.post = post
					postVideoCell.selectionStyle = .none
					return postVideoCell
				} else {
					postCell.delegate = self
					postCell.user = user
					postCell.post = post
					postCell.selectionStyle = .none
					return postCell
				}
				
			default:
				articleCell.selectionStyle = .none
				return articleCell
			}
		}
	}
	
}

// MARK: - UITableViewDelegate

extension TutorProfileViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 2 {
			switch currentContent {
			case "Articles":
				let articleDetailVC = ArticleDetailViewController(article: tutorArticles[indexPath.row])
				navigationController?.pushViewController(articleDetailVC, animated: true)
			case "Events":
				let eventDetailVC = EventDetailViewController(event: tutorEvents[indexPath.row], user: user)
				navigationController?.pushViewController(eventDetailVC, animated: true)
			case "Posts":
				break
			default:
				break
			}
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let courseHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: TutorProfileClassTableViewHeader.reuseIdentifier)
				as? TutorProfileClassTableViewHeader else { return UITableViewHeaderFooterView() }
		guard let contentHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: TutorProfileContentHeader.reuseIdentifier)
				as? TutorProfileContentHeader else { fatalError("Can not dequeue GeneralTableViewHeader") }
		
		if section == 1 {
			courseHeader.delegate = self
			courseHeader.tutor = tutor
			return courseHeader
		} else if section == 2 {
			contentHeader.delegate = self
			return contentHeader
		}
		return nil
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 1 || section == 2 {
			return 50
		}
		
		return 0
	}
	
	func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let cell = cell as? PostPageVideoCell {
			cell.avQueueplayer.pause()
			cell.avQueueplayer.removeAllItems()
			cell.looper = nil
		}
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let cell = cell as? PostPageVideoCell {
			cell.setupAvPlayer()
		}
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
	func goCourseDetail(_ cell: TutorProfileClassTableViewCell) {
		guard let indexPath = tableView.indexPath(for: cell) else { return }
		let courseDetailVC = CourseDetailViewController(course: tutorCourses[indexPath.row], user: user)
		navigationController?.pushViewController(courseDetailVC, animated: true)
	}
	
	func showBottomSheet(_ cell: TutorProfileClassTableViewCell) {
		guard let course = cell.course else { return }
		let slideVC = SelectClassBottomSheetViewController(user: user, course: course, tutor: tutor)
		slideVC.modalPresentationStyle = .custom
		slideVC.transitioningDelegate = self
		present(slideVC, animated: true)
	}
}

// MARK: - TutorProfileContentHeaderDelegate

extension TutorProfileViewController: TutorProfileContentHeaderDelegate {
	func changeContent(_ cell: TutorProfileContentHeader, pressedButton type: UIButton) {
		let buttonCollections = [cell.articleButton, cell.eventButton, cell.postButton]
		
		switch type.titleLabel?.text {
		case "Articles":
			toggleSelectedSubjectButton(buttons: buttonCollections, selectedButton: type)
			currentContent = "Articles"
		case "Events":
			toggleSelectedSubjectButton(buttons: buttonCollections, selectedButton: type)
			currentContent = "Events"
		case "Posts":
			toggleSelectedSubjectButton(buttons: buttonCollections, selectedButton: type)
			currentContent = "Posts"
		default:
			break
		}
	}
	
}

// MARK: - PostPageFeedCellDelegate

extension TutorProfileViewController: PostPageFeedCellDelegate {
	
	func checkIfLikedByUser(_ cell: PostPageFeedCell) {
		guard let post = cell.post  else { return }

		if post.likedBy.contains(user.userID) {
			cell.likeButton.isSelected = true
		} else {
			cell.likeButton.isSelected = false
		}
	}
	
	func likePost(_ cell: PostPageFeedCell) {
		guard let post = cell.post else { return }
		guard let indexPath = tableView.indexPath(for: cell) else { return }
		
		if cell.likeButton.isSelected {
			PostService.shared.unlikePost(post: post, userID: user.userID) { [weak self] in
				guard let self = self else { return }
				
				self.tutorPosts[indexPath.row].likedBy.removeAll { userID in
					return userID == self.user.userID
				}
				self.tutorPosts[indexPath.row].likes -= 1
				
			}
			cell.post?.likes -= 1
			cell.likeButton.isSelected = false
		} else {
			PostService.shared.likePost(post: post, userID: user.userID) { [weak self] in
				guard let self = self else { return }
				
				self.tutorPosts[indexPath.row].likedBy.append(self.user.userID)
				
				self.tutorPosts[indexPath.row].likes += 1
				

			}
			cell.post?.likes += 1
			cell.likeButton.isSelected = true
		}
	}
	
	func goToCommentVC(_ cell: PostPageFeedCell) {
		guard let indexPath = tableView.indexPath(for: cell) else { return }
		let post = tutorPosts[indexPath.row]
		let postCommentVC = PostCommentViewController(post: post, user: user)
		navigationController?.pushViewController(postCommentVC, animated: true)
	}
	
	func askToDelete(_ cell: PostPageFeedCell) {
		guard let post = cell.post, let indexPath = tableView.indexPath(for: cell) else { return }
		let loadingLottie = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		
		let controller = UIAlertController(title: "Are you sure to delete this post?", message: nil, preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: "Sure", style: .destructive) { _ in
			loadingLottie.loadingAnimation()
			PostService.shared.deletePost(postID: post.postID, userID: self.tutor.userID) { [weak self] in
				guard let self = self else { return }
				loadingLottie.stopAnimation()
				self.tutorPosts.remove(at: indexPath.row)
				self.tableView.deleteRows(at: [indexPath], with: .fade)
				
			}
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		controller.addAction(okAction)
		controller.addAction(cancelAction)
		
		present(controller, animated: true, completion: nil)
	}
}

extension TutorProfileViewController: PostPageVideoCellDelegate {
	
	func goToCommentVC(_ cell: PostPageVideoCell) {
		guard let indexPath = tableView.indexPath(for: cell) else { return }
		let post = tutorPosts[indexPath.row]
		let postCommentVC = PostCommentViewController(post: post, user: user)
		navigationController?.pushViewController(postCommentVC, animated: true)
	}
	
	func likePost(_ cell: PostPageVideoCell) {
		guard let post = cell.post else { return }
		guard let indexPath = tableView.indexPath(for: cell) else { return }
		
		if cell.likeButton.isSelected {
			PostService.shared.unlikePost(post: post, userID: user.userID) { [weak self] in
				guard let self = self else { return }
				
				self.tutorPosts[indexPath.row].likedBy.removeAll { userID in
					return userID == self.user.userID
				}
				self.tutorPosts[indexPath.row].likes -= 1

			}
			cell.post?.likes -= 1
			cell.likeButton.isSelected = false
			
		} else {
			PostService.shared.likePost(post: post, userID: user.userID) { [weak self] in
				guard let self = self else { return }
				
				self.tutorPosts[indexPath.row].likedBy.append(self.user.userID)
				
				self.tutorPosts[indexPath.row].likes += 1

			}
			cell.post?.likes += 1
			cell.likeButton.isSelected = true
		}
	}
	
	func checkIfLikedByUser(_ cell: PostPageVideoCell) {
		guard let post = cell.post else { return }
		print(user.userID)
		if post.likedBy.contains(user.userID) {
			cell.likeButton.isSelected = true
		} else {
			cell.likeButton.isSelected = false
		}
	}
	
	func askToDelete(_ cell: PostPageVideoCell) {
		guard let post = cell.post, let indexPath = tableView.indexPath(for: cell) else { return }
		
		let loadingLottie = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		
		let controller = UIAlertController(title: "Are you sure to delete this post?", message: nil, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Sure", style: .destructive) { [weak self] _ in
			guard let self = self else { return }
			loadingLottie.loadingAnimation()
			PostService.shared.deletePost(postID: post.postID, userID: self.tutor.userID) { [weak self] in
				guard let self = self else { return }
				self.tutorPosts.remove(at: indexPath.row)
				self.tableView.deleteRows(at: [indexPath], with: .fade)
				loadingLottie.stopAnimation()
			}
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		controller.addAction(okAction)
		controller.addAction(cancelAction)
		
		present(controller, animated: true, completion: nil)
	}
	
	func toggleVideoVolunm(_ cell: PostPageVideoCell) {
		if cell.isVolumnOn {
			cell.avQueueplayer.volume = 1
		} else {
			cell.avQueueplayer.volume = 0
		}
	}
	
	
}

// MARK: - TutorProfileMainTableViewCellDelegate

extension TutorProfileViewController: TutorProfileMainTableViewCellDelegate {
	func toggleFollowingStatus(_ cell: TutorProfileMainTableViewCell) {
		
		let loadingLottie = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		loadingLottie.loadingAnimation()
		
		if cell.isFollowed {
			UserServie.shared.unfollow(senderID: user.userID, receiverID: tutor.userID) { [weak self] in
				guard let self = self else { return }
				loadingLottie.stopAnimation()
				cell.profileActionButton.setTitle("Follow", for: .normal)
				self.isFollowed = false
			}
		} else {
			UserServie.shared.follow(senderID: user.userID, receiverID: tutor.userID) { [weak self] in
				guard let self = self else { return }
				loadingLottie.stopAnimation()
				cell.profileActionButton.setTitle("Unfollow", for: .normal)
				self.isFollowed = true
			}
		}
	}
	
	func handleGoChat(_ cell: TutorProfileMainTableViewCell) {
		let chatVC = ChatViewController(receiver: tutor, sender: user)
		navigationController?.pushViewController(chatVC, animated: true)
	}
	
	func changeBlockingStatus(_ cell: TutorProfileMainTableViewCell) {
		
		let loadingLottie = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		
		if user.blockedUsers.contains(tutor.userID) {
			loadingLottie.loadingAnimation()
			UserServie.shared.toggleBlockingStatus(senderID: user.userID, receiverID: tutor.userID) { [weak self] in
				guard let self = self else { return }
				
				cell.blockUserButton.setImage(UIImage.asset(.password_show), for: .normal)
				guard let index = self.user.blockedUsers.firstIndex(of: self.tutor.userID) else { return }
				self.user.blockedUsers.remove(at: index)
				loadingLottie.stopAnimation()
			}
		} else {
			loadingLottie.loadingAnimation()
			let controller = UIAlertController(title: "Are you sure to block this person?", message: nil, preferredStyle: .alert)
			let okAction = UIAlertAction(title: "Sure", style: .destructive) { [weak self] _ in
				guard let self = self else { return }
				UserServie.shared.toggleBlockingStatus(senderID: self.user.userID, receiverID: self.tutor.userID) {
					cell.blockUserButton.setImage(UIImage.asset(.password_hide), for: .normal)
					self.user.blockedUsers.append(self.tutor.userID)
					loadingLottie.stopAnimation()
				}
			}
			
			let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
				loadingLottie.stopAnimation()
			}
			controller.addAction(okAction)
			controller.addAction(cancelAction)
			
			present(controller, animated: true, completion: nil)
		}

	}
	
	func rateTutor(_ cell: TutorProfileMainTableViewCell) {
		guard let user = cell.user, let tutor = cell.tutor else { return }
		
		let loadingLottie = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		loadingLottie.loadingAnimation()
		
		UserServie.shared.rateTutor(senderID: user.userID, receiverID: tutor.userID, rating: cell.starView.rating) {
			loadingLottie.stopAnimation()
		}
		
		cell.rateViewIsUp = false
		UIView.animate(withDuration: 0.4, animations: {
			cell.ratingView.alpha = 0
		}) { status in
			cell.ratingView.removeFromSuperview()
		}
	}
	
	func chooseBackgroundImage(_ cell: TutorProfileMainTableViewCell) {
		
		let actionSheet = UIAlertController(title: "Select Photo", message: "Where do you want to select a photo?",
											preferredStyle: .actionSheet)
		
		let photoAction = UIAlertAction(title: "Photos", style: .default) { (action) in
			var configuration = PHPickerConfiguration()
			configuration.selectionLimit = 1
			let picker = PHPickerViewController(configuration: configuration)
			picker.delegate = self
			
			if let sheet = picker.presentationController as? UISheetPresentationController {
				sheet.detents = [.medium(), .large()]
				sheet.preferredCornerRadius = 25
			}
			self.present(picker, animated: true, completion: nil)
		}
		actionSheet.addAction(photoAction)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		actionSheet.addAction(cancelAction)
		
		if user.userID == tutor.userID {
			self.present(actionSheet, animated: true, completion: nil)
		}
	}
	
}

// MARK: - EventListTableViewCellDelegate

extension TutorProfileViewController: EventListTableViewCellDelegate {
	
	func bookEvent(_ cell: EventListTableViewCell) {
		guard let event = cell.event else { return }
		let loadingLottie = Lottie(superView: view, animationView: AnimationView(name: "loadingAnimation"))
		loadingLottie.loadingAnimation()
		UserServie.shared.uploadScheduledEvent(participantID: user.userID, eventID: event.eventID, time: event.timestamp) {
			cell.bookEventButton.isEnabled = false
			cell.bookEventButton.backgroundColor = .dark20
			loadingLottie.stopAnimation()
		}
	}
	
}

// MARK: - ArticleListTableViewCellDelegate

extension TutorProfileViewController: ArticleListTableViewCellDelegate {
	func askToDelete(_ cell: ArticleListTableViewCell) {
		guard let article = cell.article, let indexPath = tableView.indexPath(for: cell) else { return }
		
		let loadingLottie = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		let controller = UIAlertController(title: "Are you sure to delete this article?", message: nil, preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: "Sure", style: .destructive) { _ in
			loadingLottie.loadingAnimation()
			ArticleService.shared.deleteArticle(articleID: article.articleID, userID: self.tutor.userID) { [weak self] in
				guard let self = self else { return }
				self.tutorArticles.remove(at: indexPath.row)
				self.tableView.deleteRows(at: [indexPath], with: .fade)
				loadingLottie.stopAnimation()
			}
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		controller.addAction(okAction)
		controller.addAction(cancelAction)
		
		present(controller, animated: true, completion: nil)
	}
}

// MARK: - PHPickerViewControllerDelegate

extension TutorProfileViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true)
		let itemProviders = results.map(\.itemProvider)
		for item in itemProviders {
			if item.canLoadObject(ofClass: UIImage.self) {
				item.loadObject(ofClass: UIImage.self) { [weak self](image, error) in
					guard let self = self else { return }
					DispatchQueue.main.async {
						if let image = image as? UIImage {
							guard let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
									as? TutorProfileMainTableViewCell else { return }
							cell.backImageView.image = nil
							cell.backImageView.image = image
							let loadingLottie = Lottie(superView: self.view, animationView: AnimationView.init(name: "loadingAnimation"))
							loadingLottie.loadingAnimation()
							UserServie.shared.uploadUserBackgroundImageAndDownloadImageURL(userBackgroundImage: image,
																						   user: self.tutor) { result in
								print("Photo uploaded")
								loadingLottie.stopAnimation()
							}
						}
					}
				}
			}
		}
	}
}

// MARK: - UIViewControllerTransitioningDelegate

extension TutorProfileViewController: UIViewControllerTransitioningDelegate {
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?,
								source: UIViewController) -> UIPresentationController? {
		return SelectClassPresentationVController(presentedViewController: presented, presenting: presenting)
	}
}
