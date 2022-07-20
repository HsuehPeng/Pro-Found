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
			configureTopBarView()
		}
	}
	
	var tutors = [User]()
	
	var filteredTutors = [User]() {
		didSet {
			collectionView.reloadData()
			
			if filteredTutors.isEmpty {
				collectionView.alpha = 0
				noCellView.indicatorLottie.loadingAnimation()
			} else {
				collectionView.alpha = 1
				noCellView.indicatorLottie.stopAnimation()
			}
		}
	}
	
	var isFiltered: Bool = false
	
	private lazy var refreshControl: UIRefreshControl = {
		let refresh = UIRefreshControl()
		refresh.addTarget(self, action: #selector(pullToRefresh), for: UIControl.Event.valueChanged)
		return refresh
	}()
	
	private let topBarView = UIView()
	
	private lazy var profilePhotoImageView: UIImageView = {
		let imageView = CustomUIElements().makeCircularProfileImageView(width: 36, height: 36)
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
		imageView.addGestureRecognizer(tap)
		imageView.isUserInteractionEnabled = true
		
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
		let button = makeGeneralButton(imageAsset: .chat, width: 32, height: 32)
		button.addTarget(self, action: #selector(goChatRoom), for: .touchUpInside)
		return button
	}()
	
	private lazy var filterButton: UIButton = {
		let button = makeGeneralButton(imageAsset: .filter, width: 24, height: 26)
		button.addTarget(self, action: #selector(subjectFilterPressed), for: .touchUpInside)
		return button
	}()
	
	private lazy var languageButton: UIButton = {
		let button = makeSubjectFilterButton(for: Subject.language)
		return button
	}()
	
	private lazy var techButton: UIButton = {
		let button = makeSubjectFilterButton(for: Subject.technology)
		return button
	}()
	
	private lazy var musicButton: UIButton = {
		let button = makeSubjectFilterButton(for: Subject.music)
		return button
	}()
	
	private lazy var sportButton: UIButton = {
		let button = makeSubjectFilterButton(for: Subject.sport)
		return button
	}()
	
	private lazy var artButton: UIButton = {
		let button = makeSubjectFilterButton(for: Subject.art)
		return button
	}()
	
	private var subjectButtonVStack = UIStackView()
	
	private var subjectButtonColletions: [UIButton] {
		get {
			return [languageButton, techButton, musicButton, sportButton, artButton]
		}
	}
	
	private let noCellView: EmptyIndicatorView = {
		let view = EmptyIndicatorView()
		view.indicatorLabel.text = "No Active Tutor"
		return view
	}()
	
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
		view.backgroundColor = .light60
		
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
		topBarView.addSubview(profilePhotoImageView)
		topBarView.addSubview(filterButton)
		topBarView.addSubview(chatRoomButton)
		view.addSubview(noCellView)
		view.addSubview(collectionView)
		
		topBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
		sixtyFour = topBarView.heightAnchor.constraint(equalToConstant: 55)
		sixtyFour?.isActive = true
		oneHundred = topBarView.heightAnchor.constraint(equalToConstant: 80)
		oneHundred?.isActive = false
		
		profilePhotoImageView.anchor(top: topBarView.topAnchor, left: topBarView.leftAnchor, paddingTop: 8, paddingLeft: 16)
		
		filterButton.anchor(top: topBarView.topAnchor, right: topBarView.rightAnchor, paddingTop: 8, paddingRight: 12)
		
		chatRoomButton.anchor(top: topBarView.topAnchor, right: filterButton.leftAnchor, paddingTop: 8, paddingRight: 12)
		
		let topBarLabelVStack = UIStackView(arrangedSubviews: [greetingLabel, nameLabel])
		topBarLabelVStack.spacing = 0
		topBarLabelVStack.axis = .vertical
		topBarView.addSubview(topBarLabelVStack)
		topBarLabelVStack.anchor(top: topBarView.topAnchor, left: profilePhotoImageView.rightAnchor, right: chatRoomButton.leftAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
		
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
		
		noCellView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
		
		collectionView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
		
		collectionView.addSubview(refreshControl)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
		tabBarController?.tabBar.isHidden = false
	}
	
	// MARK: - Actions
	
	@objc func goChatRoom() {
		guard let user = user else {
			popUpAskToLoginView()
			return
		}
		
		let chatRoomVC = ChatRoomViewController(user: user)
		navigationController?.pushViewController(chatRoomVC, animated: true)
	}
	
	@objc func subjectFilterPressed(_ sender: UIButton) {
		if isFiltered {
			hideFilterBar()
			filteredTutors = tutors
		} else {
			showFilterBar()
		}
	}
	
	@objc func subjectButtonPressed(_ sender: UIButton) {
		guard let titleLabel = sender.titleLabel else { return }
		
		switch titleLabel.text {
		case Subject.language.rawValue:
			
			toggleSelectedSubjectButton(buttons: subjectButtonColletions, selectedButton: languageButton)
			filteredTutors = tutors.filter({ $0.subject == Subject.language.rawValue })
			
		case Subject.technology.rawValue:
			
			toggleSelectedSubjectButton(buttons: subjectButtonColletions, selectedButton: techButton)
			filteredTutors = tutors.filter({ $0.subject == Subject.technology.rawValue })
			
		case Subject.art.rawValue:
			
			toggleSelectedSubjectButton(buttons: subjectButtonColletions, selectedButton: artButton)
			filteredTutors = tutors.filter({ $0.subject == Subject.art.rawValue })
			
		case Subject.sport.rawValue:
			
			toggleSelectedSubjectButton(buttons: subjectButtonColletions, selectedButton: sportButton)
			filteredTutors = tutors.filter({ $0.subject == Subject.sport.rawValue })
			
		case Subject.music.rawValue:
			
			toggleSelectedSubjectButton(buttons: subjectButtonColletions, selectedButton: musicButton)
			filteredTutors = tutors.filter({ $0.subject == Subject.music.rawValue })
			
		default:
			break
		}
	}
	
	@objc func handleProfileImageTapped() {
		guard let user = user else { return }
		let tutorProfileVC = TutorProfileViewController(user: user, tutor: user)
		navigationController?.pushViewController(tutorProfileVC, animated: true)
	}
	
	// MARK: - Helpers
	
	private func fetchUser() {
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
				self.showAlert(alertText: "Error", alertMessage: "Internate connection issue: \(error)")
			}
		}
	}
	
	private func fetchTutors() {
		guard let user = user else { return }
		
		UserServie.shared.getTutors { [weak self] result in
			guard let self = self else { return }
			
			switch result {
			case .success(let tutors):
				let filterOutBlockTutors = tutors.filter { !user.blockedUsers.contains($0.userID) }
				self.setTutorsFromSource(tutors: filterOutBlockTutors)
			case .failure(let error):
				self.showAlert(alertText: "Error", alertMessage: "Internate connection issue: \(error)")
			}
		}
	}
	
	private func configureTopBarView() {
		guard let user = user else { return }
		let imageUrl = URL(string: user.profileImageURL)
		nameLabel.text = "\(user.name)"
		profilePhotoImageView.kf.setImage(with: imageUrl)
	}
	
	private func toggleSelectedSubjectButton(buttons: [UIButton], selectedButton: UIButton) {
		for i in 0...buttons.count - 1 {
			buttons[i].isSelected = false
			buttons[i].backgroundColor = .dark10
		}
		selectedButton.isSelected = true
		selectedButton.backgroundColor = .orange
	}
	
	private func configureForNoUser() {
		UserServie.shared.getTutors { [weak self] result in
			guard let self = self else { return }
			
			switch result {
			case .success(let tutors):
				self.setTutorsFromSource(tutors: tutors)
			case .failure(let error):
				self.showAlert(alertText: "Error", alertMessage: "Internate connection issue: \(error)")
			}
		}
		nameLabel.text = "My Guest"
	}
	
	func hideFilterBar() {
		self.isFiltered = false
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
	}
	
	func showFilterBar() {
		self.isFiltered = true
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
	
	@objc func pullToRefresh() {
		guard let user = user else {
			UserServie.shared.getTutors { [weak self] result in
				guard let self = self else { return }
				
				switch result {
				case .success(let tutors):
					self.setTutorsFromSource(tutors: tutors)
					self.refreshControl.endRefreshing()
				case .failure(let error):
					self.showAlert(alertText: "Error", alertMessage: "Internet connection issue: \(error)")
					self.refreshControl.endRefreshing()
				}
			}
			return
		}
		
		UserServie.shared.getTutors { [weak self] result in
			guard let self = self else { return }
			
			switch result {
			case .success(let tutors):
				let filterOutBlockTutors = tutors.filter { !user.blockedUsers.contains($0.userID) }
				self.setTutorsFromSource(tutors: filterOutBlockTutors)
				self.refreshControl.endRefreshing()
			case .failure(let error):
				self.showAlert(alertText: "Error", alertMessage: "Internet connection issue: \(error)")
				self.refreshControl.endRefreshing()
			}
		}
	}
	
	private func setTutorsFromSource(tutors: [User]) {
		self.tutors = tutors
		self.filteredTutors = self.tutors
	}
	
	private func makeSubjectFilterButton(for subject: Subject) -> UIButton {
		let button = CustomUIElements().subjectSelectionButton(subject: subject)
		button.setTitle(subject.rawValue, for: .normal)
		button.addTarget(self, action: #selector(subjectButtonPressed), for: .touchUpInside)
		return button
	}
	
	private func makeGeneralButton(imageAsset: ImageAsset, width: CGFloat, height: CGFloat) -> UIButton {
		let button = UIButton()
		let image = UIImage.asset(imageAsset)?.withRenderingMode(.alwaysOriginal).withTintColor(.dark40)
		button.setImage(image, for: .normal)
		button.setDimensions(width: width, height: height)
		return button
	}
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return filteredTutors.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let tutorCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePageTutorCollectionViewCell.reuseIdentifier, for: indexPath)
				as? HomePageTutorCollectionViewCell else { fatalError("Can not dequeue HomePageTutorCollectionViewCell") }
		tutorCell.tutor = filteredTutors[indexPath.item]
		return tutorCell
	}

}

// MARK: - UITableViewDataSource

extension HomeViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let user = user else {
			popUpAskToLoginView()
			return
		}
		
		let tutor = filteredTutors[indexPath.item]
		let tutorProfileVC = TutorProfileViewController(user: user, tutor: tutor)
		navigationController?.pushViewController(tutorProfileVC, animated: true)
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GeneralHeaderCollectionReusableView.reuseIdentifier, for: indexPath)
				as? GeneralHeaderCollectionReusableView else { fatalError("Can not dequeue GeneralHeaderCollectionReusableView") }
		header.actionButton.isHidden = true
		header.titleLabel.text = "Explore Tutors..."
		return header
	}
}
