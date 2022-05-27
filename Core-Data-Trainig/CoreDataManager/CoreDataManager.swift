//
//  CoreDataManager.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 20.05.2022.
//

import CoreData

class CoreDataManager {
	static let shared = CoreDataManager()
	
	let persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "CompanyCoreData")
		container.loadPersistentStores { storeDescription, error in
			if let error = error {
				fatalError("Loading of store error, \(error)")
			}
		}
		
		return container
	}()
	
	/// Fetch companies form CoreData
	func fetchCompanies() -> [Company] {
		let context = self.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
		
		do {
			let companies = try context.fetch(fetchRequest)
			
			return companies
		} catch let fetchError {
			print("Failed to fetch", fetchError)
			return []
		}
	}
	
	func deleteCompanies(companies: [Company]) -> [IndexPath] {
		let context = self.persistentContainer.viewContext
		let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
		
		do {
			try context.execute(batchDeleteRequest)
			
			var indexPathToRemove = [IndexPath]()
			
			for (index, _) in companies.enumerated() {
				let indexPath = IndexPath(row: index, section: 0)
				indexPathToRemove.append(indexPath)
			}
			
			return indexPathToRemove
		} catch let deleteError {
			print("Failed to delete object from core data", deleteError)
			return []
		}
	}
	
	func createEmployee(employeeName: String) -> Error? {
		let context = persistentContainer.viewContext
		
		let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)
		employee.setValue(employeeName, forKey: "name")
		
		do {
			try context.save()
			return nil
		} catch let saveEmployeeError {
			print("Failed to create employee", saveEmployeeError)
			return saveEmployeeError
		}
	}
}


