//
//  PDFCreator.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/28.
//

import UIKit
import PDFKit

class PDFDINA4PrintRenderer: UIPrintPageRenderer {

	let title: String
	let image: UIImage
	let authorName: String
	let attributedBody: NSAttributedString
	
	init(title: String, image: UIImage, authorName: String, attributedBody: NSAttributedString) {
		self.title = title
		self.image = image
		self.authorName = authorName
		self.attributedBody = attributedBody
	}
	
	let pageSize = CGSize(width: 595, height: 842)

	override var paperRect: CGRect {
		return CGRect(origin: .zero, size: pageSize)
	}

	override var printableRect: CGRect {
		let pageMargin: CGFloat = 60
		let margins = UIEdgeInsets(top: pageMargin, left: pageMargin, bottom: pageMargin, right: pageMargin)
		return paperRect.inset(by: margins)
	}

	func renderPDF(to url: URL) throws {
		prepare(forDrawingPages: NSMakeRange(0, numberOfPages))

		let graphicsRenderer = UIGraphicsPDFRenderer(bounds: paperRect)
		try graphicsRenderer.writePDF(to: url) { context in
			for pageIndex in 0..<numberOfPages {
				context.beginPage()
				drawPage(at: pageIndex, in: context.pdfContextBounds)
			}
		}
	}
	
	func createFlyer() -> Data {
		prepare(forDrawingPages: NSMakeRange(0, numberOfPages))
		
		let graphicsRenderer = UIGraphicsPDFRenderer(bounds: paperRect)
		
		let data = graphicsRenderer.pdfData { (context) in
			
			context.beginPage()
			
			let titleBottom = addTitle(pageRect: paperRect)
			let authorBottom = addAuthor(pageRect: paperRect, authorTop: titleBottom + 18.0)
			let imageBottom = addImage(pageRect: paperRect, imageTop: authorBottom + 18.0)
			
			for pageIndex in 0..<numberOfPages {
				context.beginPage()
				drawPage(at: pageIndex, in: context.pdfContextBounds)
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
}

class PDFCreator: NSObject {
	let title: String
	let image: UIImage
	let authorName: String
	let attributedBody: NSAttributedString
	
	init(title: String, image: UIImage, authorName: String, attributedBody: NSAttributedString) {
		self.title = title
		self.image = image
		self.authorName = authorName
		self.attributedBody = attributedBody
	}
	
	func createFlyer() -> Data {
		
		let bodyCount = attributedBody.length
		var indexFirstPage: Int
		var firstPageBody: NSAttributedString = NSAttributedString(string: "")
		var pageCountAfterFirst: Int = 0
		
		if bodyCount > 1350 {
			indexFirstPage = 1350
			firstPageBody = attributedBody.attributedSubstring(from: NSRange(location: 0, length: indexFirstPage))
			pageCountAfterFirst = (bodyCount - 1350) / 3000
		} else {
			indexFirstPage = attributedBody.length
			firstPageBody = attributedBody.attributedSubstring(from: NSRange(location: 0, length: indexFirstPage))
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
			
			if bodyCount > 1350 {
				createPageBody(currentStringLocation: indexFirstPage, pageRect: pageRect, page: 2,
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
	
	func createBody(pageRect: CGRect, body: NSAttributedString) {
		
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .natural
		paragraphStyle.lineBreakMode = .byWordWrapping
		
		let textAttributes = [
			NSAttributedString.Key.paragraphStyle: paragraphStyle,
		]
		
		let attributedText = NSMutableAttributedString(attributedString: body)
		attributedText.addAttributes(textAttributes, range: NSRange(location: 0, length: body.length))
		
		let pageStringSize = attributedText.size()
		
		let textRect = CGRect(x: (pageRect.width - pageStringSize.width) / 2.0, y: pageRect.height - 50,
							  width: pageStringSize.width, height: pageStringSize.height)
		attributedText.draw(in: textRect)
	}
	
	func addBodyText(pageRect: CGRect, textTop: CGFloat, pageoneBody: NSAttributedString) {
				
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .natural
		paragraphStyle.lineBreakMode = .byWordWrapping
		
		let textAttributes = [
			NSAttributedString.Key.paragraphStyle: paragraphStyle,
		]
		
		let attributedText = NSMutableAttributedString(attributedString: pageoneBody)
		attributedText.addAttributes(textAttributes, range: NSRange(location: 0, length: attributedText.length))
		
		let textRect = CGRect(x: 50, y: textTop, width: pageRect.width - 100,
							  height: pageRect.height - textTop - 70)
		attributedText.draw(in: textRect)
	}
	
	func bodyTextForPage(pageRect: CGRect, pageBody: NSAttributedString) {
		
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .natural
		paragraphStyle.lineBreakMode = .byWordWrapping
		
		let textAttributes = [
			NSAttributedString.Key.paragraphStyle: paragraphStyle,
		]
		let attributedText = NSMutableAttributedString(attributedString: pageBody)
		attributedText.addAttributes(textAttributes, range: NSRange(location: 0, length: attributedText.length))
		
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
	
	func createPageBody(currentStringLocation: Int, pageRect: CGRect, page: Int,
						pageCountAfterFirst: Int, context: UIGraphicsPDFRendererContext) {
		var leftOverPageCount = pageCountAfterFirst
		var newStringIndex = currentStringLocation
		var newPage = page
		if leftOverPageCount > 0 {
			
			context.beginPage()
			bodyTextForPage(pageRect: pageRect, pageBody: attributedBody.attributedSubstring(from: NSRange(location: currentStringLocation, length: 3000)))
			addPage(pageRect: pageRect, page: "Page \(newPage)")
			
			newStringIndex = newStringIndex + 3000
			leftOverPageCount -= 1
			newPage += 1
			createPageBody(currentStringLocation: newStringIndex, pageRect: pageRect, page: newPage,
						   pageCountAfterFirst: leftOverPageCount, context: context)
		} else {
			context.beginPage()
			bodyTextForPage(pageRect: pageRect, pageBody: attributedBody.attributedSubstring(from: NSRange(location: newStringIndex, length: attributedBody.length - newStringIndex)))
			addPage(pageRect: pageRect, page: "Page \(newPage)")
			return
		}
	}
	
}
