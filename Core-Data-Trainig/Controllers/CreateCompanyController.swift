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
	func didChangeCompany(company: Company)
}

class CreateCompanyController: UIViewController {
	
	weak var delegate: CreateCompanyControllerDelegate?
	
	var company: Company? {
		didSet {
			guard let company = company else { return }
			nameTextField.text = company.name
			foundedDatePicker.date = company.founded ?? Date()
		}
	}
	
	private let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "Name"
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let nameTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter Name"
		textField.textColor = .black
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	private let foundedDatePicker: UIDatePicker = {
		let datePicker = UIDatePicker()
		datePicker.translatesAutoresizingMaskIntoConstraints = false
		datePicker.preferredDatePickerStyle = .wheels
		datePicker.datePickerMode = .date
		return datePicker
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .darkBlue
		
		setupUI()
		configureNavigationButtons()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationItem.title = company == nil ? "Create Company" : "Edit Company"
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
		containerView.addSubview(foundedDatePicker)
		
		NSLayoutConstraint.activate([
			// Name label autholayout
			nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
			nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
			nameLabel.widthAnchor.constraint(equalToConstant: 100),
			nameLabel.heightAnchor.constraint(equalToConstant: 50),
			
			// Name text field autholayout
			nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
			nameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
			nameTextField.topAnchor.constraint(equalTo: containerView.topAnchor),
			nameTextField.heightAnchor.constraint(equalToConstant: 50),
			
			// Date Picker Autholayot
			foundedDatePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
			foundedDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			foundedDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			foundedDatePicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
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
			container.heightAnchor.constraint(equalToConstant: 250),
		])
		
		return container
	}
	
	fileprivate func createCompany() {
		let context = CoreDataManager.shared.persistentContainer.viewContext
		let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
		
		guard let companyName = nameTextField.text, nameTextField.hasText else { return }
		company.setValue(companyName, forKey: "name")
		company.setValue(foundedDatePicker.date, forKey: "founded")
		
		do {
			try context.save()
			dismiss(animated: true) {
				self.delegate?.didAddCompany(company: company as! Company)
			}
		} catch let saveError {
			print("Failed to save company", saveError)
		}
	}
	
	fileprivate func saveComanyChanges() {
		let context = CoreDataManager.shared.persistentContainer.viewContext
		company?.name = nameTextField.text
		company?.founded = foundedDatePicker.date
		
		do {
			try context.save()
			dismiss(animated: true) {
				self.delegate?.didChangeCompany(company: self.company!)
			}
		} catch let changesError {
			print("Failed to save company changes", changesError)
		}
	}
	
	// MARK: - Objc fileprivate
	@objc fileprivate func handleCancel() {
		dismiss(animated: true)
	}
	
	/// save object to core data
	@objc fileprivate func handleSave() {
		if company == nil {
			createCompany()
		} else {
			saveComanyChanges()
		}
	}
	
}
