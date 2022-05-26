//
//  CompaniesController+UITableView.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 26.05.2022.
//

import UIKit

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
