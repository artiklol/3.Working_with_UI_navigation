//
//  String+Ex.swift
//  task_3
//
//  Created by Artem Sulzhenko on 25.12.2022.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self
        )
    }
}
