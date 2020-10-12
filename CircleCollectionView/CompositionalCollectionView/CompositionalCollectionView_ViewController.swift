//
//  CompositionalCollectionView_ViewController.swift
//  CircleCollectionView
//
//  Created by kohei yoshida on 2020/10/10.
//

import UIKit

enum Section{
    case main
}

class CompositionalCollectionView_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDropDelegate, UICollectionViewDragDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    // MARK:- ジェネリクスに、それぞれ<Sectionに入れる型, IndexPathに入れる型>を指定する
    var dataSource: UICollectionViewDiffableDataSource<Section, Hoge>! = nil
    // footerに挿入するオブジェクトをstaticで宣言
    static let footerElementKind = "タイトルインスタンス生成用の仮文字列"
    var hogeList = HogeList()
    private var property = CardLayoutProperty()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        property.center = CGPoint(x: collectionView.bounds.midX + (collectionView.bounds.midX / 1.5) , y: collectionView.bounds.maxY)
        let shortAxisLength = min(collectionView.bounds.width, collectionView.bounds.height)
        // 正方形を作成 -> 円の直径をshortAxisLengthに設定
        property.itemSize = CGSize(width: shortAxisLength, height: shortAxisLength)
        property.radius = shortAxisLength
        property.numberOfItems = collectionView.numberOfItems(inSection: 0)
        
        // MARK:- 1. Layoutを指定
        collectionView.collectionViewLayout = createLayout()
        
        
        // MARK:- 2. CollectionViewCellを初期化
        collectionView.registerCell(CollectionViewCell.self)
        
        // MARK:- 4. CollectionViewCellの生成へ.
        self.setupAlbumCollectionView()
        
        // MARK:- 3. DataSourceを初期化
        self.configureDataSource()
        
        
        
        collectionView.delegate = self
        collectionView.dropDelegate = self
        collectionView.dragDelegate = self
        collectionView.dragInteractionEnabled = true
        
    }
    
    // MARK:- 1. Layoutを指定
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            // Itemのサイズ設定
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                                   heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading:  5, bottom: 5, trailing: 5)
        
            // Groupのサイズ設定
            let nestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.33)),
                subitems: [item,item,item,item,item])
            
            // Sectionのサイズ設定
            let section = NSCollectionLayoutSection(group: nestedGroup)

            return section
            
        }

        
        return layout
    }
    
    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        // MARK:- 2π * (item)番目のindexPath / collectionViewの1セクション内に格納されたアイテム数
        // 1/4円の長さ
        let circleLength = (.pi * 2 * CGFloat(indexPath.item)) / 3
        let angle = circleLength / CGFloat(property.numberOfItems)
                
        attributes.center = CGPoint(x: property.center.x - ( property.radius * sin(angle) / 2 ), y: property.center.y - ( property.radius * cos(angle) / 2.5 ) )
        attributes.size = CGSize(width: property.itemSize.width / 2, height: property.itemSize.height)
        attributes.transform = attributes.transform.rotated(by: 270 - (angle/2))
        
        return attributes
    }
    
    // MARK:- DataSourceの引数内でCellを初期化()(cellForRowAtの役割を含む, というか勝手に内部でやってくれている)
    func setupAlbumCollectionView(){
        // UICollectionViewDiffableDataSourceの第一引数に, 初期化するCollectionViewインスタンスを入れる.
        // 第二引数はcallbackとなっており、クロージャ内でCellProviderに準じた引数を指定してCellを返す処理を入れる.
        dataSource = UICollectionViewDiffableDataSource
        <Section, Hoge>(collectionView: collectionView) {
            // public typealias CellProvider = (UICollectionView, IndexPath, ItemIdentifierType) -> UICollectionViewCell?
            (collectionView: UICollectionView, indexPath: IndexPath, hoge:Hoge) -> UICollectionViewCell? in
            
            // MARK:- 4.1 ここでCellの初期化.
            
            let cell = collectionView.dequeueReusableCell(with: CollectionViewCell.self, indexPath: indexPath)
            cell.nameLabel.text = hoge.data
            return cell
        }
    }
    
    // MARK:- 3. DataSourceを初期化
    func configureDataSource() {
        // MARK:- 3-1 DataSourceに入れるデータをここで初期化(DataSourceプロトコルの処理)
        var snapshot = NSDiffableDataSourceSnapshot<Section, Hoge>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(hogeList.hogeList)
        self.dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    
    
    // MARK:- データを入れ替えるときは、snapshotをdelete -> deleteをapply -> snapshotにappend -> appendをapply
    func refreshAllDataSource(){
        var snapshot = self.dataSource.snapshot()
        print("その他")
        hogeList.hogeList = []
        snapshot.deleteSections([Section.main])
        snapshot.deleteAllItems()
        self.dataSource.apply(snapshot, animatingDifferences: true){
            self.hogeList.hogeList.append(Hoge(data: "huga"))
            snapshot.appendSections([Section.main])
            snapshot.appendItems(self.hogeList.hogeList)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    // データの追加処理
    func insertDataSource(){
        var snapshot = self.dataSource.snapshot()
        var items = snapshot.itemIdentifiers // ???
        
        // MARK:- insertItemsの第一引数：新たに入れるアイテム, 第二引数:入れるアイテムのインスタンス
        if let lastItem = hogeList.hogeList.last{
            let newHoge = Hoge(data: "insertHoge")
            self.hogeList.hogeList.append(newHoge)
            snapshot.insertItems([newHoge], afterItem: lastItem)
            self.dataSource.apply(snapshot, animatingDifferences: true){
                items = snapshot.itemIdentifiers
            }
        }
    }
    
    // MARK:- データを追加するときは、プロパティのデータをまず更新したあとに、snapshotへ追加 -> applyをコールする
    func updateDataSource() {
        print("updateDatasourceがよばれた")
        // 1. 初期値のSnapshotの生成
        
        var snapshot = self.dataSource.snapshot()
        // 2. 情報の追加
        //                    print("現在のsectionは\(snapshot.sectionIdentifiers)")
        let newHoge = Hoge(data: "insertHoge")
        hogeList.hogeList.append(newHoge)
        snapshot.appendItems([newHoge], toSection: Section.main)
        // 3. applyでUIに反映
        self.dataSource.apply(snapshot, animatingDifferences: true)        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: \(indexPath)")
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        switch coordinator.proposal.operation {
        case .move:
            guard
                let destinationIndexPath = coordinator.destinationIndexPath,
                let sourceIndexPath = coordinator.items.first?.sourceIndexPath
            else { return }
            
            // データソースを更新する
            let sourceItem = hogeList.hogeList.remove(at: sourceIndexPath.item)
            hogeList.hogeList.insert(sourceItem, at: destinationIndexPath.item)
            
            var snapshot = NSDiffableDataSourceSnapshot<Section, Hoge>()
            snapshot.appendSections([.main])
            snapshot.appendItems(hogeList.hogeList)
            dataSource.apply(snapshot, animatingDifferences: false)
        case .cancel, .forbidden, .copy:
            return
        @unknown default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let id = hogeList.hogeList[indexPath.item].id
        let itemProvider = NSItemProvider(object: id.rawValue)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if session.localDragSession != nil {
            // 内部からのドロップなら並び替えする
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            // 外部からのドロップならキャンセルする
            return UICollectionViewDropProposal(operation: .cancel)
        }
    }
    
    
    
    
    //    // MARK:- データを追加するときは、プロパティのデータをまず更新したあとに、snapshotへ追加 -> applyをコールする
    //    func updateDataSource() {
    //        print("updateDatasourceがよばれた")
    //
    //        if let groupId = setupUserCollection.setupUserData.last?.groupId,
    //           let date = albumCollection.albumData.last?.uploadAt.dateValue() {
    //            albumCollection.updateImagePath(date:date,groupId:groupId) { albumData in
    //                if albumData != []{
    //                    // 1. 初期値のSnapshotの生成
    //
    //                    var snapshot = self.dataSource.snapshot()
    //                    // 2. 情報の追加
    //                    //                    print("現在のsectionは\(snapshot.sectionIdentifiers)")
    //                    snapshot.appendItems(albumData, toSection: Section.main)
    //
    //                    // 3. applyでUIに反映
    //                    self.dataSource.apply(snapshot, animatingDifferences: true)
    //                    //                    guard let refreshControl = self.collectionView.refreshControl else {return}
    //                    //                    refreshControl.endRefreshing()
    //
    //
    //                }
    //            }
    //        }
    //    }
    
    
    // MARK:- collectionViewDelegateメソッドを、これまで通りindexPathを使用して活用加納
    //    func collectionView(_ collectionView:UICollectionView, didSelectItemAt indexPath:IndexPath){
    //        //    collectionView.deselectItem（at：indexPath, animated：true）
    //        guard let albumData = dataSource.itemIdentifier(for: indexPath) else {return}
    //        switch albumData.mediaType{
    //        case "photo":
    //            print("photo処理を呼ぶ")
    //            self.segueToSelectedPhotoVC(albumData:albumData)
    //        case "movie":
    //            print("movie処理を呼ぶ")
    //            selectMovie(albumData:albumData)
    //        case "voice":
    //            print("voice処理を呼ぶ")
    //            selectVoice(albumData:albumData,collectionView: collectionView,at: indexPath)
    //        default:
    //            break
    //        }
    //
    //
    //    }
    
}
