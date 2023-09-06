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
            let exchangeController = ExchangeController()
            let translateController = TranslateController()
            let weatherViewController = WeatherPageViewController()

            exchangeController.tabBarItem = UITabBarItem(title: "Convertisseur", image: UIImage(systemName: "dollarsign.circle")!, tag: 0)
            translateController.tabBarItem = UITabBarItem(title: "Traduction", image: UIImage(named: "translate"), tag: 1)
            weatherViewController.tabBarItem = UITabBarItem(title: "Météo", image: UIImage(systemName: "thermometer.sun")!, tag: 2)

           viewControllers = [exchangeController, translateController, weatherViewController]

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
