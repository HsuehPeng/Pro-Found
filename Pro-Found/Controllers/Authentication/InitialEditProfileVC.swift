//
//  InitialEditProfileVC.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/26.
//

import UIKit
import Kingfisher
import PhotosUI
import Lottie

class InitialEditProfileVC: UIViewController {

	// MARK: - Properties
	
	var user: User
	
	private lazy var skipButton: UIButton = {
		let button = UIButton()
		button.setTitle("Skip", for: .normal)
		button.setTitleColor(UIColor.orange, for: .normal)
		button.titleLabel?.font = UIFont.customFont(.interSemiBold, size: 14)
		button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
		return button
	}()
	
	private let titleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 24),
												 textColor: .dark, text: "Let others know more about you")
		label.numberOfLines = 0
		return label
	}()
	
	private let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.clipsToBounds = true
		imageView.setDimensions(width: 96, height: 96)
		imageView.layer.cornerRadius = 96 / 2
		imageView.contentMode = .scaleAspectFill
		imageView.image = UIImage.asset(.account_person)
		return imageView
	}()
	
	private lazy var uploadPhotoButton: UIButton = {
		let button = CustomUIElements().makeSmallButton(buttonColor: .orange, buttonTextColor: .light60,
														borderColor: .clear, buttonText: "Upload Photo")
		button.addTarget(self, action: #selector(uploadPhoto), for: .touchUpInside)
		button.widthAnchor.constraint(equalToConstant: 124).isActive = true
		return button
	}()
	
	private let schoolTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 12),
												 textColor: UIColor.dark, text: "School")
		return label
	}()
	
	private let schoolTitleTextField: UITextField = {
		let textField = UITextField()
		textField.font = UIFont.customFont(.manropeRegular, size: 12)
		return textField
	}()
	
	private let schoolDividerView: UIView = {
		let dividerView = UIView()
		dividerView.backgroundColor = .dark20
		dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		return dividerView
	}()
	
	private let majorTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 12),
												 textColor: UIColor.dark, text: "Major")
		return label
	}()
	
	private let majorTitleTextField: UITextField = {
		let textField = UITextField()
		textField.font = UIFont.customFont(.manropeRegular, size: 12)
		return textField
	}()
	
	private let majorDividerView: UIView = {
		let dividerView = UIView()
		dividerView.backgroundColor = .dark20
		dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		return dividerView
	}()
	
	private let introTextView: PlaceHolderTextView = {
		let textView = PlaceHolderTextView()
		textView.font = UIFont.customFont(.manropeRegular, size: 12)
		textView.layer.borderColor = UIColor.orange.cgColor
		textView.layer.borderWidth = 1
		textView.layer.cornerRadius = 10
		textView.placeholderLabel.text = "Self Introduction"
		return textView
	}()
	
	private lazy var doneButton: UIButton = {
		let button = CustomUIElements().makeLargeButton(buttonColor: .orange, buttonTextColor: .light60,
														borderColor: .clear, buttonText: "Done")
		button.addTarget(self, action: #selector(handleDoneEditting), for: .touchUpInside)
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
		
		setupUI()
		setupNavBar()
	}
	
	// MARK: - UI
	
	func setupUI() {
		
		view.addSubview(skipButton)
		skipButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 16, paddingRight: 16)
		
		view.addSubview(titleLabel)
		titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: skipButton.leftAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(profileImageView)
		profileImageView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 32, paddingLeft: 16)
		
		view.addSubview(uploadPhotoButton)
		uploadPhotoButton.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 20)
		
		
		view.addSubview(schoolTitleLabel)
		schoolTitleLabel.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor,
						  right: view.rightAnchor, paddingTop: 26, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(schoolTitleTextField)
		schoolTitleTextField.anchor(top: schoolTitleLabel.bottomAnchor, left: view.leftAnchor,
								 right: view.rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(schoolDividerView)
		schoolDividerView.anchor(top: schoolTitleTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
								paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 1)
		
		view.addSubview(majorTitleLabel)
		majorTitleLabel.anchor(top: schoolDividerView.bottomAnchor, left: view.leftAnchor,
						  right: view.rightAnchor, paddingTop: 26, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(majorTitleTextField)
		majorTitleTextField.anchor(top: majorTitleLabel.bottomAnchor, left: view.leftAnchor,
								 right: view.rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(majorDividerView)
		majorDividerView.anchor(top: majorTitleTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
								paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 1)
		
		view.addSubview(introTextView)
		introTextView.anchor(top: majorDividerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							 paddingTop: 26, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(doneButton)
		doneButton.anchor(top: introTextView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
						  right: view.rightAnchor, paddingTop: 16, paddingLeft: 25, paddingBottom: 50, paddingRight: 25)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
	}
	
	// MARK: - Actions
	
	@objc func uploadPhoto() {
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
	
	@objc func dismissVC() {
		guard let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).flatMap({
			$0.windows }).first(where: { $0.isKeyWindow }) else { return }
		
		guard let tab = window.rootViewController as? MainTabController else { return }
		
		tab.authenticateUserAndConfigureUI()
		
		dismiss(animated: true)
	}
	
	@objc func handleDoneEditting() {
				
		guard let school = schoolTitleTextField.text, !school.isEmpty,
			  let major = majorTitleTextField.text, !major.isEmpty,
			  let intro = introTextView.text, !intro.isEmpty,
			  let image = profileImageView.image else {
			let missingInputVC = MissingInputViewController()
			missingInputVC.modalTransitionStyle = .crossDissolve
			missingInputVC.modalPresentationStyle = .overCurrentContext
			present(missingInputVC, animated: true)
			return
		}
		
		let loadingLottie = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		loadingLottie.loadingAnimation()
		
		UserServie.shared.uploadUserImageAndDownloadImageURL(userProfileImage: image, user: user) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let url):
				self.user.profileImageURL = url
				self.user.school = school
				self.user.schoolMajor = major
				self.user.introContentText = intro
				
				UserServie.shared.uploadUserData(user: self.user) { [weak self] in
					guard let self = self else { return }
					
					guard let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).flatMap({
						$0.windows }).first(where: { $0.isKeyWindow }) else { return }
					guard let tab = window.rootViewController as? MainTabController else { return }
					tab.authenticateUserAndConfigureUI()
					loadingLottie.stopAnimation()
					self.dismiss(animated: true)
				}

			case .failure(let error):
				self.showAlert(alertText: "Error", alertMessage: "Error updating user info")
				print(error)
			}
		}
	}

}

// MARK: - PHPickerViewControllerDelegate

extension InitialEditProfileVC: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true)
		let itemProviders = results.map(\.itemProvider)
		for item in itemProviders {
			if item.canLoadObject(ofClass: UIImage.self) {
				item.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
					guard let self = self else { return }
					DispatchQueue.main.async {
						if let image = image as? UIImage {
							self.profileImageView.image = nil
							self.profileImageView.image = image
						}
					}
				}
			}
		}
	}
}
