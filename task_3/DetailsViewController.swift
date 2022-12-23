//
//  DetailsViewController.swift
//  task_3
//
//  Created by Artem Sulzhenko on 23.12.2022.
//

import UIKit

class DetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        let navigationBar = navigationController?.navigationBar
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .white

        navigationBar?.standardAppearance = navBarAppearance
        navigationBar?.scrollEdgeAppearance = navBarAppearance
    }

}
