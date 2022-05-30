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
			
			guard let imageData = company.imageData, let logo = UIImage(data: imageData) else { return }
			companyLogo.image = logo
		}
	}
	
	// MARK: - UI Components
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
	
	private lazy var companyLogo: UIImageView = {
		let imageView = UIImageView(image: UIImage(named: "select_photo_placeholder"))
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.isUserInteractionEnabled = true
		imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
		imageView.layer.cornerRadius = CreateCompanyControllerConstant.Sizes.logoSize.rawValue / 2
		imageView.layer.borderColor = UIColor.darkBlue.cgColor
		imageView.layer.borderWidth = 1
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
		setupCancelButtonInNavBar()
		// right button
		setupSaveButtonInNavBar(#selector(handleSave))
	}
	
	fileprivate func setupUI() {
		let containerView = setupContainerView(height: CreateCompanyControllerConstant.Sizes.containerViewHeight.rawValue)
		let nameStackView = createStackView(subviews: [nameLabel, nameTextField])
		
		containerView.addSubview(companyLogo)
		containerView.addSubview(nameStackView)
		containerView.addSubview(foundedDatePicker)
		
		NSLayoutConstraint.activate([
			// Company Logo Autholayout
			companyLogo.topAnchor.constraint(equalTo: containerView.topAnchor, constant: CreateCompanyControllerConstant.Spaces.logoTopSpace.rawValue),
			companyLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			companyLogo.heightAnchor.constraint(equalToConstant: CreateCompanyControllerConstant.Sizes.logoSize.rawValue),
			companyLogo.widthAnchor.constraint(equalToConstant: CreateCompanyControllerConstant.Sizes.logoSize.rawValue),
			
			// Name Stack View Autholayout
			nameStackView.topAnchor.constraint(equalTo: companyLogo.bottomAnchor, constant: CreateCompanyControllerConstant.Spaces.defaultSpace.rawValue),
			nameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CreateCompanyControllerConstant.Spaces.defaultSpace.rawValue),
			nameStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CreateCompanyControllerConstant.Spaces.defaultSpace.rawValue),
			nameStackView.heightAnchor.constraint(equalToConstant: CreateCompanyControllerConstant.Sizes.fieldsHeight.rawValue),
			
			// Name label autholayout
			nameLabel.widthAnchor.constraint(equalToConstant: 100),
			
			// Date Picker Autholayot
			foundedDatePicker.topAnchor.constraint(equalTo: nameStackView.bottomAnchor),
			foundedDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			foundedDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			foundedDatePicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
		])
	}
	
	fileprivate func createCompany() {
		let context = CoreDataManager.shared.persistentContainer.viewContext
		let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
		
		guard let imageData = companyLogo.image?.jpegData(compressionQuality: 0.8) else { return }
		
		company.setValue(nameTextField.text, forKey: "name")
		company.setValue(foundedDatePicker.date, forKey: "founded")
		company.setValue(imageData, forKey: "imageData")
		
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
		let imageData = companyLogo.image?.jpegData(compressionQuality: 0.8)
		
		// update values in core data
		company?.name = nameTextField.text
		company?.founded = foundedDatePicker.date
		company?.imageData = imageData
		
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
