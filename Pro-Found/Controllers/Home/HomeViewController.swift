//
//  HomeViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import UIKit
import Kingfisher
import FirebaseAuth

class HomeViewController: UIViewController {

	// MARK: - Properties
	
	var user: User? {
		didSet {
			configure()
		}
	}
	
	var tutors: [User]?
	
	var filteredTutors: [User]? {
		didSet {
			collectionView.reloadData()
		}
	}
	
	var isFiltered: Bool = false
	
	private lazy var refreshControl: UIRefreshControl = {
		let refresh = UIRefreshControl()
		refresh.addTarget(self, action: #selector(pullToRefresh), for: UIControl.Event.valueChanged)
		return refresh
	}()
	
	private let topBarView: UIView = {
		let view = UIView()
		return view
	}()
	
	private let profilePhotoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .gray
		imageView.setDimensions(width: 36, height: 36)
		imageView.layer.cornerRadius = 36 / 2
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private let greetingLabel: UILabel = {
		
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
											   textColor: UIColor.dark40, text: "Welcome back,")
		return label
	}()
	
	private let nameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 14),
											   textColor: UIColor.dark, text: "")
		return label
	}()
	
	private lazy var chatRoomButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.asset(.chat)?.withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(goChatRoom), for: .touchUpInside)
		button.setDimensions(width: 32, height: 32)
		return button
	}()
	
	private lazy var filterButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.asset(.filter)?.withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(subjectFilterPressed), for: .touchUpInside)
		button.setDimensions(width: 24, height: 26)
		return button
	}()
	
	private lazy var languageButton: UIButton = {
		let button = CustomUIElements().subjectSelectionButton(subject: Subject.music)
		button.setTitle("Language", for: .normal)
		button.addTarget(self, action: #selector(subjectButtonPressed), for: .touchUpInside)
		return button
	}()
	
	private lazy var techButton: UIButton = {
		let button = CustomUIElements().subjectSelectionButton(subject: Subject.music)

		button.setTitle("Technology", for: .normal)
		button.addTarget(self, action: #selector(subjectButtonPressed), for: .touchUpInside)
		return button
	}()
	
	private lazy var musicButton: UIButton = {
		let button = CustomUIElements().subjectSelectionButton(subject: Subject.music)

		button.setTitle("Music", for: .normal)
		button.addTarget(self, action: #selector(subjectButtonPressed), for: .touchUpInside)
		return button
	}()
	
	private lazy var sportButton: UIButton = {
		let button = CustomUIElements().subjectSelectionButton(subject: Subject.music)

		button.setTitle("Sport", for: .normal)
		button.addTarget(self, action: #selector(subjectButtonPressed), for: .touchUpInside)
		return button
	}()
	
	private lazy var artButton: UIButton = {
		let button = CustomUIElements().subjectSelectionButton(subject: Subject.music)

		button.setTitle("Art", for: .normal)
		button.addTarget(self, action: #selector(subjectButtonPressed), for: .touchUpInside)
		return button
	}()
	
	private var subjectButtonVStack = UIStackView()
	
	private var subjectButtonColletions: [UIButton] {
		get {
			return [languageButton, techButton, musicButton, sportButton, artButton]
		}
	}
	
	private lazy var collectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		flowLayout.itemSize = CGSize(width: view.frame.size.width, height: 280)
		flowLayout.minimumInteritemSpacing = 20
		flowLayout.minimumLineSpacing = 20
		flowLayout.headerReferenceSize = CGSize(width: view.frame.size.width, height: 50)
		collectionView.register(HomePageTutorCollectionViewCell.self, forCellWithReuseIdentifier: HomePageTutorCollectionViewCell.reuseIdentifier)
		collectionView.register(GeneralHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
								withReuseIdentifier: GeneralHeaderCollectionReusableView.reuseIdentifier)
		return collectionView
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		collectionView.dataSource = self
		collectionView.delegate = self
		
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavBar()
		fetchUser()
	}
	
	var sixtyFour: NSLayoutConstraint?
	var oneHundred: NSLayoutConstraint?
	
	// MARK: - UI
	
	func setupUI() {
		
		view.addSubview(topBarView)
		topBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
		sixtyFour = topBarView.heightAnchor.constraint(equalToConstant: 55)
		sixtyFour?.isActive = true
		oneHundred = topBarView.heightAnchor.constraint(equalToConstant: 80)
		oneHundred?.isActive = false
		
		topBarView.addSubview(profilePhotoImageView)
		profilePhotoImageView.anchor(top: topBarView.topAnchor, left: topBarView.leftAnchor, paddingTop: 8, paddingLeft: 16)
		
		let topBarLabelVStack = UIStackView(arrangedSubviews: [greetingLabel, nameLabel])
		topBarLabelVStack.spacing = 0
		topBarLabelVStack.axis = .vertical
		topBarView.addSubview(topBarLabelVStack)
		topBarLabelVStack.anchor(top: topBarView.topAnchor, left: profilePhotoImageView.rightAnchor, paddingTop: 8, paddingLeft: 12)
		
		topBarView.addSubview(filterButton)
		filterButton.anchor(top: topBarView.topAnchor, right: topBarView.rightAnchor, paddingTop: 8, paddingRight: 12)
		
		topBarView.addSubview(chatRoomButton)
		chatRoomButton.anchor(top: topBarView.topAnchor, right: filterButton.leftAnchor, paddingTop: 8, paddingRight: 12)
		
		subjectButtonColletions.forEach { button in
			button.isHidden = true
			button.alpha = 0
			subjectButtonVStack.addArrangedSubview(button)
		}
		subjectButtonVStack.axis = .horizontal
		subjectButtonVStack.spacing = 6
		subjectButtonVStack.distribution = .fillEqually
		topBarView.addSubview(subjectButtonVStack)
		subjectButtonVStack.anchor(top: profilePhotoImageView.bottomAnchor, left: topBarView.leftAnchor,
								   right: topBarView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8)
		
		view.addSubview(collectionView)
		collectionView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
		
		collectionView.addSubview(refreshControl)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
		tabBarController?.tabBar.isHidden = false
	}
	
	// MARK: - Actions
	
	@objc func goChatRoom() {
		let chatRoomVC = ChatRoomViewController()
		navigationController?.pushViewController(chatRoomVC, animated: true)
	}
	
	@objc func subjectFilterPressed(_ sender: UIButton) {
		if isFiltered {
			isFiltered = false
			filteredTutors = tutors
			self.oneHundred?.isActive = false
			self.sixtyFour?.isActive = true
			subjectButtonColletions.forEach { button in
				UIView.animate(withDuration: 0.4) {
					button.isHidden = !button.isHidden
					button.isSelected = false
					button.backgroundColor = .dark10
					button.alpha = 0
					button.layoutIfNeeded()
				}
			}
		} else {
			isFiltered = true
			self.sixtyFour?.isActive = false
			self.oneHundred?.isActive = true
			subjectButtonColletions.forEach { button in
				UIView.animate(withDuration: 0.4) {
					button.isHidden = !button.isHidden
					button.alpha = 1
					button.layoutIfNeeded()
				}
			}
		}
	}
	
	@objc func subjectButtonPressed(_ sender: UIButton) {
		guard let titleLabel = sender.titleLabel, let tutors = tutors else { return }
		switch titleLabel.text {
		case Subject.language.rawValue:
			toggleSelectedSubjectButton(buttons: subjectButtonColletions, selectedButton: languageButton)
			filteredTutors = tutors.filter({ tutor in
				tutor.subject == Subject.language.rawValue
			})
		case Subject.technology.rawValue:
			toggleSelectedSubjectButton(buttons: subjectButtonColletions, selectedButton: techButton)
			filteredTutors = tutors.filter({ tutor in
				tutor.subject == Subject.technology.rawValue
			})
		case Subject.art.rawValue:
			toggleSelectedSubjectButton(buttons: subjectButtonColletions, selectedButton: artButton)
			filteredTutors = tutors.filter({ tutor in
				tutor.subject == Subject.art.rawValue
			})
		case Subject.sport.rawValue:
			toggleSelectedSubjectButton(buttons: subjectButtonColletions, selectedButton: sportButton)
			filteredTutors = tutors.filter({ tutor in
				tutor.subject == Subject.sport.rawValue
			})
		case Subject.music.rawValue:
			toggleSelectedSubjectButton(buttons: subjectButtonColletions, selectedButton: musicButton)
			filteredTutors = tutors.filter({ tutor in
				tutor.subject == Subject.music.rawValue
			})
		default:
			break
		}
	}
	
	// MARK: - Helpers
	
	func fetchUser() {
		guard let uid = Auth.auth().currentUser?.uid else {
			configureForNoUser()
			return
		}
		
		UserServie.shared.getUserData(uid: uid) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let user):
				self.user = user
				self.fetchTutors()
			case .failure(let error):
				print(error)
			}
		}
	}
	
	func fetchTutors() {
		guard let user = user else { return }
		
		UserServie.shared.getTutors { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let tutors):
				// Filter out blocked tutors
				let filterOutBlockTutors = tutors.filter { !user.blockedUsers.contains($0.userID) }
				self.tutors = filterOutBlockTutors
				self.filteredTutors = self.tutors
			case .failure(let error):
				print("Error getting tutors: \(error)")
			}
		}
	}
	
	func configure() {
		guard let user = user else { return }
		let imageUrl = URL(string: user.profileImageURL)
		nameLabel.text = "\(user.name)"
		profilePhotoImageView.kf.setImage(with: imageUrl)
	}
	
	func toggleSelectedSubjectButton(buttons: [UIButton], selectedButton: UIButton) {
		for i in 0...buttons.count - 1 {
			buttons[i].isSelected = false
			buttons[i].backgroundColor = .dark10
		}
		selectedButton.isSelected = true
		selectedButton.backgroundColor = .orange
	}
	
	func configureForNoUser() {
		UserServie.shared.getTutors { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let tutors):
				self.tutors = tutors
				self.filteredTutors = self.tutors
			case .failure(let error):
				print("Error getting tutors: \(error)")
			}
		}
		nameLabel.text = "My Guest"
	}
	
	@objc func pullToRefresh() {
		guard let user = user else {
			UserServie.shared.getTutors { [weak self] result in
				guard let self = self else { return }
				switch result {
				case .success(let tutors):
					self.tutors = tutors
					self.filteredTutors = self.tutors
					self.refreshControl.endRefreshing()
				case .failure(let error):
					print("Error getting tutors: \(error)")
				}
			}
			return
		}
		
		UserServie.shared.getTutors { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let tutors):
				// Filter out blocked tutors
				let filterOutBlockTutors = tutors.filter { !user.blockedUsers.contains($0.userID) }
				self.tutors = filterOutBlockTutors
				self.filteredTutors = self.tutors
				self.refreshControl.endRefreshing()
			case .failure(let error):
				print("Error getting tutors: \(error)")
			}
		}
	}
	
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let filteredTutors = filteredTutors else { return 0 }
		return filteredTutors.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let tutorCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePageTutorCollectionViewCell.reuseIdentifier, for: indexPath)
				as? HomePageTutorCollectionViewCell else { fatalError("Can not dequeue HomePageTutorCollectionViewCell") }
		guard let filteredTutors = filteredTutors else { return tutorCell }
		tutorCell.tutor = filteredTutors[indexPath.item]
		return tutorCell
	}

}

// MARK: - UITableViewDataSource

extension HomeViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let user = user, let filteredTutor = filteredTutors else {
			let popUpAskToLoginVC = PopUpAskToLoginController()
			popUpAskToLoginVC.modalTransitionStyle = .crossDissolve
			popUpAskToLoginVC.modalPresentationStyle = .overCurrentContext
			present(popUpAskToLoginVC, animated: true)
			return
		}
		let tutor = filteredTutor[indexPath.item]
		let tutorProfileVC = TutorProfileViewController(user: user, tutor: tutor)
		navigationController?.pushViewController(tutorProfileVC, animated: true)
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GeneralHeaderCollectionReusableView.reuseIdentifier, for: indexPath)
				as? GeneralHeaderCollectionReusableView else { fatalError("Can not dequeue GeneralHeaderCollectionReusableView") }
		header.articleListDelagate = self
		header.actionButton.isHidden = true
		header.titleLabel.text = "Explore Tutors..."
		return header
	}
}

extension HomeViewController: GeneralHeaderCollectionReusableViewDelegate {
	func filterByTutorSubject(_ cell: GeneralHeaderCollectionReusableView) {
		
	}
	
}


