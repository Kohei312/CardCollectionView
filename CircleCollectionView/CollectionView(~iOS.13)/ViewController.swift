//
//  ViewController.swift
//  CircleCollectionView
//
//  Created by kohei yoshida on 2020/10/10.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDropDelegate, UICollectionViewDragDelegate {
    
    var hogeList = HogeList()
    var throwoutCardList = ThrowoutCardList()
    var cpuCardList = CPUCardList()
    var removedIndexPath = IndexPath()
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var throwoutCardsCollectionView: UICollectionView!
    @IBOutlet weak var cpuCardCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardCollectionView.registerCell(CollectionViewCell.self)
        cardCollectionView.registerLayout(layout: CollectionViewLayout())
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        cardCollectionView.dropDelegate = self
        cardCollectionView.dragDelegate = self
        cardCollectionView.dragInteractionEnabled = true
        
        throwoutCardsCollectionView.registerCell(ThrowoutCardsCollectionViewCell.self)
        throwoutCardsCollectionView.registerLayout(layout: ThrowOutCardsCollectionViewLayout())
        throwoutCardsCollectionView.delegate = self
        throwoutCardsCollectionView.dataSource = self
        throwoutCardsCollectionView.dropDelegate = self
        throwoutCardsCollectionView.dragInteractionEnabled = true
        
        cpuCardCollectionView.registerCell(CPUCardsCollectionViewCell.self)
        cpuCardCollectionView.registerLayout(layout: CPUCardsCollectionViewLayout())
        cpuCardCollectionView.delegate = self
        cpuCardCollectionView.dataSource = self
        
        // CPUモーションを制御
                // カードが入る
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.cpuCardCollectionView.performBatchUpdates({
                        self.cpuCardList.cpuCardList.insert(Hoge(data:"huga"),at: IndexPath(item: 1, section: 0).row)
                        self.cpuCardCollectionView.insertItems(at: [IndexPath(item: self.cpuCardList.cpuCardList.count - 1, section: 0)])
                    })
                    var updateIndexes = self.cpuCardCollectionView.indexPathsForVisibleItems
                    updateIndexes.append(self.removedIndexPath)
                    self.cpuCardCollectionView.reloadItems(at: updateIndexes)
                }
        
                // カードが抜ける
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.cpuCardCollectionView.performBatchUpdates({
                        self.removedIndexPath = IndexPath(item: 0, section: 0)
                        let removeItem = self.cpuCardList.cpuCardList.remove(at: self.removedIndexPath.row)
                        self.throwoutCardList.throwoutCardList.append(removeItem)
                        self.cpuCardCollectionView.deleteItems(at: [self.removedIndexPath])
                    })
                    
                    self.throwoutCardsCollectionView.performBatchUpdates({
                        self.throwoutCardsCollectionView.insertItems(at: [IndexPath(row: self.throwoutCardList.throwoutCardList.count - 1, section: 0)])
                    })
                    
                }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView{
        case cardCollectionView:
            return hogeList.hogeList.count
        case throwoutCardsCollectionView:
            return throwoutCardList.throwoutCardList.count
        case cpuCardCollectionView:
            return cpuCardList.cpuCardList.count
        default:
            return hogeList.hogeList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView{
        case cardCollectionView:
            let cell = collectionView.dequeueReusableCell(with: CollectionViewCell.self, indexPath: indexPath)
            cell.nameLabel.text = hogeList.hogeList[indexPath.row].data
            cell.contentView.backgroundColor = UIColor().cellColor(indexPath)
            return cell
        case throwoutCardsCollectionView:
            let cell = collectionView.dequeueReusableCell(with: ThrowoutCardsCollectionViewCell.self, indexPath: indexPath)
            cell.contentView.backgroundColor = UIColor().cellColor(indexPath)
            return cell
        case cpuCardCollectionView:
            let cell = collectionView.dequeueReusableCell(with: CPUCardsCollectionViewCell.self, indexPath: indexPath)
            cell.contentView.backgroundColor = UIColor().cellColor(indexPath)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(with: CollectionViewCell.self, indexPath: indexPath)
            cell.nameLabel.text = hogeList.hogeList[indexPath.row].data
            cell.contentView.backgroundColor = UIColor().cellColor(indexPath)
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        switch coordinator.proposal.operation {
        case .move:
            guard
                let destinationIndexPath = coordinator.destinationIndexPath,
                let sourceIndexPath = coordinator.items.first?.sourceIndexPath,
                let sourceDragItem = coordinator.items.first?.dragItem
            else { return }
            
            // データソースを更新する
            let sourceItem = hogeList.hogeList.remove(at: sourceIndexPath.item)
            hogeList.hogeList.insert(sourceItem, at: destinationIndexPath.item)
            
            self.cardCollectionView.performBatchUpdates({
                self.cardCollectionView.deleteItems(at: [sourceIndexPath])
                self.cardCollectionView.insertItems(at: [destinationIndexPath])
            })
            coordinator.drop(sourceDragItem, toItemAt: destinationIndexPath)
            
            var updateIndexes = collectionView.indexPathsForVisibleItems
            updateIndexes.append(sourceIndexPath)
            self.cardCollectionView.reloadItems(at: updateIndexes)
 
        case .copy:
            // データソースを更新する
            let sourceItem = hogeList.hogeList.remove(at: removedIndexPath.row)
            let newItem = Hoge(data: "new")
            hogeList.hogeList.append(newItem)

            
            self.cardCollectionView.performBatchUpdates({
                self.cardCollectionView.deleteItems(at: [removedIndexPath])
                self.cardCollectionView.insertItems(at: [IndexPath(item: hogeList.hogeList.count - 1, section: 0)])
            })
            
            // データソースを更新する
            if collectionView == throwoutCardsCollectionView{
                self.throwoutCardList.throwoutCardList.append(sourceItem)
            }
            
            self.throwoutCardsCollectionView.performBatchUpdates({
                self.throwoutCardsCollectionView.insertItems(at: [IndexPath(row: self.throwoutCardList.throwoutCardList.count - 1, section: 0)])
            })

            
            
            var updateIndexes = collectionView.indexPathsForVisibleItems
            updateIndexes.append(removedIndexPath)
            self.cardCollectionView.reloadItems(at: updateIndexes)
 
        case .cancel, .forbidden:
            return
        @unknown default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let id = hogeList.hogeList[indexPath.item].id
        let itemProvider = NSItemProvider(object: id.rawValue)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        removedIndexPath = indexPath
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        var dropProposal = UICollectionViewDropProposal(operation: .cancel)
        
        if session.localDragSession != nil {
            // 内部からのドロップなら並び替えする
            switch collectionView{
            case cardCollectionView:
                dropProposal = UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            case throwoutCardsCollectionView:
                dropProposal = UICollectionViewDropProposal(operation: .copy, intent:.insertAtDestinationIndexPath)
            default:break
            }
            
        } else {
            // 外部からのドロップならキャンセルする
                dropProposal = UICollectionViewDropProposal(operation: .cancel)

        }
        return dropProposal
    }
}



