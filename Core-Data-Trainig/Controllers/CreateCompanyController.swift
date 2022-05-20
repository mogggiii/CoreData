//
//  CreateCompanyController.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 18.05.2022.
//

import UIKit
import CoreData

protocol CreateCompanyControllerDelegate: AnyObject {
	func didAddCompany(company: Company)
}

class CreateCompanyController: UIViewController {
	
	weak var delegate: CreateCompanyControllerDelegate?
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "Name"
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let nameTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter Name"
		textField.textColor = .black
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		configureNavigationButtons()
		
		navigationItem.title = "Create Company"
		
		view.backgroundColor = .tableViewBackground
	}
	
	// MARK: - Fileprivate
	fileprivate func configureNavigationButtons() {
		// left button
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
		// right button
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
	}
	
	fileprivate func setupUI() {
		let containerView = setupContainerView()
		containerView.addSubview(nameLabel)
		containerView.addSubview(nameTextField)
		
		NSLayoutConstraint.activate([
			/// Name label autholayout
			nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
			nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
			nameLabel.widthAnchor.constraint(equalToConstant: 100),
			nameLabel.heightAnchor.constraint(equalToConstant: 50),
			
			/// Name text field autholayout
			nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
			nameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
			nameTextField.topAnchor.constraint(equalTo: containerView.topAnchor),
			nameTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
		])
	}
	
	/// Containet view
	fileprivate func setupContainerView() -> UIView {
		let container = UIView()
		container.backgroundColor = .lightBlue
		container.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(container)
		
		NSLayoutConstraint.activate([
			container.topAnchor.constraint(equalTo: view.topAnchor),
			container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			container.heightAnchor.constraint(equalToConstant: 50),
		])
		
		return container
	}
	
	// MARK: - Objc fileprivate
	@objc fileprivate func handleCancel() {
		dismiss(animated: true)
	}
	
	@objc fileprivate func handleSave() {
		print("Trying to save")
		
		let context = CoreDataManager.shared.persistentContainer.viewContext
		let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
		
		guard let companyName = nameTextField.text else { return }
		company.setValue(companyName, forKey: "name")
		
		do {
			try context.save()
			
			dismiss(animated: true) {
				self.delegate?.didAddCompany(company: company as! Company)
			}
		} catch let saveError {
			print("Failed to save compny", saveError)
		}
	}
	
}
