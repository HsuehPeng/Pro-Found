//
//  WriteArticleViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import UIKit
import PhotosUI
import Kingfisher

class WriteArticleViewController: UIViewController {
	
	// MARK: - Properties
	
	let user: User

	private let topBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		
		let titleLabel = UILabel()
		titleLabel.text = "Write Article"
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
	
	private let articleImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .orange10
		imageView.layer.cornerRadius = 12
		imageView.setDimensions(width: 132, height: 200)
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private let articleTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: UIColor.dark, text: "Article Title")
		return label
	}()
	
	private let articleTitleTextField: UITextField = {
		let textField = UITextField()
		return textField
	}()
	
	private let articleTitleDividerView: UIView = {
		let dividerView = UIView()
		dividerView.backgroundColor = .dark20
		dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		return dividerView
	}()
	
	private let subjectTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: UIColor.dark, text: "Subject")
		return label
	}()
	
	private lazy var languageButton: UIButton = {
		let button = CustomUIElements().subjectSelectionButton(subject: Subject.language)
		button.addTarget(self, action: #selector(selectedSubject), for: .touchUpInside)
		return button
	}()
	
	private lazy var techButton: UIButton = {
		let button = CustomUIElements().subjectSelectionButton(subject: Subject.technology)
		button.addTarget(self, action: #selector(selectedSubject), for: .touchUpInside)
		return button
	}()
	
	private lazy var artButton: UIButton = {
		let button = CustomUIElements().subjectSelectionButton(subject: Subject.art)
		button.addTarget(self, action: #selector(selectedSubject), for: .touchUpInside)
		return button
	}()
	
	private lazy var musicButton: UIButton = {
		let button = CustomUIElements().subjectSelectionButton(subject: Subject.music)
		button.addTarget(self, action: #selector(selectedSubject), for: .touchUpInside)
		return button
	}()
	
	private lazy var sportButton: UIButton = {
		let button = CustomUIElements().subjectSelectionButton(subject: Subject.sport)
		button.addTarget(self, action: #selector(selectedSubject), for: .touchUpInside)
		return button
	}()
	
	private let articleTextView: ArticleTextView = {
		let textView = ArticleTextView()
		textView.isScrollEnabled = true
		return textView
	}()
	
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
		
		setupUI()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(topBarView)
		topBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 48)
		
		topBarView.addSubview(cancelButton)
		cancelButton.centerY(inView: topBarView, leftAnchor: topBarView.leftAnchor, paddingLeft: 18)
		
		view.addSubview(articleImageView)
		articleImageView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
		
		view.addSubview(articleTitleLabel)
		articleTitleLabel.anchor(top: topBarView.bottomAnchor, left: articleImageView.rightAnchor,
									right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(articleTitleTextField)
		articleTitleTextField.anchor(top: articleTitleLabel.bottomAnchor, left: articleImageView.rightAnchor,
									right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(articleTitleDividerView)
		articleTitleDividerView.anchor(top: articleTitleTextField.bottomAnchor, left: articleImageView.rightAnchor, right: view.rightAnchor,
									  paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(subjectTitleLabel)
		subjectTitleLabel.anchor(top: articleTitleDividerView.bottomAnchor, left: articleImageView.rightAnchor,
									right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		
		let topSubjectHStack = UIStackView(arrangedSubviews: [languageButton, techButton])
		topSubjectHStack.distribution = .fillEqually
		topSubjectHStack.spacing = 5
		view.addSubview(topSubjectHStack)
		topSubjectHStack.anchor(top: subjectTitleLabel.bottomAnchor, left: articleImageView.rightAnchor, right: view.rightAnchor,
								paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		let bottomSubjectHStack = UIStackView(arrangedSubviews: [musicButton, sportButton, artButton])
		bottomSubjectHStack.distribution = .fillEqually
		bottomSubjectHStack.spacing = 5
		view.addSubview(bottomSubjectHStack)
		bottomSubjectHStack.anchor(top: topSubjectHStack.bottomAnchor, left: articleImageView.rightAnchor, right: view.rightAnchor,
								paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(articleTextView)
		articleTextView.anchor(top: articleImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							   paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(bottomBarView)
		bottomBarView.anchor(top: articleTextView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
							 right: view.rightAnchor, height: 64)
		
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
	
	@objc func selectedSubject(_ sender: UIButton) {
		let buttons = [languageButton, techButton, artButton, musicButton, sportButton]
		
		switch sender {
		case languageButton:
			toggleSelectedSubjectButton(buttons: buttons, selectedButton: languageButton)
		case techButton:
			toggleSelectedSubjectButton(buttons: buttons, selectedButton: techButton)
		case artButton:
			toggleSelectedSubjectButton(buttons: buttons, selectedButton: artButton)
		case musicButton:
			toggleSelectedSubjectButton(buttons: buttons, selectedButton: musicButton)
		case sportButton:
			toggleSelectedSubjectButton(buttons: buttons, selectedButton: sportButton)
		default:
			break
		}
	}
	
	@objc func handlePickingImage() {
		var configuration = PHPickerConfiguration()
		configuration.selectionLimit = 1
		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = self
		self.present(picker, animated: true, completion: nil)
	}
	
	@objc func sendOutArticle() {
		let buttons = [languageButton, techButton, artButton, musicButton, sportButton]
		let selectedButton = buttons.filter({ $0.isSelected })
		
		guard let articleTitle = articleTitleTextField.text, !articleTitle.isEmpty,
			  let contentText = articleTextView.text, !contentText.isEmpty,
			  selectedButton.count > 0, let selectedSubject = selectedButton.first?.titleLabel?.text,
			  let articleImage = articleImageView.image else { return }
		
		let currentDate = Date()
		let interval = currentDate.timeIntervalSince1970
		ArticleService.shared.createAndDownloadImageURL(articleImage: articleImage, author: user) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let url):
				let imageURL = url
				let firestoreArticle = FirebaseArticle(userID: self.user.userID, articleTitle: articleTitle, authorName: self.user.name,
													   subject: selectedSubject, timestamp: interval, contentText: contentText, imageURL: imageURL, ratings: [])
				ArticleService.shared.uploadArticle(article: firestoreArticle)
				self.dismiss(animated: true)
			case .failure(let error):
				print(error)
			}
		}
	}
	
	@objc func dismissVC() {
		dismiss(animated: true)
	}
	
	// MARK: - Helpers
	
	func toggleSelectedSubjectButton(buttons: [UIButton], selectedButton: UIButton) {
		for i in 0...buttons.count - 1 {
			buttons[i].isSelected = false
			buttons[i].backgroundColor = .dark10
		}
		selectedButton.isSelected = true
		selectedButton.backgroundColor = .orange
	}
}

// MARK: - PHPickerViewControllerDelegate

extension WriteArticleViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true)
		let itemProviders = results.map(\.itemProvider)
		for item in itemProviders {
			if item.canLoadObject(ofClass: UIImage.self) {
				item.loadObject(ofClass: UIImage.self) { [weak self](image, error) in
					guard let self = self else { return }
					DispatchQueue.main.async {
						if let image = image as? UIImage {
							
							self.articleImageView.image = nil
							self.articleImageView.image = image
						}
					}
				}
			}
		}
	}
}
