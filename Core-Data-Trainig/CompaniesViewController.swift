//
//  ViewController.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 11.05.2022.
//

import UIKit

class CompaniesViewController: UIViewController {
	
	fileprivate let reuseId = "cell"
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: view.bounds)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(CompaniesCell.self, forCellReuseIdentifier: reuseId)
		tableView.backgroundColor = .tableViewBackground
		tableView.separatorColor = .white
		tableView.tableFooterView = UIView()
		return tableView
	}()
	
	// MARK: - VC lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(tableView)
		
		navigationItem.title = "Companies"
		
		configureNavBarButtons()
		setupNavigationStyle()
	}
	
	// MARK: - Fileprivate
	/// Configure nav bar
	/// - Changes:
	/// -  Nav bar tint color
	/// - Title color
	fileprivate func setupNavigationStyle() {
		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = .navBarLightRed
		appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		
		navigationController?.navigationBar.standardAppearance = appearance
		navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
		navigationController?.navigationBar.isTranslucent = false
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	/// Configure navigation buttons
	fileprivate func configureNavBarButtons() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
		navigationItem.leftBarButtonItem?.tintColor = .white
	}
	
	// MARK: - Objc fileprivate
	@objc fileprivate func handleAddCompany() {
		print("ADD TAP")
	}
	
	@objc fileprivate func handleReset() {
		print("Reset")
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CompaniesViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = UIView()
		header.backgroundColor = .yellow
		return header
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! CompaniesCell
		
		return cell
	}
	
}
