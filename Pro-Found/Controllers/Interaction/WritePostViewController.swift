//
//  WritePostViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/17.
//

import UIKit
import Kingfisher
import Lottie
import PhotosUI

class WritePostViewController: UIViewController {
	
	// MARK: - Properties
	
	let user: User
	
	var postImageViews = [UIImage]()
	
	private let topBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		
		let titleLabel = UILabel()
		titleLabel.text = "Write Post"
		titleLabel.font = UIFont.customFont(.interBold, size: 16)
		titleLabel.textColor = .dark
		view.addSubview(titleLabel)
		titleLabel.center(inView: view)
		
		return view
	}()
	
	private lazy var cancelButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.asset(.close), for: .normal)
		button.setDimensions(width: 24, height: 24)
		button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
		return button
	}()
	
	private let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .gray
		imageView.setDimensions(width: 42, height: 42)
		imageView.layer.cornerRadius = 42 / 2
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
		collectionView.register(ChooseSubjectUICollectionViewCell.self,
								forCellWithReuseIdentifier: ChooseSubjectUICollectionViewCell.reuseIdentifier)
		return collectionView
	}()
	
	private let postTextView = CaptionTextView()
	
	private let bottomBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		
		let dividerView = UIView()
		dividerView.backgroundColor = .dark20
		view.addSubview(dividerView)
		dividerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 1)
		
		return view
	}()
	
	private lazy var pickImageButton: UIButton = {
		let button = UIButton()
		button.setDimensions(width: 24, height: 24)
		button.setImage(UIImage.asset(.photo), for: .normal)
		button.addTarget(self, action: #selector(handlePickingImage), for: .touchUpInside)
		return button
	}()
	
	private lazy var postButton: UIButton = {
		let button = CustomUIElements().makeMediumButton(buttonColor: .orange, buttonTextColor: .white, borderColor: .clear, buttonText: "Post")
		button.widthAnchor.constraint(equalToConstant: 90).isActive = true
		button.addTarget(self, action: #selector(sendOutArticle), for: .touchUpInside)
		
		return button
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
		view.backgroundColor = .white
		
		collectionView.dataSource = self
		
		setupUI()
		configureUI()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(topBarView)
		topBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 48)
		
		topBarView.addSubview(cancelButton)
		cancelButton.centerY(inView: topBarView, leftAnchor: topBarView.leftAnchor, paddingLeft: 18)
		
		view.addSubview(profileImageView)
		profileImageView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 16)
		
		view.addSubview(postTextView)
		postTextView.anchor(top: topBarView.bottomAnchor, left: profileImageView.rightAnchor, right: view.rightAnchor,
							paddingTop: 12, paddingLeft: 12, paddingRight: 16)
		postTextView.heightAnchor.constraint(equalToConstant: 350).isActive = true
		
		view.addSubview(collectionView)
		view.addSubview(bottomBarView)
		collectionView.anchor(top: postTextView.bottomAnchor, left: view.leftAnchor, bottom: bottomBarView.topAnchor,
							  right: view.rightAnchor, paddingBottom: 16)
		
		bottomBarView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, height: 64)
		
		let actionButtonHStack = UIStackView(arrangedSubviews: [
			pickImageButton
		])
		actionButtonHStack.axis = .horizontal
		actionButtonHStack.spacing = 24
		bottomBarView.addSubview(actionButtonHStack)
		actionButtonHStack.centerY(inView: bottomBarView, leftAnchor: bottomBarView.leftAnchor, paddingLeft: 16)
		
		bottomBarView.addSubview(postButton)
		postButton.centerY(inView: bottomBarView)
		postButton.rightAnchor.constraint(equalTo: bottomBarView.rightAnchor, constant: -16).isActive = true
	}
	
	// MARK: - Actions
	
	@objc func handlePickingImage() {
		var configuration = PHPickerConfiguration()
		configuration.selectionLimit = 5
		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = self
		
		if let sheet = picker.presentationController as? UISheetPresentationController {
			sheet.detents = [.medium()]
			sheet.preferredCornerRadius = 25
		}
		self.present(picker, animated: true, completion: nil)
	}
	
	@objc func sendOutArticle() {
		guard let postText = postTextView.text else { return }
		let date = Date()
		let timestamp = date.timeIntervalSince1970
		
		let loadingLottie = Lottie(superView: self.view, animationView: AnimationView.init(name: "loadingAnimation"))
		loadingLottie.loadingAnimation()
		
		PostService.shared.createAndDownloadImageURLs(postImages: postImageViews,
													  postUser: user) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let imageURLs):
				let firebasepost = FirebasePosts(userID: self.user.userID, contentText: postText, likes: 0,
												 timestamp: timestamp, likedBy: [], imagesURL: imageURLs)

				
				PostService.shared.uploadPost(firebasePost: firebasepost) { [weak self] in
					guard let self = self else { return }
					loadingLottie.stopAnimation()
					self.dismiss(animated: true)
				}
			case .failure(let error):
				print(error)
			}
		}
	}
	
	@objc func dismissVC() {
		dismiss(animated: true)
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		guard let imageUrl = URL(string: user.profileImageURL) else { return }
		profileImageView.kf.setImage(with: imageUrl)
	}
	
	func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75), heightDimension: .fractionalHeight(1))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
		
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .continuous
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
		
		let layout = UICollectionViewCompositionalLayout(section: section)
		return layout
	}
}

extension WritePostViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if postImageViews.count <= 5 {
			return postImageViews.count
		} else {
			return 5
		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChooseSubjectUICollectionViewCell.reuseIdentifier, for: indexPath)
				as? ChooseSubjectUICollectionViewCell else { fatalError("Can not dequeue ChooseSubjectUICollectionViewCell") }
		cell.subjectImageView.image = postImageViews[indexPath.item]
		return cell
	}
}

// MARK: - PHPickerViewControllerDelegate

extension WritePostViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true)
		let itemProviders = results.map(\.itemProvider)
		for item in itemProviders {
			if item.canLoadObject(ofClass: UIImage.self) {
				item.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
					guard let self = self else { return }
					DispatchQueue.main.async {
						if let image = image as? UIImage {
							self.postImageViews.append(image)
							self.collectionView.reloadSections([0])
						}
					}
				}
			}
		}
	}
}
