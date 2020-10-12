////
////  CompositionalViewController.swift
////  CircleCollectionView
////
////  Created by kohei yoshida on 2020/10/10.
////
//
//import UIKit
//
//class CompositionalViewController: UIViewController,UICollectionViewDelegate {
//
//
//
//    @IBOutlet weak var collectionView: UICollectionView!
//    // MARK:- ジェネリクスに、それぞれ<Sectionに入れる型, IndexPathに入れる型>を指定する
//    var dataSource: UICollectionViewDiffableDataSource<Section, Album>! = nil
//    // footerに挿入するオブジェクトをstaticで宣言
//    static let footerElementKind = "タイトルインスタンス生成用の仮文字列"
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("viewDidLoadします")
//        isModalInPresentation = true
//
//        // MARK:- 1. Layoutを指定
//        collectionView.collectionViewLayout = createLayout()
//
//        // MARK:- 2. CollectionViewCellを初期化
//        configureCollectionView()
//
//        if dataSource != nil {
//
//            print("reloadします")
//            updateDataSource()
//
//        } else {
//            print("データソースが空")
//
//            // MARK:- 3. DataSourceを初期化
//            self.configureDataSource()
//        }
//
//
//        collectionView.delegate = self
//
//    }
//
//    // MARK:- 1. Layoutを指定
//    func createLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout {
//            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//
//            // Itemのサイズ設定
//            let item = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
//                                                   heightDimension: .fractionalHeight(1.0)))
//            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading:  5, bottom: 5, trailing: 5)
//
//
//            // Groupのサイズ設定
//            let nestedGroup = NSCollectionLayoutGroup.horizontal(
//                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                   heightDimension: .fractionalHeight(0.33)),
//                subitems: [item,item])
//
//            // Sectionのサイズ設定
//            let section = NSCollectionLayoutSection(group: nestedGroup)
//            return section
//
//        }
//        return layout
//    }
//
//    // MARK:- 2. CollectionViewCellを初期化
//    func configureCollectionView(){
//        let nib = UINib(nibName: "AlbumHomeCollectionViewCell", bundle: nil)
//        collectionView.register(nib, forCellWithReuseIdentifier: "albumCell")
//    }
//
//    // MARK:- DataSourceの引数内でCellを初期化()(cellForRowAtの役割を含む, というか勝手に内部でやってくれている)
//    func setupAlbumCollectionView(){
//        // UICollectionViewDiffableDataSourceの第一引数に, 初期化するCollectionViewインスタンスを入れる.
//        // 第二引数はcallbackとなっており、クロージャ内でCellProviderに準じた引数を指定してCellを返す処理を入れる.
//        dataSource = UICollectionViewDiffableDataSource
//            <Section, Album>(collectionView: collectionView) {
//                // public typealias CellProvider = (UICollectionView, IndexPath, ItemIdentifierType) -> UICollectionViewCell?
//                (collectionView: UICollectionView, indexPath: IndexPath, albumData:Album) -> UICollectionViewCell? in
//
//            // MARK:- 4.1 ここでCellの初期化.
//
//                let cell = collectionView.dequeueReusableCell(
//                    withReuseIdentifier:"albumCell",
//                    for: indexPath) as! AlbumHomeCollectionViewCell
//                cell.delegate = self
//
//
//                return cell
//        }
//    }
//
//    // MARK:- 3. DataSourceを初期化
//    // albumData:[Album]
//    func configureDataSource() {
//        DispatchQueue.main.async {
//            // MARK:- 4. CollectionViewCellの生成へ.
//            self.setupAlbumCollectionView()
//
//
//            // MARK:- 3-1 DataSourceに入れるデータをここで初期化(DataSourceプロトコルの処理)
//            if let groupId = self.setupUserCollection.setupUserData.last?.groupId {
//
//                let currentAlbumData = self.albumCollection.albumData
//                self.albumCollection.loadImagePath(groupId:groupId) { returnData in
//
//                    let newAlbumData = self.albumCollection.albumData
//
//                    if currentAlbumData == [] && newAlbumData == [] {
//                        self.emptyAnimation(layoutView: self.collectionView)
//                    } else {
//
//                        if let animationView = self.emptyAnimationView{
//                            animationView.stop()
//                            animationView.removeFromSuperview()
//                            self.emptyLabel.removeFromSuperview()
//                        }
//
//                        if self.dataSource != nil{
//                            // MARK:- データ更新時は、DiffableDataSourceのプロパティ・snapshotを呼び出して追加・更新・削除を行う
//                            // MARK:- snapshotのデータ処理を終えたあと、最後にapplyプロパティをコールする(引数にsnapshotを入れる)
//                                                    print("データソースがあったので更新します")
//                            var snapshot = self.dataSource.snapshot()
//                            let itemCount = snapshot.itemIdentifiers.count
//
//                            if snapshot.numberOfSections == 0 && newAlbumData != []{
//                                                            print("snapshot内のsectionが0,始めてアルバムにアップロードします")
//                                snapshot.appendSections([Section.main])
//                                snapshot.appendItems(newAlbumData)
//                                self.dataSource.apply(snapshot, animatingDifferences: true)
//                            }
//
//                            else if snapshot.numberOfSections != 0, itemCount != 0{
//                                // ひとまずこれで様子をみる
//                                                            print("snapshot内のsectionがあり、すでにデータがある \n 最新データを一つ追加します")
//                                returnData.forEach { (addData) in
//                                    var items = snapshot.itemIdentifiers
//                                    if let insertItem = items.last{
//                                        snapshot.insertItems([addData], afterItem: insertItem)
//                                        self.dataSource.apply(snapshot, animatingDifferences: true){
//                                            items = snapshot.itemIdentifiers
//                                        }
//                                    }
//                                }
//                            } else {
//                                                            print("その他")
//                                snapshot.deleteSections([Section.main])
//                                snapshot.deleteAllItems()
//                                self.dataSource.apply(snapshot, animatingDifferences: true){
//                                    snapshot.appendSections([Section.main])
//                                    snapshot.appendItems(newAlbumData)
//                                    self.dataSource.apply(snapshot, animatingDifferences: true)
//                                }
//                            }
//                        } else {
//                                                    print("データソースがなかったので作ります")
//                            var snapshot = NSDiffableDataSourceSnapshot<Section, Album>()
//                            snapshot.appendSections([Section.main])
//                            snapshot.appendItems(newAlbumData)
//                            self.dataSource.apply(snapshot, animatingDifferences: true)
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//
//
//    func reloadDataSource() {
//
//        if let groupId = setupUserCollection.setupUserData.last?.groupId,
//            let date = albumCollection.albumData.last?.uploadAt.dateValue() {
//            albumCollection.reloadImagePath(date:date,groupId:groupId) { albumData in
//                if albumData == []{
//                    guard let refreshControl = self.collectionView.refreshControl else {return}
//                    refreshControl.endRefreshing()
//                } else {
//                    // 1. 初期値のSnapshotの生成
//
//                    var snapshot = self.dataSource.snapshot()
//                    // 2. 情報の追加
//                    //                    print("現在のsectionは\(snapshot.sectionIdentifiers)")
//                    snapshot.appendItems(albumData)
//
//                    // 3. applyでUIに反映
//                    self.dataSource.apply(snapshot, animatingDifferences: true)
//                    guard let refreshControl = self.collectionView.refreshControl else {return}
//                    refreshControl.endRefreshing()
//
//
//                }
//            }
//        }
//    }
//
//    func updateDataSource() {
//        print("updateDatasourceがよばれた")
//        if let groupId = setupUserCollection.setupUserData.last?.groupId,
//            let date = albumCollection.albumData.last?.uploadAt.dateValue() {
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
//
//
//    // MARK:- collectionViewDelegateメソッドを、これまで通りindexPathを使用して活用加納
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
//
//}
