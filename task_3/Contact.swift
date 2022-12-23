//
//  Contact.swift
//  task_3
//
//  Created by Artem Sulzhenko on 21.12.2022.
//

import Foundation

struct Contact: Codable {
    let name: String
    let surname: String
    let phoneNumber: String
    let image: Data?
    var favorite: Bool

    var encoded: Data? {
        let encoder = PropertyListEncoder()
        return try? encoder.encode(self)
    }

    init?(from data: Data) {
        let decoder = PropertyListDecoder()
        guard let contact = try? decoder.decode(Contact.self, from: data) else { return nil }
        name = contact.name
        surname = contact.surname
        phoneNumber = contact.phoneNumber
        image = contact.image
        favorite = contact.favorite
    }

    init(name: String, surname: String, phoneNumber: String, image: Data?, favorite: Bool) {
        self.name = name
        self.surname = surname
        self.phoneNumber = phoneNumber
        self.image = image
        self.favorite = favorite
    }

}
