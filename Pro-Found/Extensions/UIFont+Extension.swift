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
	
	func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {

		// create a new font descriptor with the given traits
		guard let fd = fontDescriptor.withSymbolicTraits(traits) else {
			// the given traits couldn't be applied, return self
			return self
		}
			
		// return a new font with the created font descriptor
		return UIFont(descriptor: fd, size: pointSize)
	}

	func italics() -> UIFont {
		return withTraits(.traitItalic)
	}
	
	func boldItalics() -> UIFont {
		return withTraits([ .traitBold, .traitItalic ])
	}
}
