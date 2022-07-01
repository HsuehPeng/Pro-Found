//
//  PDFCreator.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/28.
//

import UIKit
import PDFKit

class PDFCreator: NSObject {
	let title: String
	let body: String
	let image: UIImage
	let authorName: String
	
	init(title: String, body: String, image: UIImage, authorName: String) {
		self.title = title
		self.body = body
		self.image = image
		self.authorName = authorName
	}
	
	func createFlyer() -> Data {
		let bodyCount = Int(body.count)
		var indexFirstPage: String.Index
		var firstPageBody: String = ""
		var pageCountAfterFirst: Int = 0
		
		if bodyCount > 1350 {
			indexFirstPage = body.index(body.startIndex, offsetBy: 1350)
			firstPageBody = String(body[...indexFirstPage])
			pageCountAfterFirst = (bodyCount - 1350) / 3000
		} else {
			indexFirstPage = body.endIndex
			firstPageBody = String(body[..<indexFirstPage])
		}

		let pdfMetaData = [
			kCGPDFContextCreator: "Article Builder",
			kCGPDFContextAuthor: "Peng.com",
			kCGPDFContextTitle: title
		]
		let format = UIGraphicsPDFRendererFormat()
		format.documentInfo = pdfMetaData as [String: Any]
		
		let pageWidth = 8.5 * 72.0
		let pageHeight = 11 * 72.0
		let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
		
		let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
		
		let data = renderer.pdfData { (context) in
			
			context.beginPage()
			
			let titleBottom = addTitle(pageRect: pageRect)
			let authorBottom = addAuthor(pageRect: pageRect, authorTop: titleBottom + 18.0)
			let imageBottom = addImage(pageRect: pageRect, imageTop: authorBottom + 18.0)
			addBodyText(pageRect: pageRect, textTop: imageBottom + 18.0, pageoneBody: firstPageBody)
			addPage(pageRect: pageRect, page: "Page 1")
			
			if pageCountAfterFirst > 0 {
				createPageBody(currentStringIndex: indexFirstPage, pageRect: pageRect, page: 2,
							   pageCountAfterFirst: pageCountAfterFirst, context: context)
			}
		}
		
		return data
	}
	
	func addTitle(pageRect: CGRect) -> CGFloat {
		let titleFont = UIFont.customFont(.interBold, size: 18)
		
		let titleAttributes: [NSAttributedString.Key: Any] =
		[NSAttributedString.Key.font: titleFont]
		
		let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
		
		let titleStringSize = attributedTitle.size()
		
		let titleStringRect = CGRect(x: (pageRect.width - titleStringSize.width) / 2.0,
									 y: 36, width: titleStringSize.width,
									 height: titleStringSize.height)
		
		attributedTitle.draw(in: titleStringRect)
		
		return titleStringRect.origin.y + titleStringRect.size.height
	}
	
	func addAuthor(pageRect: CGRect, authorTop: CGFloat) -> CGFloat {
		let titleFont = UIFont.customFont(.manropeRegular, size: 14)
		
		let titleAttributes: [NSAttributedString.Key: Any] =
		[NSAttributedString.Key.font: titleFont]
		
		let attributedTitle = NSAttributedString(string: "By \(authorName)", attributes: titleAttributes)
		
		let titleStringSize = attributedTitle.size()
		
		let titleStringRect = CGRect(x: (pageRect.width - titleStringSize.width) / 2.0,
									 y: authorTop, width: titleStringSize.width,
									 height: titleStringSize.height)
		
		attributedTitle.draw(in: titleStringRect)
		
		return titleStringRect.origin.y + titleStringRect.size.height
	}
	
	func addBodyText(pageRect: CGRect, textTop: CGFloat, pageoneBody: String) {
		
		let textFont = UIFont.customFont(.manropeRegular, size: 12)
		
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .natural
		paragraphStyle.lineBreakMode = .byWordWrapping
		
		let textAttributes = [
			NSAttributedString.Key.paragraphStyle: paragraphStyle,
			NSAttributedString.Key.font: textFont
		]
		let attributedText = NSAttributedString(string: pageoneBody, attributes: textAttributes)
		
		let textRect = CGRect(x: 50, y: textTop, width: pageRect.width - 100,
							  height: pageRect.height - textTop - 70)
		attributedText.draw(in: textRect)
	}
	
	func bodyTextForPage(pageRect: CGRect, pageBody: String) {
		let textFont = UIFont.customFont(.manropeRegular, size: 12)
		
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .natural
		paragraphStyle.lineBreakMode = .byWordWrapping
		
		let textAttributes = [
			NSAttributedString.Key.paragraphStyle: paragraphStyle,
			NSAttributedString.Key.font: textFont
		]
		let attributedText = NSAttributedString(string: pageBody, attributes: textAttributes)
		
		let textRect = CGRect(x: 50, y: 70, width: pageRect.width - 100,
							  height: pageRect.height - 70)
		attributedText.draw(in: textRect)
	}
	
	func addImage(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
		
		let maxHeight = pageRect.height * 0.4
		let maxWidth = pageRect.width * 0.8
		
		let aspectWidth = maxWidth / image.size.width
		let aspectHeight = maxHeight / image.size.height
		let aspectRatio = min(aspectWidth, aspectHeight)
		
		let scaledWidth = image.size.width * aspectRatio
		let scaledHeight = image.size.height * aspectRatio
		
		let imageX = (pageRect.width - scaledWidth) / 2.0
		let imageRect = CGRect(x: imageX, y: imageTop,
							   width: scaledWidth, height: scaledHeight)
		
		image.draw(in: imageRect)
		return imageRect.origin.y + imageRect.size.height
	}
	
	func addPage(pageRect: CGRect, page: String) {
		let textFont = UIFont.customFont(.manropeRegular, size: 10)
		
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .natural
		paragraphStyle.lineBreakMode = .byWordWrapping
		
		let textAttributes = [
			NSAttributedString.Key.paragraphStyle: paragraphStyle,
			NSAttributedString.Key.font: textFont
		]
		let attributedPage = NSAttributedString(string: page, attributes: textAttributes)
		
		let pageStringSize = attributedPage.size()
		
		let textRect = CGRect(x: (pageRect.width - pageStringSize.width) / 2.0, y: pageRect.height - 50,
							  width: pageStringSize.width, height: pageStringSize.height)
		attributedPage.draw(in: textRect)
	}
	
	func createPageBody(currentStringIndex: String.Index, pageRect: CGRect, page: Int,
						pageCountAfterFirst: Int, context: UIGraphicsPDFRendererContext) {
		var leftOverPageCount = pageCountAfterFirst
		var newStringIndex = currentStringIndex
		var newPage = page
		if leftOverPageCount > 0 {
			newStringIndex = body.index(newStringIndex, offsetBy: 3000)

			context.beginPage()
			bodyTextForPage(pageRect: pageRect, pageBody: String(body[currentStringIndex...newStringIndex]))
			addPage(pageRect: pageRect, page: "Page \(newPage)")
			
			leftOverPageCount -= 1
			newPage += 1
			createPageBody(currentStringIndex: newStringIndex, pageRect: pageRect, page: newPage,
						   pageCountAfterFirst: leftOverPageCount, context: context)
		} else {
			context.beginPage()
			bodyTextForPage(pageRect: pageRect, pageBody: String(body[newStringIndex..<body.endIndex]))
			addPage(pageRect: pageRect, page: "Page \(newPage)")
			return
		}
	}
	
}
