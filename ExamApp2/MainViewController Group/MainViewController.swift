//
//  MainViewController.swift
//  ExamApp2
//
//  Created by Vladislav McKay on 7/22/20.
//  Copyright © 2020 Vladislav McKay. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    static let layout = UICollectionViewFlowLayout()
    
    var collectionViewRefreshControl: UIRefreshControl = UIRefreshControl()
     var urlSession: URLSession!
    let nm = NetworkManager()
    let fm = FilterManager()
    
    let collectionView: UICollectionView = {
        
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CollectionViewPersonCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .white
        return cv
    }()
    
    let fullInfoViewController: UIViewController = UIViewController()
    
    @IBOutlet weak var segmentedPresentationControl: UISegmentedControl!
    @IBOutlet weak var segmentedGenderControl: UISegmentedControl!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    let progress = Progress(totalUnitCount: 10)
    var myCells: [CollectionViewPersonCell] = []
    
    var allPeople: [Person] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var currentPeople: [Person] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupToolbars()
        self.collectionView.isHidden = true
        
        loadIndicator.center = view.center
        loadIndicator.isHidden = false
        loadIndicator.startAnimating()
     
        loadPeople()
        
        self.collectionViewRefreshControl = UIRefreshControl()
        self.collectionView.alwaysBounceVertical = true
        
        let myString = "Pull to refresh"
        let myAttribute = [NSAttributedString.Key.foregroundColor: UIColor.systemTeal]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        collectionViewRefreshControl.attributedTitle = myAttrString
        collectionViewRefreshControl.addTarget(self, action: #selector(self.handleRefresh), for: UIControl.Event.valueChanged)
        self.collectionView.addSubview(collectionViewRefreshControl)
        
        self.setupCollectionView()
        
        segmentedGenderControl.selectedSegmentIndex = 2
        
        self.segmentedPresentationControl.selectedSegmentIndex = 0
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    
    func loadPeople() {
        self.nm.getPeople(urlSession: self.urlSession) { result in
                 
                 if result[0].age != -200 {
                     self.currentPeople = result
                     self.allPeople = result
                     MainViewController.layout.itemSize = CGSize(width: self.collectionView.frame.width, height: 96)
                     self.loadIndicator.stopAnimating()
                     self.loadIndicator.isHidden = true
                     self.collectionView.isHidden = false
                 } else {
                     let alertController = UIAlertController(title: "JSON Error", message: "Data Error Has Occured", preferredStyle: .alert)
                     let alertAction = UIAlertAction(title: "OK", style: .default, handler: .none)
                     alertController.addAction(alertAction)
                     self.present(alertController, animated: true)
                    self.loadIndicator.isHidden = true
                  
                  }
             }
    }
    
    @objc func handleRefresh() {
        allPeople.removeAll()
        currentPeople.removeAll()
        
       loadPeople()
        
        segmentedGenderControl.selectedSegmentIndex = 2
        self.collectionView.reloadData()
        
    }
    
    @IBAction func filterByGender(sender: Any) {
        switch segmentedGenderControl.selectedSegmentIndex {
        case 0: self.currentPeople = fm.filterGender(fromThese: allPeople, with: .onlyMales)
        case 1: self.currentPeople = fm.filterGender(fromThese: allPeople, with: .onlyFemales)
        case 2: self.currentPeople = fm.filterGender(fromThese: allPeople, with: .allGenders)
        default : return
        }
    }
    
    @IBAction func rearrange(sender: Any) {
        if (currentPeople.first?.age)! > (currentPeople.last?.age)! {
            currentPeople = fm.filterAgeValues(fromThese: currentPeople, with: .ascent)
        } else   {
            currentPeople = fm.filterAgeValues(fromThese: currentPeople, with: .descent)
        }
    }
    
    @IBAction func changePresentationStyle(sender: Any) {
        switch segmentedPresentationControl.selectedSegmentIndex {
        case 1: MainViewController.layout.itemSize = CGSize(width: collectionView.frame.width / 3.2, height: 128)
        case 0: MainViewController.layout.itemSize = CGSize(width: collectionView.frame.width, height: 96)
        default: return
        }
        collectionView.reloadData()
        
    }
    
    func setupToolbars() {
        view.addSubview(topToolBar)
        view.addSubview(bottomToolBar)
        
        topToolBar.translatesAutoresizingMaskIntoConstraints = false
        topToolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        topToolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        topToolBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        
        bottomToolBar.translatesAutoresizingMaskIntoConstraints = false
        bottomToolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bottomToolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        bottomToolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        collectionView.topAnchor.constraint(equalTo: topToolBar.bottomAnchor, constant: 8).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomToolBar.topAnchor, constant: -8).isActive = true
    }
    
    
    
    
}

extension MainViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentPeople.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch self.segmentedPresentationControl.selectedSegmentIndex {
        case 0 : return CGSize(width: 128, height: 128)
        case 1 : return CGSize(width: 400, height: 128)
        default: return CGSize(width: 400, height: 400)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)  as? CollectionViewPersonCell
        cell?.person(person: currentPeople[indexPath.row])
        self.myCells.append(cell!)
        return cell!
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vcToPop = FullInfoViewController()
        vcToPop.currentPerson = currentPeople[indexPath.row]
        vcToPop.modalPresentationStyle = .popover
        show(vcToPop, sender: self)
        
        if vcToPop.isViewLoaded {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
}


