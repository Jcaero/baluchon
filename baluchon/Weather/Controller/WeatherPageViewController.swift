//
//  WeatherPageViewController.swift
//  baluchon
//
//  Created by pierrick viret on 03/09/2023.
//

import UIKit

enum Pages: CaseIterable {
    case pageZero
    case pageOne

    var city: City {
        switch self {
        case .pageZero:
            return City(name: "New York", coord: Coord(lat: 40.7127281, lon: -74.0060152), country: "US", sunrise: nil, sunset: nil)
        case .pageOne:
            return City(name: "Annecy", coord: Coord(lat: 45.8992, lon: 6.1289), country: "FR", sunrise: nil, sunset: nil)
        }
    }

    var index: Int {
        switch self {
        case .pageZero:
            return 0
        case .pageOne:
            return 1
        }
    }
}

class WeatherPageViewController: UIViewController {

    private var pageController: UIPageViewController?
    private var pages: [Pages] = Pages.allCases
    private var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .lightGray

        self.setupPageController()
    }

    private func setupPageController() {

        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.backgroundColor = .clear
        self.pageController?.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
        self.addChild(self.pageController!)
        self.view.addSubview(self.pageController!.view)

        let initialVC = WeatherViewController(with: pages[0])

        self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)

        self.pageController?.didMove(toParent: self)
    }
}

extension WeatherPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let currentVC = viewController as? WeatherViewController else {
            return nil
        }

        var index = currentVC.page.index

        if index == 0 {
            return nil
        }

        index -= 1

        let vc: WeatherViewController = WeatherViewController(with: pages[index])

        return vc
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let currentVC = viewController as? WeatherViewController else {
            return nil
        }

        var index = currentVC.page.index

        if index >= self.pages.count - 1 {
            return nil
        }

        index += 1

        let vc: WeatherViewController = WeatherViewController(with: pages[index])

        return vc
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
}
