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
	
	private let containerView = ContainerView()
	weak var delegate: CreateCompanyControllerDelegate?
	
	var company: Company? {
		didSet {
			containerView.company = company
		}
	}
	
	override func loadView() {
		view = containerView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .darkBlue
		
		containerView.companyLogo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
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
	
	fileprivate func createCompany() {
		let context = CoreDataManager.shared.persistentContainer.viewContext
		let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
		
		guard let imageData = containerView.companyLogo.image?.jpegData(compressionQuality: 0.8) else { return }
		
		company.setValue(containerView.nameTextField.text, forKey: "name")
		company.setValue(containerView.foundedDatePicker.date, forKey: "founded")
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
		let imageData = containerView.companyLogo.image?.jpegData(compressionQuality: 0.8)
		
		// update values in core data
		company?.name = containerView.nameTextField.text
		company?.founded = containerView.foundedDatePicker.date
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
			containerView.companyLogo.image = editingImage
		}
		
		if let originalImage = info[.originalImage] as? UIImage {
			containerView.companyLogo.image = originalImage
		}
		
		dismiss(animated: true)
	}
}
