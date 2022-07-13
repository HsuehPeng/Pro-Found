//
//  ProfileViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/17.
//

import UIKit
import FirebaseAuth
import Kingfisher
import PhotosUI

class ProfileViewController: UIViewController {

	// MARK: - Properties
	
	var user: User? {
		didSet {
			configureUI()
			tableView.reloadData()
		}
	}
	
	var favoriteArticles = [Article]()
	
	var followingTutors = [User]()
	
	var blockingTutors = [User]()
	
	let profileListIcon: [UIImage?] = [UIImage.asset(.verified_user)?.withTintColor(.green),
									   UIImage.asset(.account_pin)?.withTintColor(.dark40),
									   UIImage.asset(.favorite)?.withTintColor(.dark40),
									   UIImage.asset(.bookmark)?.withTintColor(.dark40),
									   UIImage.asset(.password_hide)?.withTintColor(.dark40),
									   UIImage.asset(.doc)?.withTintColor(.dark40),
									   UIImage.asset(.alert_info)?.withTintColor(.dark40),
									   UIImage.asset(.logout)?.withTintColor(.dark40),
									   UIImage.asset(.delete)?.withTintColor(.red)]
	
	let profileListText: [String] = ["Become a Tutor",
									 "My Public Profile",
									 "Following Tutors",
									 "Saved Articles",
									 "Blocked Users",
									 "User License Agreement",
									 "Privacy Policy",
									 "Logout",
									 "Delete Account"]
		
	private let topView: UIView = {
		let view = UIView()
		view.backgroundColor = .light60
		
		return view
	}()
	
