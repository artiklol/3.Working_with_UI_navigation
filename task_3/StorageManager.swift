//
//  DataManager.swift
//  task_3
//
//  Created by Artem Sulzhenko on 21.12.2022.
//

import Foundation

class StorageManager {

    static let shared = StorageManager()

    private var contactList = [Contact]()

    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    private var archiveURL: URL?

    init() {
        archiveURL = documentDirectory?.appendingPathComponent("Contact").appendingPathExtension("plist")
    }

    func saveDataToFile(_ data: [Contact]) {
        guard let archiveURL = archiveURL else { return }
        let encoder = PropertyListEncoder()
        guard let encodedContact = try? encoder.encode(data) else { return }
        try? encodedContact.write(to: archiveURL, options: .noFileProtection)
    }

    func updateFavoriteDataToFile(index: Int, bool: Bool) {
        contactList[index].favorite = bool
        guard let archiveURL = archiveURL else { return }
        let encoder = PropertyListEncoder()
        guard let encodedContact = try? encoder.encode(contactList) else { return }
        try? encodedContact.write(to: archiveURL, options: .noFileProtection)
        print("test: \(contactList[index].name) \(contactList[index].favorite)")
    }

    func getUserDataFile() -> [Contact] {
        guard let archiveURL = archiveURL else { return contactList }
        guard let savedData = try? Data(contentsOf: archiveURL) else { return contactList }
        let decoder = PropertyListDecoder()
        guard let loadedData = try? decoder.decode([Contact].self, from: savedData) else { return contactList }
        contactList = loadedData
        for list in contactList {
            print(list)
        }
        return contactList
    }

}
