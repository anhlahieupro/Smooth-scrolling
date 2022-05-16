//
//  ViewController.swift
//  Smooth scrolling
//
//  Created by pros on 5/16/22.
//

import UIKit
import IGListKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var objects = [ListDiffable]()
    private var adapter: ListAdapter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initObjects()
        initAdapter()
    }
    
    private func initObjects() {
        objects.append(contentsOf: [Model1(text: "1"),
                                    Model2(title: "2"),
                                    Model1(text: "3"),
                                    Model2(title: "4"),
                                    Model1(text: "5"),
                                    Model2(title: "6")] as [ListDiffable])
    }
    
    private func initAdapter() {
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.isPagingEnabled = true
        
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    @IBAction func loadMoreAction(_ sender: Any) {
        if objects.count % 2 == 0 {
            objects.append(contentsOf: [Model1(text: "\(objects.count + 1)")] as [ListDiffable])
        } else {
            objects.append(contentsOf: [Model2(title: "\(objects.count + 1)")] as [ListDiffable])
        }
        
        adapter.performUpdates(animated: true, completion: nil)
    }
}

extension ViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Model1 {
            return SectionController1()
        }
        
        return SectionController2()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

class SectionController1: ListSectionController {
    var currentModel: Model1?
    
    override func didUpdate(to object: Any) {
        guard let model = object as? Model1 else { return }
        
        currentModel = model
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let ctx = collectionContext else {
            return UICollectionViewCell()
        }
        
        let nibName = String(describing: CollectionViewCell1.self)
        let cell = ctx.dequeueReusableCell(withNibName: nibName, bundle: nil, for: self, at: index)
        if let model = currentModel {
            (cell as? CollectionViewCell1)?.update(model: model)
        }
        
        return cell
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let window = UIApplication.shared.windows.first!
        let topPadding = window.safeAreaInsets.top
        let bottomPadding = window.safeAreaInsets.bottom
        
        return CGSize(width: UIScreen.main.bounds.width,
                      height: UIScreen.main.bounds.height - topPadding - bottomPadding - 44)
    }
}

class SectionController2: ListSectionController {
    var currentModel: Model2?
    
    override func didUpdate(to object: Any) {
        guard let model = object as? Model2 else { return }
        
        currentModel = model
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let ctx = collectionContext else {
            return UICollectionViewCell()
        }
        
        let nibName = String(describing: CollectionViewCell2.self)
        let cell = ctx.dequeueReusableCell(withNibName: nibName, bundle: nil, for: self, at: index)
        if let model = currentModel {
            (cell as? CollectionViewCell2)?.update(model: model)
        }
        
        return cell
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let window = UIApplication.shared.windows.first!
        let topPadding = window.safeAreaInsets.top
        let bottomPadding = window.safeAreaInsets.bottom
        
        return CGSize(width: UIScreen.main.bounds.width,
                      height: UIScreen.main.bounds.height - topPadding - bottomPadding - 44)
    }
}

class Model1: ListDiffable {
    private var identifier: String = UUID().uuidString
    private(set) var text: String
    
    init(text: String) {
        self.text = text
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Model1 else { return false }
        
        return self.identifier == object.identifier
    }
}

class Model2: ListDiffable {
    private var identifier: String = UUID().uuidString
    private(set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Model2 else { return false }
        
        return self.identifier == object.identifier
    }
}
