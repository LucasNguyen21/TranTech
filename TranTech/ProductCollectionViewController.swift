//
//  ProductCollectionViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 14/11/17.
//  Copyright © 2017 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

private let reuseIdentifier = "ProductCell"
private let reuseHeaderIdentifier = "ProductListHeader"

class ProductCollectionViewController: UICollectionViewController {
    @IBOutlet var productCollectionView: UICollectionView!
    @IBOutlet weak var indicatorActivity: UIActivityIndicatorView!
    
    var productList = [productInfo]()
    var totalProduct: Int!
    var kindName: String!
    var categoryName: String!
    var mainCategoryName: String!

    var ref: DocumentReference? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.naviToTopView(notification:)), name: popToRootViewName, object: nil)
        
        totalProduct = 0
        navigationItem.backBarButtonItem?.title = "Back"
        let itemSize = (UIScreen.main.bounds.width - 30)/2
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        layout.itemSize = CGSize(width: itemSize, height: itemSize + 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.headerReferenceSize = CGSize(width: itemSize, height: 100)
        
        productCollectionView.collectionViewLayout = layout
        
        productCollectionView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        indicatorActivity.hidesWhenStopped = true
        
        //productImageArray = []
        if mainCategoryName == "WIRELESS AP" || mainCategoryName == "MONITORS"{
            navigationItem.title = mainCategoryName
            loadType1Data(mainCategoryName: mainCategoryName)
        }
        
        if mainCategoryName == "ACCESS CONTROL" {
            navigationItem.title = categoryName
            loadType2Data(mainCategoryName: mainCategoryName, categoryName: categoryName)
        }

        
        if mainCategoryName == "POWER SYSTEM" ||  mainCategoryName == "INTERCOMS" || mainCategoryName == "ACCESSORIES" || mainCategoryName == "ALARM SYSTEM" {
            navigationItem.title = categoryName
            loadType2Data(mainCategoryName: mainCategoryName, categoryName: categoryName)
        }
        
        if mainCategoryName == "FHD ANALOG" || mainCategoryName == "IP NETWORK SYSTEM" {
            if categoryName == "4K NETWORK CAMERA" || categoryName == "OEM IPC" || categoryName == "IP NETWORK PTZ"
            || categoryName == "FHD ANALOG CAMERA" || categoryName == "HD ANALOG CAMERA" || categoryName == "FHD SDI CAMERA" || categoryName == "CVI-AHD PTZ"
            {
                navigationItem.title = categoryName
                loadType2Data(mainCategoryName: mainCategoryName, categoryName: categoryName)
            }else{
                navigationItem.title = kindName
                loadType3Data(mainCategoryName: mainCategoryName, categoryName: categoryName, kindName: kindName)
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let loginButton: UIBarButtonItem = UIBarButtonItem(title: "Home",style: .plain,target: self,action: #selector(loginAction))
        self.navigationItem.rightBarButtonItem = loginButton

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        productCollectionView.reloadData()
    }
    
    func loginAction(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    func loadType1Data(mainCategoryName: String){
        indicatorActivity.startAnimating()
        let defaultStore = Firestore.firestore()
        productList = []
    defaultStore.collection("PRODUCT").document("DEFAULT").collection(mainCategoryName).document(mainCategoryName).collection(mainCategoryName).getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let array = document.data() as NSDictionary
                    
                    let pName = document.documentID
                    let pPrice: Double!
                    let pPrice2: Double!
                    let pPrice3: Double!
                    let pDesc: String!
                    let pSpec: String!
                    let pGenDesc: String!
                    let pPriority: String!
                    let pDriver: String!
                    
                    if let price = array.object(forKey: "Price3"){
                        pPrice3 = (price as! NSString).doubleValue
                    }
                    else {
                        pPrice3 = 0
                    }
                    if let price = array.object(forKey: "Price2"){
                        pPrice2 = (price as! NSString).doubleValue
                    }
                    else {
                        pPrice2 = 0
                    }
                    if let price = array.object(forKey: "Price"){
                        pPrice = (price as! NSString).doubleValue
                    }
                    else {
                        pPrice = 0
                    }
                    
                    if let desc = array.object(forKey: "Desc"){
                        pDesc = desc as! String
                    }
                    else {
                        pDesc = ""
                    }
                    
                    if let spec = array.object(forKey: "Spec"){
                        pSpec = spec as! String
                    }
                    else {
                        pSpec = ""
                    }
                    
                    if let genDesc = array.object(forKey: "gen_desc"){
                        pGenDesc = genDesc as! String
                    }else {
                        pGenDesc = ""
                    }
                    
                    if let priority = array.object(forKey: "priority"){
                        pPriority = priority as! String
                    }
                    else {
                        pPriority = ""
                    }
                    if let driver = array.object(forKey: "Driver") {
                        pDriver = driver as! String
                    } else {
                        pDriver = ""
                    }
                    
                    self.productList.append(productInfo.init(productName: pName, productDesc: pDesc, productPrice: pPrice, productPriceType2: pPrice2, productPriceType3: pPrice3, productSpec: pSpec, productFenDesc: pGenDesc, productPriority: pPriority, productDriver: pDriver))
                    self.productCollectionView.reloadData()
                }
                //Sort product
                self.totalProduct = self.productList.count
                self.productList.sort{ $0.productPriority > $1.productPriority }
                self.indicatorActivity.stopAnimating()
            }
        })
    }
    
    func loadType2Data(mainCategoryName: String, categoryName: String){
        indicatorActivity.startAnimating()
        let defaultStore = Firestore.firestore()
        productList = []
        defaultStore.collection("PRODUCT").document("DEFAULT").collection(mainCategoryName).document(categoryName).collection(categoryName).getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let array = document.data() as NSDictionary
                    let pName = document.documentID
                    let pPrice: Double!
                    let pPrice2: Double!
                    let pPrice3: Double!
                    let pDesc: String!
                    let pSpec: String!
                    let pGenDesc: String!
                    let pPriority: String!
                    let pDriver: String!
                    
                    if let price = array.object(forKey: "Price3"){
                        pPrice3 = (price as! NSString).doubleValue
                    }
                    else {
                        pPrice3 = 0
                    }
                    if let price = array.object(forKey: "Price2"){
                        pPrice2 = (price as! NSString).doubleValue
                    }
                    else {
                        pPrice2 = 0
                    }
                    
                    if let price = array.object(forKey: "Price"){
                        pPrice = (price as! NSString).doubleValue
                    }
                    else {
                        pPrice = 0
                    }
                    
                    if let desc = array.object(forKey: "Desc"){
                        pDesc = desc as! String
                    }
                    else {
                        pDesc = ""
                    }
                    
                    if let spec = array.object(forKey: "Spec"){
                        pSpec = spec as! String
                    }
                    else {
                        pSpec = ""
                    }
                    
                    if let genDesc = array.object(forKey: "gen_desc"){
                        pGenDesc = genDesc as! String
                    }else {
                        pGenDesc = ""
                    }
                    
                    if let priority = array.object(forKey: "priority"){
                        pPriority = priority as! String
                    }
                    else {
                        pPriority = ""
                    }
                    
                    if let driver = array.object(forKey: "Driver") {
                        pDriver = driver as! String
                    } else {
                        pDriver = ""
                    }
                    
                    self.productList.append(productInfo.init(productName: pName, productDesc: pDesc, productPrice: pPrice, productPriceType2: pPrice2, productPriceType3: pPrice3, productSpec: pSpec, productFenDesc: pGenDesc, productPriority: pPriority, productDriver: pDriver))
                    self.productCollectionView.reloadData()
                }
                //Sort Product
                self.totalProduct = self.productList.count
                self.productList.sort{ $0.productPriority > $1.productPriority }
                self.indicatorActivity.stopAnimating()
            }
        })
    }
    
    func loadType3Data(mainCategoryName: String, categoryName: String, kindName: String){
        indicatorActivity.startAnimating()
        let defaultStore = Firestore.firestore()
        productList = []
        defaultStore.collection("PRODUCT").document("DEFAULT").collection(mainCategoryName).document(categoryName).collection(kindName).getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let array = document.data() as NSDictionary
                    let pName = document.documentID
                    let pPrice: Double!
                    let pPrice2: Double!
                    let pPrice3: Double!
                    let pDesc: String!
                    let pSpec: String!
                    let pGenDesc: String!
                    let pPriority: String!
                    let pDriver: String!
                    
                    if let price = array.object(forKey: "Price3"){
                        pPrice3 = (price as! NSString).doubleValue
                    }
                    else {
                        pPrice3 = 0
                    }
                    if let price = array.object(forKey: "Price2"){
                        pPrice2 = (price as! NSString).doubleValue
                    }
                    else {
                        pPrice2 = 0
                    }
                    
                    if let price = array.object(forKey: "Price"){
                        pPrice = (price as! NSString).doubleValue
                    }
                    else {
                        pPrice = 0
                    }
                    
                    if let desc = array.object(forKey: "Desc"){
                        pDesc = desc as! String
                    }
                    else {
                        pDesc = ""
                    }
                    
                    if let spec = array.object(forKey: "Spec"){
                        pSpec = spec as! String
                    }
                    else {
                        pSpec = ""
                    }
                    
                    if let genDesc = array.object(forKey: "gen_desc"){
                        pGenDesc = genDesc as! String
                    }else {
                        pGenDesc = ""
                    }
                    
                    if let priority = array.object(forKey: "priority"){
                        pPriority = priority as! String
                    }
                    else {
                        pPriority = ""
                    }
                    
                    if let driver = array.object(forKey: "Driver") {
                        pDriver = driver as! String
                    } else {
                        pDriver = ""
                    }
                    
                    self.productList.append(productInfo.init(productName: pName, productDesc: pDesc, productPrice: pPrice, productPriceType2: pPrice2, productPriceType3: pPrice3, productSpec: pSpec, productFenDesc: pGenDesc, productPriority: pPriority, productDriver: pDriver))
                    
                    self.productCollectionView.reloadData()
                }
                self.totalProduct = self.productList.count
                self.productList.sort{ $0.productPriority > $1.productPriority }
                self.indicatorActivity.stopAnimating()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == productDetailSegue {
            let detailViewController: DetailsViewController = segue.destination as! DetailsViewController
            if let selectedCell = sender as? UICollectionViewCell{
                let indexPath = productCollectionView.indexPath(for: selectedCell)!
                //let selectedModel = productNameArray[indexPath.row]
                let selectedModel = productList[indexPath.row].productName
                detailViewController.modelName = selectedModel
                detailViewController.desc = productList[indexPath.row].productDesc
                
                detailViewController.spec = productList[indexPath.row].productSpec
                detailViewController.modelImage = selectedModel
                detailViewController.isDriver = productList[indexPath.row].productDriver
                if UserDefaults.standard.value(forKey: userTypeStandard) as! String == "DEFAULT"
                {
                    detailViewController.price = "0"
                }
                else if UserDefaults.standard.value(forKey: userTypeStandard) as! String == "TYPE1" {
                    detailViewController.price = String(productList[indexPath.row].productPrice)
                }
                else if UserDefaults.standard.value(forKey: userTypeStandard) as! String == "TYPE2" {
                    detailViewController.price = String(productList[indexPath.row].productPriceType2)
                }
                else if UserDefaults.standard.value(forKey: userTypeStandard) as! String == "TYPE3" {
                    detailViewController.price = String(productList[indexPath.row].productPriceType3)
                }
                else {
                    detailViewController.price = "1"
                }
            }
        }
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return productList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
        
        cell.productModelLabel.text = productList[indexPath.row].productName
        cell.productImage.image = UIImage(named: productList[indexPath.row].productName)
        cell.productGenDesc.text = productList[indexPath.row].productFenDesc
        
        if Auth.auth().currentUser != nil {
            if UserDefaults.standard.value(forKey: userTypeStandard) as! String == "DEFAULT" {
                cell.priceLabel.text = "$0 ex"
            }
            else if UserDefaults.standard.value(forKey: userTypeStandard) as! String == "TYPE1" {
                if productList[indexPath.row].productPrice == 0.0 {
                    cell.priceLabel.text = "$0 ex"
                }else {
                    cell.priceLabel.text = "$" + productList[indexPath.row].productPrice.cleanValue + " ex"
                }
            }
            else if UserDefaults.standard.value(forKey: userTypeStandard) as! String == "TYPE2" {
                if productList[indexPath.row].productPriceType2 == 0.0 {
                    cell.priceLabel.text = "$0 ex"
                }else {
                    cell.priceLabel.text = "$" + productList[indexPath.row].productPriceType2.cleanValue + " ex"
                }
            }else if UserDefaults.standard.value(forKey: userTypeStandard) as! String == "TYPE3" {
                if productList[indexPath.row].productPriceType3 == 0.0 {
                    cell.priceLabel.text = "$0 ex"
                }else {
                    cell.priceLabel.text = "$" + productList[indexPath.row].productPriceType3.cleanValue + " ex"
                }
            }else {
                cell.priceLabel.text = "$0 ex"
            }
        }else {
            cell.priceLabel.text = ""
        }
        
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! ProductHeaderCollectionReusableView
        if totalProduct > 1 {
            sectionHeaderView.productTotal.text = "Total " + String(totalProduct) + " Products"
        }else {
            sectionHeaderView.productTotal.text = "Total " + String(totalProduct) + " Product"
        }
        
        return sectionHeaderView
    }
    
    @IBAction func sortBySegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.productList.sort{ $0.productPriority > $1.productPriority }
            productCollectionView.reloadData()
            break
        case 1:
            self.productList.sort{ $0.productPrice < $1.productPrice }
            productCollectionView.reloadData()
            break
        case 2:
            self.productList.sort{ $0.productName < $1.productName }
            productCollectionView.reloadData()
            break
        default:
            break
        }
    }
    
    func naviToTopView(notification: NSNotification){
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
}
