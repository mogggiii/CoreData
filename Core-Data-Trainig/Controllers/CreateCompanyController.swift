//
//  CreateCompanyController.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 18.05.2022.
//

import UIKit

protocol CreateCompanyControllerDelegate: class {
	func didAddCompany(company: Company)
}

class CreateCompanyController: UIViewController {
	
	weak var delegate: CreateCompanyControllerDelegate?
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "Name"
		label.textColor = .black
		label.backgroundColor = .red
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let nameTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter Name"
		textField.backgroundColor = .yellow
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		configureNavigationButtons()
		
		title = "Create Company"
		
		view.backgroundColor = .tableViewBackground
	}
	
	fileprivate func configureNavigationButtons() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
		
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
			nameTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
			
		])
	}
	
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
	
	@objc fileprivate func handleCancel() {
		dismiss(animated: true)
	}
	
	@objc fileprivate func handleSave() {
		dismiss(animated: true) {
			guard let name = self.nameTextField.text else { return }
			let company = Company(name: name, founded: Date())
			self.delegate?.didAddCompany(company: company)
		}
		
		
		print("save")
	}
}
