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
	
	// MARK: - CreateCompanyController Constants
	private enum Constants {
		enum Sizes: CGFloat {
			case logoSize = 100
			case containerViewHeight = 350
			case fieldsHeight = 50
		}
		enum Spaces: CGFloat {
			case defaultSpace = 16
			case logoTopSpace = 8
		}
	}
	
	weak var delegate: CreateCompanyControllerDelegate?
	
	var company: Company? {
		didSet {
			guard let company = company else { return }
			nameTextField.text = company.name
			foundedDatePicker.date = company.founded ?? Date()
		}
	}
	
	// MARK: - UI Components
	private let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "Name"
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		label.backgroundColor = .red
		return label
	}()
	
	private let nameTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter Name"
		textField.textColor = .black
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.backgroundColor = .yellow
		return textField
	}()
	
	private let foundedDatePicker: UIDatePicker = {
		let datePicker = UIDatePicker()
		datePicker.translatesAutoresizingMaskIntoConstraints = false
		datePicker.preferredDatePickerStyle = .wheels
		datePicker.datePickerMode = .date
		return datePicker
	}()
	
	private lazy var companyLogo: UIImageView = {
		let imageView = UIImageView(image: UIImage(named: "select_photo_placeholder"))
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.isUserInteractionEnabled = true
		imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
		imageView.layer.cornerRadius = Constants.Sizes.logoSize.rawValue / 2
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
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
		let nameStackView = createStackView(subviews: [nameLabel, nameTextField])
		
		containerView.addSubview(companyLogo)
		containerView.addSubview(nameStackView)
		containerView.addSubview(foundedDatePicker)
		
		NSLayoutConstraint.activate([
			// Company Logo Autholayout
			companyLogo.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.Spaces.logoTopSpace.rawValue),
			companyLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			companyLogo.heightAnchor.constraint(equalToConstant: Constants.Sizes.logoSize.rawValue),
			companyLogo.widthAnchor.constraint(equalToConstant: Constants.Sizes.logoSize.rawValue),
			
			// Name Stack View Autholayout
			nameStackView.topAnchor.constraint(equalTo: companyLogo.bottomAnchor, constant: Constants.Spaces.defaultSpace.rawValue),
			nameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Spaces.defaultSpace.rawValue),
			nameStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Spaces.defaultSpace.rawValue),
			nameStackView.heightAnchor.constraint(equalToConstant: Constants.Sizes.fieldsHeight.rawValue),
			
			// Name label autholayout
			nameLabel.widthAnchor.constraint(equalToConstant: 100),
			
			// Date Picker Autholayot
			foundedDatePicker.topAnchor.constraint(equalTo: nameStackView.bottomAnchor),
			foundedDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			foundedDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			foundedDatePicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
		])
	}
	
	/// Container view
	fileprivate func setupContainerView() -> UIView {
		let container = UIView()
		container.backgroundColor = .lightBlue
		container.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(container)
		
		NSLayoutConstraint.activate([
			container.topAnchor.constraint(equalTo: view.topAnchor),
			container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			container.heightAnchor.constraint(equalToConstant: Constants.Sizes.containerViewHeight.rawValue),
		])
		
		return container
	}
	
	/// Generate stack view
	fileprivate func createStackView(subviews: [UIView]) -> UIStackView {
		let stackView = UIStackView(arrangedSubviews: subviews)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
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
	
	/// Present image picker controller
	@objc fileprivate func handleSelectPhoto() {
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		present(imagePickerController, animated: true)
	}
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CreateCompanyController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		if let editingImage = info[.editedImage] as? UIImage {
			companyLogo.image = editingImage
		}
		
		if let originalImage = info[.originalImage] as? UIImage {
			companyLogo.image = originalImage
		}
		
		dismiss(animated: true)
	}
}
