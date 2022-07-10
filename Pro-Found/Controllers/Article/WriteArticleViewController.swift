//
//  WriteArticleViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import UIKit
import PhotosUI
import Kingfisher
import Lottie
import IQKeyboardManagerSwift

class WriteArticleViewController: UIViewController {
	
	// MARK: - Properties
	
	let user: User
	
	var htmlText = ""
	
	var currentTextType: TextFormateType = TextFormateType.heading1
	
	var currentAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: TextFormateType.heading1.font] {
		didSet {
			articleTextView.typingAttributes = currentAttribute
		}
	}
	
	var kbHeight: CGFloat = 0.0
	
	private let topBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .light60
		
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
		textView.autocorrectionType = .no
		return textView
	}()
	
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
		button.setDimensions(width: 36, height: 36)
		button.setImage(UIImage.asset(.add_circle)?.withRenderingMode(.alwaysOriginal).withTintColor(.orange), for: .normal)
		button.addTarget(self, action: #selector(handlePickingImage), for: .touchUpInside)
		return button
	}()
	
	private let characterCountLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: .dark40, text: "")
		return label
	}()
	
	private lazy var postButton: UIButton = {
		let button = CustomUIElements().makeMediumButton(buttonColor: .orange, buttonTextColor: .light60, borderColor: .clear, buttonText: "Post")
		button.widthAnchor.constraint(equalToConstant: 90).isActive = true
		button.addTarget(self, action: #selector(sendOutArticle), for: .touchUpInside)
		return button
	}()
	
	private lazy var toolBar: UIToolbar = {
		let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
		return toolBar
	}()
	
	private lazy var doneButton: UIBarButtonItem = {
		let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneKBEditing))
		button.width = view.frame.size.width / 4
		return button
	}()
	
	private lazy var textFormateButton: UIBarButtonItem = {
		let button = UIBarButtonItem(image: UIImage(systemName: "textformat.alt"), style: .plain, target: self,
									 action: #selector(handleTextFormate))
		button.tintColor = TextFormateColor.dark.color
		button.width = view.frame.size.width / 4
		return button
	}()
	
	var textFormateViewHeight = NSLayoutConstraint()
	
	private lazy var textFormateView: ListMenuView = {
		let listView = ListMenuView()
		view.addSubview(listView)
		listView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 110)
		listView.translatesAutoresizingMaskIntoConstraints = false
		listView.widthAnchor.constraint(equalToConstant: textFormateButton.width).isActive = true
		textFormateViewHeight = listView.heightAnchor.constraint(equalToConstant: 0)
		listView.textFormateOptions = [TextFormateType.heading1,
									   TextFormateType.heading2,
									   TextFormateType.title1,
									   TextFormateType.title2,
									   TextFormateType.text]
		listView.delegate = self
		return listView
	}()

	private lazy var textColorButton: UIBarButtonItem = {
		let button = UIBarButtonItem(image: UIImage(systemName: "paintbrush.pointed"), style: .plain, target: self,
									 action: #selector(handleTextFormate))
		button.tintColor = TextFormateColor.dark.color
		button.width = view.frame.size.width / 4
		return button
	}()
	
	var textColorListViewHeight = NSLayoutConstraint()
	
	private lazy var textColorListView: ListMenuView = {
		let listView = ListMenuView()
		view.addSubview(listView)
		listView.anchor(left: textFormateView.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 110)
		listView.translatesAutoresizingMaskIntoConstraints = false
		listView.widthAnchor.constraint(equalToConstant: textColorButton.width).isActive = true
		textColorListViewHeight = listView.heightAnchor.constraint(equalToConstant: 0)
		listView.textColorOptions = [TextFormateColor.red,
									 TextFormateColor.green,
									 TextFormateColor.dark,
									 TextFormateColor.orange,
									 TextFormateColor.light,
									 TextFormateColor.skyblue
		]
		listView.delegate = self
		return listView
	}()
	
	private lazy var italicButton: UIBarButtonItem = {
		let image  = UIImage.asset(.italic)
		let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleItalic))
		button.tintColor = TextFormateColor.dark.color
		button.isSelected = false
		button.width = view.frame.size.width / 4
		return button
	}()
	
	private var KeyboardHeightVar: CGFloat = 0.0
	
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
		
		articleTextView.delegate = self
		
		IQKeyboardManager.shared.enableAutoToolbar = false
		
		setupUI()
		setupKBToolBar()
		
		currentAttribute[.font] = currentTextType.font
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardEvent), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardEvent), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		IQKeyboardManager.shared.enableAutoToolbar = true
	}
	
	// MARK: - UI
	
	func setupUI() {
		
		view.addSubview(topBarView)
				
		view.addSubview(bottomBarView)
		
		topBarView.addSubview(cancelButton)
		
		view.addSubview(articleImageView)
		
		view.addSubview(pickImageButton)
		
		view.addSubview(articleTitleLabel)
		
		view.addSubview(articleTitleTextField)
		
		view.addSubview(articleTitleDividerView)
		
		view.addSubview(subjectTitleLabel)
		
		bottomBarView.addSubview(postButton)
		
		bottomBarView.addSubview(characterCountLabel)
		
		let topSubjectHStack = UIStackView(arrangedSubviews: [languageButton, techButton])
		topSubjectHStack.distribution = .fillEqually
		topSubjectHStack.spacing = 5
		view.addSubview(topSubjectHStack)
		
		let bottomSubjectHStack = UIStackView(arrangedSubviews: [musicButton, sportButton, artButton])
		bottomSubjectHStack.distribution = .fillEqually
		bottomSubjectHStack.spacing = 5
		view.addSubview(bottomSubjectHStack)
		
		view.addSubview(articleTextView)
		
		topBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 48)
				
		cancelButton.centerY(inView: topBarView, leftAnchor: topBarView.leftAnchor, paddingLeft: 18)
		
		articleImageView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
		
		pickImageButton.anchor(bottom: articleImageView.bottomAnchor, right: articleImageView.rightAnchor, paddingBottom: -10, paddingRight: -10)
		
		articleTitleLabel.anchor(top: topBarView.bottomAnchor, left: articleImageView.rightAnchor,
									right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		
		articleTitleTextField.anchor(top: articleTitleLabel.bottomAnchor, left: articleImageView.rightAnchor,
									right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		articleTitleDividerView.anchor(top: articleTitleTextField.bottomAnchor, left: articleImageView.rightAnchor, right: view.rightAnchor,
									  paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		subjectTitleLabel.anchor(top: articleTitleDividerView.bottomAnchor, left: articleImageView.rightAnchor,
									right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		

		topSubjectHStack.anchor(top: subjectTitleLabel.bottomAnchor, left: articleImageView.rightAnchor, right: view.rightAnchor,
								paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		

		bottomSubjectHStack.anchor(top: topSubjectHStack.bottomAnchor, left: articleImageView.rightAnchor, right: view.rightAnchor,
								paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		
		
		articleTextView.anchor(top: articleImageView.bottomAnchor, left: view.leftAnchor, bottom: bottomBarView.topAnchor, right: view.rightAnchor,
							   paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
		
		bottomBarView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
							 right: view.rightAnchor, height: 64)
		
		postButton.centerY(inView: bottomBarView)
		postButton.rightAnchor.constraint(equalTo: bottomBarView.rightAnchor, constant: -16).isActive = true
		
		
		characterCountLabel.centerY(inView: bottomBarView)
		characterCountLabel.rightAnchor.constraint(equalTo: postButton.leftAnchor, constant: -16).isActive = true
	}
	
	func setupKBToolBar() {
		
		toolBar.items = [textFormateButton, textColorButton, italicButton, doneButton]
		toolBar.sizeToFit()
		articleTextView.inputAccessoryView = toolBar
	}
	
	// MARK: - Actions
	
	@objc func keyboardEvent(_ notification: Notification) {
		guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		let keyboardScreenEndFrame: CGRect = keyboardFrame.cgRectValue
		
		let keyboardViewEndFrame: CGRect = view.convert(keyboardScreenEndFrame, to: view.window)
		kbHeight = keyboardViewEndFrame.height
		print(keyboardViewEndFrame.height)
	}

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
	
	@objc func sendOutArticle() {
		let buttons = [languageButton, techButton, artButton, musicButton, sportButton]
		let selectedButton = buttons.filter({ $0.isSelected })
		
		guard let articleTitle = articleTitleTextField.text, !articleTitle.isEmpty,
			  let contentText = articleTextView.text, !contentText.isEmpty,
			  selectedButton.count > 0, let selectedSubject = selectedButton.first?.titleLabel?.text,
			  let articleImage = articleImageView.image else {
			
			let missingInputVC = MissingInputViewController()
			missingInputVC.modalTransitionStyle = .crossDissolve
			missingInputVC.modalPresentationStyle = .overCurrentContext
			present(missingInputVC, animated: true)
			return
		}
		
		convertAttributeStringToHtml()

		let loadingAnimation = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		loadingAnimation.loadingAnimation()
		let currentDate = Date()
		let interval = currentDate.timeIntervalSince1970
		ArticleService.shared.createAndDownloadImageURL(articleImage: articleImage, author: user) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let url):
				let imageURL = url
				let firestoreArticle = FirebaseArticle(userID: self.user.userID, articleTitle: articleTitle, authorName: self.user.name,
													   subject: selectedSubject, timestamp: interval, contentText: self.htmlText, imageURL: imageURL, ratings: [])
				ArticleService.shared.uploadArticle(article: firestoreArticle) {
					loadingAnimation.stopAnimation()
					self.dismiss(animated: true)
				}
			case .failure(let error):
				self.showAlert(alertText: "Error", alertMessage: "Internate connection issue")
				print(error)
			}
		}
	}
	
	@objc func handleTextFormate(_ sender: UIBarButtonItem) {
		if sender == textFormateButton {
			toggleMenuView(textFormateView)
		} else {
			toggleMenuView(textColorListView)
		}
	}
	
	@objc func handleItalic() {
		italicButton.isSelected = !italicButton.isSelected
		if italicButton.isSelected {
			let font = currentTextType.font
			
			switch currentTextType {
			case .heading1:
				currentAttribute[NSAttributedString.Key.font] = font.boldItalics()
			case .heading2:
				currentAttribute[NSAttributedString.Key.font] = font.boldItalics()
			case .title1:
				currentAttribute[NSAttributedString.Key.font] = font.italics()
			case .title2:
				currentAttribute[NSAttributedString.Key.font] = font.italics()
			case .text:
				currentAttribute[NSAttributedString.Key.font] = font.italics()
			}
			
		} else {
			currentAttribute[NSAttributedString.Key.font] = currentTextType.font
		}
	}
	
	@objc func handleDoneKBEditing() {
		articleTextView.resignFirstResponder()
		textFormateView.isUp = true
		textColorListView.isUp = true
		showOrHideListMenuView(for: textFormateView, heightConstraint: textFormateViewHeight)
		showOrHideListMenuView(for: textColorListView, heightConstraint: textColorListViewHeight)
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
	
	func toggleMenuView(_ listView: UIView) {
		if listView == textFormateView {
			showOrHideListMenuView(for: textFormateView, heightConstraint: textFormateViewHeight)
		} else {
			showOrHideListMenuView(for: textColorListView, heightConstraint: textColorListViewHeight)
		}
	}
	
	func showOrHideListMenuView(for listView: ListMenuView, heightConstraint: NSLayoutConstraint) {
		if listView.isUp {
			listView.isUp = false
			
			heightConstraint.isActive = false
			heightConstraint.constant = 0
			heightConstraint.isActive = true
			
		} else {
			listView.isUp = true
			
			heightConstraint.isActive = false
			heightConstraint.constant = listView == textFormateView ? CGFloat(40 * listView.textFormateOptions.count) : CGFloat(40 * listView.textColorOptions.count)
			heightConstraint.isActive = true

			UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
				listView.center.y -= listView.frame.height / 2
				listView.layoutIfNeeded()
			}
		}
	}
	
	func convertAttributeStringToHtml() {
		do {
			let range = NSRange(location: 0, length: articleTextView.attributedText.length)
			let att = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]

			let htmlData = try articleTextView.attributedText.data(from: range, documentAttributes: att)

			if let htmlText = String(data: htmlData, encoding: .utf8) {
				self.htmlText = htmlText
			}
		}
		catch {
			print("Utterly failed to convert to html!!! \n>\(String(describing: articleTextView.attributedText))<\n")
		}
	}
}

// MARK: - ListMenuViewDelegate

extension WriteArticleViewController: ListMenuViewDelegate {
	
	func listMenuView(_ view: ListMenuView, for SelectedTextFormateType: TextFormateType) {
		textFormateView.isUp = false
		textFormateViewHeight.isActive = false
		textFormateViewHeight.constant = 0
		textFormateViewHeight.isActive = true
		
		italicButton.isSelected = false
		
		currentTextType = SelectedTextFormateType
		currentAttribute[.font] = currentTextType.font
	}
	
	func listMenuView(_ View: ListMenuView, for selectedTextColorType: TextFormateColor) {
		textColorListView.isUp = false
		textColorListViewHeight.isActive = false
		textColorListViewHeight.constant = 0
		textColorListViewHeight.isActive = true
		
		currentAttribute[.foregroundColor] = selectedTextColorType.color
		textColorButton.tintColor = selectedTextColorType.color
	}
}

// MARK: - UITextViewDelegate

extension WriteArticleViewController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		self.characterCountLabel.text = "\(textView.text.count) character"
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
