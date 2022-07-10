//
//  File.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/23.
//

import UIKit
import FirebaseAuth

class BecomeTutorViewController: UIViewController {
	
	// MARK: - Properties
	
	var user: User
	
	let subjects = [Subject.language, Subject.technology, Subject.sport, Subject.music, Subject.art]
	
	var updateProfilePage: (() -> Void)?
	
	private let topBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .light60
		return view
	}()
	
	private let topBarTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "Selected Subject: "
		label.textColor = .dark
		label.font = UIFont.customFont(.interBold, size: 16)
		label.textAlignment = .center
		return label
	}()
	
	private let topBarSubjectLabel: UILabel = {
		let label = UILabel()
		label.textColor = .orange
		label.font = UIFont.customFont(.interBold, size: 16)
		label.textAlignment = .center
		return label
	}()
	
	private lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
		collectionView.register(ChooseSubjectUICollectionViewCell.self, forCellWithReuseIdentifier: ChooseSubjectUICollectionViewCell.reuseIdentifier)
		return collectionView
	}()
	
	private lazy var chooseButton: UIButton = {
		let button = CustomUIElements().makeSmallButton(buttonColor: .orange, buttonTextColor: .light60, borderColor: .clear, buttonText: "Confirm")
		button.backgroundColor = .orange
		button.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
		return button
	}()
		
	private lazy var pageControl: UIPageControl = {
		let control = UIPageControl()
		control.numberOfPages = Subject.allCases.count
		control.currentPage = 0
		control.addTarget(self, action: #selector(pageControlDidChange), for: .valueChanged)
		return control
	}()
	
	// MARK: - Lifecucle
	
	init(user: User) {
		self.user = user
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let color = UIColor(white: 1, alpha: 0.82)
		view.backgroundColor = color
		
		collectionView.dataSource = self
		collectionView.delegate = self
		
		setupUI()
	}

	// MARK: - UI
	
	func setupUI() {
		view.addSubview(topBarView)
		topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 50)
		
		topBarView.addSubview(topBarTitleLabel)
		topBarTitleLabel.centerY(inView: topBarView, leftAnchor: topBarView.leftAnchor, paddingLeft: 16)
		
		topBarView.addSubview(topBarSubjectLabel)
		topBarSubjectLabel.centerY(inView: topBarView, leftAnchor: topBarTitleLabel.rightAnchor, paddingLeft: 4)
		
		topBarView.addSubview(chooseButton)
		chooseButton.anchor(right: topBarView.rightAnchor, paddingRight: 16)
		chooseButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
		chooseButton.centerY(inView: topBarView)
		
		view.addSubview(collectionView)
		collectionView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.frame.size.height * 0.7)
		
		view.addSubview(pageControl)
		pageControl.centerX(inView: view)
		pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
		
	}
	
	// MARK: - Actions
	
	@objc func handleConfirm() {
		guard let uid = Auth.auth().currentUser?.uid, let subject = topBarSubjectLabel.text else { return }
		
		UserServie.shared.toggleTutorStatus(userID: uid, subject: subject, isTutor: user.isTutor) { [weak self] in
			guard let self = self else { return }
			self.updateProfilePage?()
			self.dismiss(animated: true)
		}
	}
	
	@objc func pageControlDidChange(_ sender: UIPageControl) {
		let current = sender.currentPage
		collectionView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
	}
	
	
	// MARK: - Helpers
	
	func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.7))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .groupPaging
		
		let layout = UICollectionViewCompositionalLayout(section: section)
		return layout
	}
}

// MARK: - UICollectionViewDataSource

extension BecomeTutorViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return subjects.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChooseSubjectUICollectionViewCell.reuseIdentifier, for: indexPath)
				as? ChooseSubjectUICollectionViewCell else { fatalError("Can not dequeue ChooseSubjectUICollectionViewCell") }
		cell.subjectImageView.image = subjects[indexPath.item].image
		return cell
	}
	
}

// MARK: - UICollectionViewDelegate

extension BecomeTutorViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		pageControl.currentPage = indexPath.item
		
		UIView.animate(withDuration: 0.3) {
			self.topBarSubjectLabel.alpha = 0
		} completion: { done in
			if done {
				self.topBarSubjectLabel.text = self.subjects[indexPath.item].rawValue
				self.topBarSubjectLabel.alpha = 1
			}
		}
	}
}
