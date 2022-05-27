//
//  UIViewController+Helpers.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 27.05.2022.
//

import UIKit

extension UIViewController {
	func setupPlusButtonInNavBar(_ selector: Selector) {
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: selector)
	}
	
	// left cancel button
	func setupCancelButtonInNavBar() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
	}
	
	// right save button
	func setupSaveButtonInNavBar(_ selector: Selector) {
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: selector)
	}
	
	// Setup Container View
	func setupContainerView(height: CGFloat) -> UIView {
		let container = UIView()
		container.backgroundColor = .lightBlue
		container.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(container)
		
		NSLayoutConstraint.activate([
			container.topAnchor.constraint(equalTo: view.topAnchor),
			container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			container.heightAnchor.constraint(equalToConstant: height),
		])
		
		return container
	}
	
	@objc fileprivate func handleCancelModal() {
		dismiss(animated: true)
	}
}
