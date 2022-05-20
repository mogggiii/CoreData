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
}

