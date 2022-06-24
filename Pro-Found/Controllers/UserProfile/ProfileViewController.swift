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
		}
	}
	
	var favoriteArticles = [Article]()
	
	var followingTutors = [User]()
	
	let profileListIcon: [UIImage?] = [UIImage.asset(.verified_user)?.withTintColor(.green),
									   UIImage.asset(.account_pin)?.withTintColor(.dark40),
									  UIImage.asset(.favorite)?.withTintColor(.dark40),
									  UIImage.asset(.bookmark)?.withTintColor(.dark40),
									  UIImage.asset(.doc)?.withTintColor(.dark40),
									  UIImage.asset(.alert_info)?.withTintColor(.dark40),
									  UIImage.asset(.logout)?.withTintColor(.dark40),
									   UIImage.asset(.delete)?.withTintColor(.red)]
	
	let profileListText: [String] = ["Become a Tutor",
									 "My Public Profile",
									 "Following Tutors",
									 "Saved Articles",
									 "Term of Usage",
									 "About App",
									 "Logout",
									 "Delete Account"]
		
	private let topView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		
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
		tableView.isScrollEnabled = false
		tableView.separatorStyle = .none
		tableView.register(UserProfileListTableViewCell.self, forCellReuseIdentifier: UserProfileListTableViewCell.reuserIdentifier)
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
		super.viewWillAppear(true)
		fetchUserData()
		fetchFavoriteArticles()
		fetchFollowingTutors()
		
		navigationController?.navigationBar.isHidden = true
		tabBarController?.tabBar.isHidden = false
	}
	
	// MARK: - UI
	
	func setupUI() {
		
		view.addSubview(topView)
		topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 157)
		
		topView.addSubview(profileImageView)
		profileImageView.anchor(top: topView.topAnchor, left: topView.leftAnchor, paddingTop: 16, paddingLeft: 16)
				
		topView.addSubview(nameLabel)
		nameLabel.anchor(top: topView.topAnchor, left: profileImageView.rightAnchor, paddingTop: 24, paddingLeft: 16)
		
		topView.addSubview(tutorBadgeImageView)
		tutorBadgeImageView.centerY(inView: nameLabel, leftAnchor: nameLabel.rightAnchor, paddingLeft: 4)
//		tutorBadgeImageView.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -16).isActive = true
		
		topView.addSubview(universityLabel)
		universityLabel.anchor(top: nameLabel.bottomAnchor, left: profileImageView.rightAnchor, right: topView.rightAnchor,
							   paddingTop: 4, paddingLeft: 16, paddingRight: 16)
		
		topView.addSubview(editButton)
		editButton.anchor(top: universityLabel.bottomAnchor, left: profileImageView.rightAnchor, paddingTop: 16, paddingLeft: 16)
		
		topView.addSubview(changePhotoButton)
		changePhotoButton.anchor(top: universityLabel.bottomAnchor, left: editButton.rightAnchor, paddingTop: 16, paddingLeft: 12)
		
		topView.addSubview(dividerView)
		dividerView.anchor(top: editButton.bottomAnchor, left: topView.leftAnchor,
						   bottom: topView.bottomAnchor, right: topView.rightAnchor, paddingTop: 36, height: 1)
		
		view.addSubview(tableView)
		tableView.anchor(top: topView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
		
//		view.addSubview(beTutorButton)
//		beTutorButton.centerX(inView: view, topAnchor: topView.bottomAnchor, paddingTop: 24)
//
//		view.addSubview(logoutButton)
//		logoutButton.center(inView: view)
		
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
		var configuration = PHPickerConfiguration()
		configuration.selectionLimit = 1
		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = self
		self.present(picker, animated: true, completion: nil)
	}
	
	func handleLogout() {
		do {
			try Auth.auth().signOut()
		} catch let signOutError as NSError {
			print("Error signing out: %@", signOutError)
		}
		
		guard let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).flatMap({ $0.windows }).first(where: { $0.isKeyWindow }) else { return }
		
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
			case .failure(let error):
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
				print(error)
			}
		}
	}
	
	func configureUI() {
		guard let user = user else { return }
		let imageUrl = URL(string: user.profileImageURL)
		profileImageView.kf.setImage(with: imageUrl)
		nameLabel.text = user.name
		tutorBadgeImageView.isHidden = !user.isTutor
		universityLabel.text = user.school
	}
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 8
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileListTableViewCell.reuserIdentifier, for: indexPath)
				as? UserProfileListTableViewCell else { fatalError("Can not dequeue UserProfileListTableViewCell") }
		
		if indexPath.row == 7 {
			cell.titleLabel.textColor = .red
		} else if indexPath.row == 0 {
			cell.titleLabel.textColor = .green
		}
		cell.titleLabel.text = profileListText[indexPath.row]
		cell.iconImageView.image = profileListIcon[indexPath.row]
		return cell
	}
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let user = user else { return }
		switch indexPath.row {
		case 0:
			print("Choose to become tutor")
		case 1:
			let publicProfilePage = TutorProfileViewController(user: user, tutor: user)
			navigationController?.pushViewController(publicProfilePage, animated: true)
		case 2:
			let followingTutorVC = FollowingTutorViewController(followingTutors: followingTutors, user: user)
			navigationController?.pushViewController(followingTutorVC, animated: true)
		case 3:
			let savedArticleVC = ArticleListViewController(articles: favoriteArticles)
			navigationController?.pushViewController(savedArticleVC, animated: true)
		case 4:
			print("Term of usage")
		case 5:
			print("About app")
		case 6:
			handleLogout()
		case 7:
			print("Delete Account")
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
