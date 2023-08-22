//
//  TabBarControlleur.swift
//  baluchon
//
//  Created by pierrick viret on 22/08/2023.
//

import UIKit

class TabBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVCs()
        setupTabBar()
    }

    func setupVCs() {

            let firstViewController = ExchangeController()

            let secondViewController = UIViewController()
        secondViewController.view.backgroundColor = .systemGray2
            let thirdViewController = UIViewController()
        thirdViewController.view.backgroundColor = .systemGray3

            // define title and items
            firstViewController.tabBarItem = UITabBarItem(title: "Convertisseur", image: UIImage(systemName: "dollarsign.circle")!, tag: 0)
            secondViewController.tabBarItem = UITabBarItem(title: "Deuxième", image: UIImage(systemName: "house")!, tag: 1)
            thirdViewController.tabBarItem = UITabBarItem(title: "Troisième", image: UIImage(systemName: "person")!, tag: 2)

           viewControllers = [firstViewController, secondViewController, thirdViewController]

      }

    func setupTabBar() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .whiteSmoke

            let normalAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.lightGray // Couleur normale des éléments
            ]

            let selectedAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black // Couleur normale des éléments
            ]

            appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes

            appearance.stackedLayoutAppearance.selected.iconColor = .black

            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance

        } else {
            self.tabBar.tintColor = .black
            self.tabBar.isTranslucent = false
            self.tabBar.barTintColor = .whiteSmoke
        }
    }
}
