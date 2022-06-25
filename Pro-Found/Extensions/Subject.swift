//
//  Subject.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import UIKit

enum Subject: String, CaseIterable {
	case language = "Language"
	case technology = "Technology"
	case music = "Music"
	case art = "Art"
	case sport = "Sport"
	
	var image: UIImage? {
		switch self {
		case .language:
			return UIImage.asset(.language)
		case .technology:
			return UIImage.asset(.technology)
		case .music:
			return UIImage.asset(.music)
		case .art:
			return UIImage.asset(.art)
		case .sport:
			return UIImage.asset(.sport)
		}
	}
	
	var color: UIColor? {
		switch self {
		case .language:
			return UIColor.orange
		case .technology:
			return UIColor.skyBlue
		case .music:
			return UIColor.green
		case .art:
			return UIColor.yellow
		case .sport:
			return UIColor.dark40
		}
	}

}

func setSubjectColor(subject: String, targetView: UIView) {
	switch subject {
	case Subject.language.rawValue:
		targetView.backgroundColor = Subject.language.color
	case Subject.technology.rawValue:
		targetView.backgroundColor = Subject.technology.color
	case Subject.music.rawValue:
		targetView.backgroundColor = Subject.music.color
	case Subject.art.rawValue:
		targetView.backgroundColor = Subject.art.color
	case Subject.sport.rawValue:
		targetView.backgroundColor = Subject.sport.color
	default:
		break
	}
}
