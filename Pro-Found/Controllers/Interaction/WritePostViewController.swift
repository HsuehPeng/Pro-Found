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
	
	var postVideoData: Data?
	
	var postVideoURL: URL?
	
	private let topBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .light60
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
		let imageView = CustomUIElements().makeCircularProfileImageView(width: 42, height: 42)
		return imageView
	}()
	
	private lazy var segmentedControl: UISegmentedControl = {
		let control = UISegmentedControl(items: ["Photos", "Video"])
		control.selectedSegmentIndex = 0
		control.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
		control.selectedSegmentTintColor = .orange10
		control.setDimensions(width: 160, height: 35)
	
		return control
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
		view.backgroundColor = .light60
		
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
		let button = CustomUIElements().makeMediumButton(buttonColor: .orange, buttonTextColor: .light60, borderColor: .clear, buttonText: "Post")
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
		view.backgroundColor = .light60
		
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
		postTextView.heightAnchor.constraint(equalToConstant: 300).isActive = true
		
		view.addSubview(segmentedControl)
		segmentedControl.centerX(inView: view, topAnchor: postTextView.bottomAnchor, paddingTop: 8)
		
		view.addSubview(collectionView)
		view.addSubview(bottomBarView)
		collectionView.anchor(top: segmentedControl.bottomAnchor, left: view.leftAnchor, bottom: bottomBarView.topAnchor,
							  right: view.rightAnchor, paddingTop: 8, paddingBottom: 16)
		
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
	
	@objc func handleSegmentChange() {
		if segmentedControl.selectedSegmentIndex == 0 {
			postVideoData = nil
			postVideoURL = nil
			collectionView.reloadData()
		} else {
			postImageViews = []
			collectionView.reloadData()
		}
	}
	
	@objc func handlePickingImage() {
		var configuration = PHPickerConfiguration()
		configuration.filter = .any(of: [.images, .livePhotos, .videos])
		
		if segmentedControl.selectedSegmentIndex == 0 {
			configuration.selectionLimit = 5
			configuration.filter = .any(of: [.images, .livePhotos])
		} else {
			configuration.selectionLimit = 1
			configuration.filter = .any(of: [.videos])
		}
		
		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = self

		if let sheet = picker.presentationController as? UISheetPresentationController {
			sheet.detents = [.medium()]
			sheet.preferredCornerRadius = 25
		}
		
		self.present(picker, animated: true, completion: nil)
	}
	
	@objc func sendOutArticle() {
		guard let postText = postTextView.text, !postText.isEmpty else {
			popUpMissingInputVC()
			return
		}
		let date = Date()
		let timestamp = date.timeIntervalSince1970
		
		let loadingLottie = Lottie(superView: self.view, animationView: AnimationView.init(name: "loadingAnimation"))
		loadingLottie.loadingAnimation()
		
		if segmentedControl.selectedSegmentIndex == 0 {
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
			
		} else {
			
			guard let postVideoData = postVideoData else {
				let firebasepost = FirebasePosts(userID: self.user.userID, contentText: postText, likes: 0,
												 timestamp: timestamp, likedBy: [], imagesURL: [])
				
				PostService.shared.uploadPost(firebasePost: firebasepost) { [weak self] in
					guard let self = self else { return }
					loadingLottie.stopAnimation()
					self.dismiss(animated: true)
				}
				return
			}
			
			PostService.shared.createAndDownloadVideoURL(postVideo: postVideoData, postUser: user) { [weak self] result in
				guard let self = self else { return }
				switch result {
				case .success(let url):
					let firebasepost = FirebasePosts(userID: self.user.userID, contentText: postText, likes: 0,
													 timestamp: timestamp, likedBy: [], imagesURL: [], videoURL: url)
					PostService.shared.uploadPost(firebasePost: firebasepost) { [weak self] in
						guard let self = self else { return }
						loadingLottie.stopAnimation()
						self.dismiss(animated: true)
					}
				case .failure(let error):
					self.showAlert(alertText: "Error", alertMessage: "Internate connection issue")
					print(error)
				}
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
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
		
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .continuous
		
		let layout = UICollectionViewCompositionalLayout(section: section)
		return layout
	}
}

extension WritePostViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if segmentedControl.selectedSegmentIndex == 0 {
			if postImageViews.count <= 5 {
				return postImageViews.count
			} else {
				return 5
			}
		} else {
			return postVideoURL == nil ? 0 : 1
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChooseSubjectUICollectionViewCell.reuseIdentifier, for: indexPath)
				as? ChooseSubjectUICollectionViewCell else { fatalError("Can not dequeue ChooseSubjectUICollectionViewCell") }
		if segmentedControl.selectedSegmentIndex == 0 {
			cell.subjectImageView.image = postImageViews[indexPath.item]
		} else {
			cell.videoURL = postVideoURL
		}
		return cell
	}
}

// MARK: - PHPickerViewControllerDelegate

extension WritePostViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		let loadingLottie = Lottie(superView: self.view, animationView: AnimationView.init(name: "loadingAnimation"))
		
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
			} else if item.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
				loadingLottie.loadingAnimation()
				item.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] url, error in
					guard let self = self, let url = url else { return }
					
					DispatchQueue.main.sync {
						let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
						
						self.compressVideo(inputURL: url, outputURL: compressedURL) { exportSession in
							let smallData = try? Data(contentsOf: compressedURL)
							self.postVideoData = smallData
						}
						
						self.postVideoURL = url
						self.collectionView.reloadSections([0])
						
						loadingLottie.stopAnimation()
					}
				}
			}
		}
	}
	
	func compressVideo(inputURL: URL,
					   outputURL: URL,
					   handler:@escaping (_ exportSession: AVAssetExportSession?) -> Void) {
		let urlAsset = AVURLAsset(url: inputURL, options: nil)
		guard let exportSession = AVAssetExportSession(asset: urlAsset,
													   presetName: AVAssetExportPresetMediumQuality) else {
			handler(nil)

			return
		}

		exportSession.outputURL = outputURL
		exportSession.outputFileType = .mp4
		exportSession.exportAsynchronously {
			handler(exportSession)
		}
	}

}
