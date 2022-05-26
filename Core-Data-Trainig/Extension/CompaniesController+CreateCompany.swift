//
//  CreateCompanyController+CreateCompany.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 26.05.2022.
//

import UIKit

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
