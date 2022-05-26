//
//  ViewController.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 11.05.2022.
//

import UIKit
import CoreData

class CompaniesViewController: UIViewController {
	
	fileprivate var companies = [Company]()
	fileprivate let reuseId = "cell"
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: view.bounds)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(CompaniesCell.self, forCellReuseIdentifier: reuseId)
		tableView.backgroundColor = .darkBlue
		tableView.separatorColor = .white
		tableView.tableFooterView = UIView()
		return tableView
	}()
	
	// MARK: - VC lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(tableView)
		
		title = "Companies"
		
		fetchCompanies()
		configureNavBarButtons()
	}
	
	// MARK: - Fileprivate
	/// Configure navigation buttons
	fileprivate func configureNavBarButtons() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
	}
	
	/// Fetch companies form CoreData
	fileprivate func fetchCompanies() {
		let context = CoreDataManager.shared.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
		
		do {
			let companies = try context.fetch(fetchRequest)
			self.companies = companies
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		} catch let fetchError {
			print("Failed to fetch", fetchError)
		}
	}
	
	// MARK: - Objc fileprivate
	
	/// Add button:
	/// - Open CreateCompanyController
	/// - Use the delegate
	@objc fileprivate func handleAddCompany() {
		let createCompanyController = CreateCompanyController()
		let navVC = CustomNavigationController(rootViewController: createCompanyController)
		navVC.modalPresentationStyle = .fullScreen
		
		createCompanyController.delegate = self
		present(navVC, animated: true)
	}
	
	/// Reset button:
	/// Delete all object from Core Data
	@objc fileprivate func handleReset() {
		let context = CoreDataManager.shared.persistentContainer.viewContext
		let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
		
		do {
			try context.execute(batchDeleteRequest)
			
			var indexPathToRemove = [IndexPath]()
			
			for (index, _) in companies.enumerated() {
				let indexPath = IndexPath(row: index, section: 0)
				indexPathToRemove.append(indexPath)
			}
			
			companies.removeAll()
			tableView.deleteRows(at: indexPathToRemove, with: .left)
		} catch let deleteError {
			print("Failed to delete object from core data", deleteError)
		}
		
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CompaniesViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return companies.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? CompaniesCell else {
			return UITableViewCell()
		}
		
		let company = companies[indexPath.row]
		cell.company = company
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { contextualAction, view, _ in
			let company = self.companies[indexPath.row]
			
			/// remove company from tableView
			self.companies.remove(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .middle)
			
			/// delete company from core data
			let context = CoreDataManager.shared.persistentContainer.viewContext
			context.delete(company)
			
			do {
				try context.save()
			} catch let saveError {
				print("Failde to delete company", saveError)
			}
		}
		deleteAction.backgroundColor = .lightRed
		
		// edit and delete action from cell
		let editAction = UIContextualAction(style: .normal, title: "Edit") { contextualAction, view, _ in
			let editCompanyController = CreateCompanyController()
			editCompanyController.delegate = self
			editCompanyController.company = self.companies[indexPath.row]
			let navVC = CustomNavigationController(rootViewController: editCompanyController)
			navVC.modalPresentationStyle = .fullScreen
			
			self.present(navVC, animated: true)
		}
		editAction.backgroundColor = .darkBlue
		
		let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
		return swipeAction
	}
	
	// Footer
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let label = UILabel()
		label.text = "No companies available..."
		label.textColor = .white
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 17, weight: .bold)
		return label
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return companies.count == 0 ? 150 : 0
	}
}

// MARK: - CreateCompanyControllerDelegate
extension CompaniesViewController: CreateCompanyControllerDelegate {
	/// adding new row
	func didAddCompany(company: Company) {
		companies.append(company)
		
		let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
		tableView.insertRows(at: [newIndexPath], with: .automatic)
	}
	
	/// update company info 
	func didChangeCompany(company: Company) {
		let row = companies.firstIndex(of: company)
		let reloadIndexPath = IndexPath(row: row!, section: 0)
		DispatchQueue.main.async {
			self.tableView.reloadRows(at: [reloadIndexPath], with: .middle)
		}
	}
}
