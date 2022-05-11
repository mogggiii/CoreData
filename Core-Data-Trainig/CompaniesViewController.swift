//
//  ViewController.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 11.05.2022.
//

import UIKit

class CompaniesViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Companies"
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
		
		view.backgroundColor = .white
		
		configureNavBar()
	}

	fileprivate func configureNavBar() {
		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = UIColor(red: 251 / 255, green: 63 / 255, blue: 82 / 255, alpha: 1)
		appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		
		navigationController?.navigationBar.standardAppearance = appearance
		navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
		navigationController?.navigationBar.isTranslucent = false
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	@objc fileprivate func handleAddCompany() {
		print("ADD TAP")
	}
}

