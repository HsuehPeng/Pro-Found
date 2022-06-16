//
//  UIFont.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/12.
//

import UIKit

enum FontName: String {

	case interBold = "Inter-Bold"
	case interSemiBold = "Inter-SemiBold"
	case manropeRegular = "Manrope-Regular"
}

extension UIFont {
	static func customFont(_ font: FontName, size: CGFloat) -> UIFont {
		return UIFont(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: 16)
	}
}