	private let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 64, height: 64)
		imageView.layer.cornerRadius = 64 / 2
		imageView.backgroundColor = .dark20
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private let nameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 16),
												 textColor: .dark60, text: "Test Name")

		return label
	}()
	
	private let tutorBadgeImageView: UIView = {
		let imageView = UIImageView()
		let image = UIImage.asset(.check_circle)?.withTintColor(.orange)
		imageView.image = image
		imageView.setDimensions(width: 20, height: 20)
		return imageView
	}()
	
	private let universityLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14),
												 textColor: .dark40, text: "University")

		return label
	}()
	
	private lazy var editButton: UIButton = {
		let button = CustomUIElements().makeSmallButton(buttonColor: .orange, buttonTextColor: .light60,
														borderColor: .clear, buttonText: "Edit Profile")
		button.widthAnchor.constraint(equalToConstant: 100).isActive = true
		button.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
		return button
	}()
	
	private lazy var changePhotoButton: UIButton = {
		let button = CustomUIElements().makeSmallButton(buttonColor: .light60, buttonTextColor: .orange,
														borderColor: .clear, buttonText: "Change Photo")
		button.addTarget(self, action: #selector(handlePickingPhoto), for: .touchUpInside)
		button.widthAnchor.constraint(equalToConstant: 116).isActive = true
		return button
	}()
	
	private let dividerView: UIView = {
		let view = UIView()
		view.backgroundColor = .dark20
		return view
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.separatorStyle = .none
		tableView.backgroundColor = .light60
		tableView.register(UserProfileListTableViewCell.self, forCellReuseIdentifier: UserProfileListTableViewCell.reuserIdentifier)
		return tableView
	}()
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .light60
		
		tableView.dataSource = self
		tableView.delegate = self
		
		setupNavBar()
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		fetchUserData()
		fetchFavoriteArticles()
		fetchFollowingTutors()
		fetchBlockedTutors()
		
		if Auth.auth().currentUser == nil {
			tabBarController?.selectedIndex = 0
		}
		
		navigationController?.navigationBar.isHidden = true
		tabBarController?.tabBar.isHidden = false
	}
	
	// MARK: - UI
	
	func setupUI() {
		
		view.addSubview(topView)
		
		topView.addSubview(tutorBadgeImageView)
		
		topView.addSubview(nameLabel)
		
		topView.addSubview(profileImageView)
		
		topView.addSubview(universityLabel)
		
		topView.addSubview(editButton)
		
		topView.addSubview(changePhotoButton)
		
		topView.addSubview(dividerView)
		
		view.addSubview(tableView)
		
		topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 157)
		
		profileImageView.anchor(top: topView.topAnchor, left: topView.leftAnchor, paddingTop: 16,
								paddingLeft: 16)
		
		nameLabel.anchor(top: topView.topAnchor, left: profileImageView.rightAnchor, right: tutorBadgeImageView.leftAnchor,
						 paddingTop: 24, paddingLeft: 16, paddingRight: 4)
		
		tutorBadgeImageView.centerY(inView: nameLabel)
		tutorBadgeImageView.rightAnchor.constraint(lessThanOrEqualTo: topView.rightAnchor, constant: -16).isActive = true
		
		universityLabel.anchor(top: nameLabel.bottomAnchor, left: profileImageView.rightAnchor, right: topView.rightAnchor,
							   paddingTop: 4, paddingLeft: 16, paddingRight: 16)
		
		editButton.anchor(top: universityLabel.bottomAnchor, left: profileImageView.rightAnchor, paddingTop: 16, paddingLeft: 16)
		
		changePhotoButton.anchor(top: universityLabel.bottomAnchor, left: editButton.rightAnchor, paddingTop: 16, paddingLeft: 12)
		
		dividerView.anchor(top: editButton.bottomAnchor, left: topView.leftAnchor,
						   bottom: topView.bottomAnchor, right: topView.rightAnchor, paddingTop: 36, height: 1)
		
		tableView.anchor(top: topView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
	}
	
	// MARK: - Actions
	
	@objc func handleEditProfile() {
		guard let user = user else { return }
		let editProfileVC = EditProfileViewController(user: user)
		navigationController?.pushViewController(editProfileVC, animated: true)
	}
	
	@objc func handlePickingPhoto() {
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
		
		self.present(actionSheet, animated: true, completion: nil)
	}
	
	func logOut() {
		
		let controller = UIAlertController(title: "Are you sure to log out?", message: nil, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Sure", style: .destructive) { [weak self] _ in
			guard let self = self else { return }
			self.handleLogout()
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		controller.addAction(okAction)
		controller.addAction(cancelAction)
		
		present(controller, animated: true, completion: nil)
	}
	
	func handleLogout() {
		
		// Check provider ID to verify that the user has signed in with Apple
		if
			let providerId = Auth.auth().currentUser?.providerData.first?.providerID,
			providerId == "apple.com" {
			// Clear saved user ID
			UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
		}
		
		// Perform sign out from Firebase
		
		if Auth.auth().currentUser?.uid != nil {
			do {
				try Auth.auth().signOut()
			} catch let signOutError as NSError {
				print("Error signing out: %@", signOutError)
			}
		}
		
		guard let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).flatMap({
			$0.windows }).first(where: { $0.isKeyWindow }) else { return }
		
		guard let tab = window.rootViewController as? MainTabController else { return }
		
		tab.authenticateUserAndConfigureUI()
		self.dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Helpers
	
	func fetchUserData() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		UserServie.shared.getUserData(uid: uid) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let user):
				self.user = user
				self.tutorBadgeImageView.isHidden = !user.isTutor
			case .failure(let error):
				self.showAlert(alertText: "Error", alertMessage: "Internate connection issue")
				print(error)
			}
		}
	}
	
	func fetchFavoriteArticles() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		ArticleService.shared.fetchFavoriteArticles(userID: uid) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let articles):
				self.favoriteArticles = articles
			case .failure(let error):
				self.showAlert(alertText: "Error", alertMessage: "Internate connection issue")
				print(error)
			}
		}
	}
	
	func fetchFollowingTutors() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		UserServie.shared.getFollowingTutors(userID: uid) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let users):
				self.followingTutors = users
			case .failure(let error):
				self.showAlert(alertText: "Error", alertMessage: "Internate connection issue")
				print(error)
			}
		}
	}
	
	func fetchBlockedTutors() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		UserServie.shared.getBlockedTutors(userID: uid) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let users):
				print(users)
				self.blockingTutors = users
			case .failure(let error):
				self.showAlert(alertText: "Error", alertMessage: "Internate connection issue")
				print(error)
			}
		}
	}
	
	func configureUI() {
		guard let user = user else { return }
		let imageUrl = URL(string: user.profileImageURL)
		profileImageView.kf.setImage(with: imageUrl)
		nameLabel.text = user.name
		universityLabel.text = user.school
	}
	
	func deleteAcount() {
		guard let userAcount = Auth.auth().currentUser else { return }
		
		let controller = UIAlertController(title: "Are you sure to delete this account?", message: nil, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Sure", style: .destructive) { _ in
			userAcount.delete(completion: { error in
				if let error = error {
					print("Error deleting account: \(error)")
				} else {
					guard let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).flatMap({
						$0.windows }).first(where: { $0.isKeyWindow }) else { return }
					
					guard let tab = window.rootViewController as? MainTabController else { return }
					
					tab.authenticateUserAndConfigureUI()
					self.dismiss(animated: true, completion: nil)
				}
			})
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		controller.addAction(okAction)
		controller.addAction(cancelAction)
		
		present(controller, animated: true, completion: nil)
	}
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return profileListIcon.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileListTableViewCell.reuserIdentifier, for: indexPath)
				as? UserProfileListTableViewCell else { fatalError("Can not dequeue UserProfileListTableViewCell") }
		
		cell.titleLabel.textColor = .dark
		cell.titleLabel.text = profileListText[indexPath.row]
		cell.iconImageView.image = profileListIcon[indexPath.row]
		
		if indexPath.row == 8 {
			cell.titleLabel.textColor = .red
		} else if indexPath.row == 0 {
			if user?.isTutor ?? false {
				cell.titleLabel.textColor = .red
				cell.titleLabel.text = "Cancel Tutor Role"
			} else {
				cell.titleLabel.textColor = .green
			}
		}

		return cell
	}
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let user = user else { return }
		tableView.deselectRow(at: indexPath, animated: true)
		switch indexPath.row {
		case 0:
			
			if user.isTutor {
				let controller = UIAlertController(title: "Are you sure to cancel tutor role?", message: nil, preferredStyle: .alert)
				let okAction = UIAlertAction(title: "Sure", style: .destructive) { _ in
					UserServie.shared.toggleTutorStatus(userID: user.userID, subject: user.subject, isTutor: user.isTutor) { [weak self] in
						guard let self = self else { return }
						self.fetchUserData()
						self.tableView.reloadData()
					}
				}
				let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
				controller.addAction(okAction)
				controller.addAction(cancelAction)
				
				present(controller, animated: true, completion: nil)
			} else {
				let becomeTutorVC = BecomeTutorViewController(user: user)
				becomeTutorVC.updateProfilePage = { [weak self] in
					guard let self = self else { return }
					self.fetchUserData()
					self.tableView.reloadData()
				}
				if let sheet = becomeTutorVC.presentationController as? UISheetPresentationController {
					sheet.detents = [.medium()]
					sheet.preferredCornerRadius = 25
				}
				present(becomeTutorVC, animated: true)
			}
			
		case 1:
			let publicProfilePage = TutorProfileViewController(user: user, tutor: user)
			navigationController?.pushViewController(publicProfilePage, animated: true)
		case 2:
			let followingTutorVC = TutorListViewController(tutors: followingTutors, user: user)
			followingTutorVC.noCellView.indicatorLabel.text = "You are not following any tutor"
			navigationController?.pushViewController(followingTutorVC, animated: true)
		case 3:
			let savedArticleVC = ArticleListViewController(articles: favoriteArticles)
			navigationController?.pushViewController(savedArticleVC, animated: true)
		case 4:
			print(blockingTutors.count)
			let blockingTutorVC = TutorListViewController(tutors: blockingTutors, user: user)
			blockingTutorVC.noCellView.indicatorLabel.text = "You are not blocking any tutor"
			blockingTutorVC.forBlockingPage = true
			navigationController?.pushViewController(blockingTutorVC, animated: true)
		case 5:
			let policyViewController = PolicyViewController()
			policyViewController.url = PolicyType.eula.url
			present(policyViewController, animated: true, completion: nil)
		case 6:
			let policyViewController = PolicyViewController()
			policyViewController.url = PolicyType.privacyPolicy.url
			present(policyViewController, animated: true, completion: nil)
		case 7:
			logOut()
		case 8:
			deleteAcount()
		default:
			break
		}
	}
}

// MARK: - PHPickerViewControllerDelegate

extension ProfileViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		guard let user = user else { return }
		picker.dismiss(animated: true)
		let itemProviders = results.map(\.itemProvider)
		for item in itemProviders {
			if item.canLoadObject(ofClass: UIImage.self) {
				item.loadObject(ofClass: UIImage.self) { [weak self](image, error) in
					guard let self = self else { return }
					DispatchQueue.main.async {
						if let image = image as? UIImage {
							
							self.profileImageView.image = nil
							self.profileImageView.image = image
							UserServie.shared.uploadUserImageAndDownloadImageURL(userProfileImage: image, user: user) { result in
								print("Photo uploaded")
							}
						}
					}
				}
			}
		}
	}
}
