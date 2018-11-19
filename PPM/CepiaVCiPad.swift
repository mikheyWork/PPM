import UIKit
import GTProgressBar
import MYTableViewIndex
import Firebase


class CepiaVCiPad: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, TableViewIndexDelegate, TableViewIndexDataSource {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var searchBarLbl: UISearchBar!
    @IBOutlet weak var showTableView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewIndex: TableViewIndex!
    
    var from: String!
    var showAlert = false
    var carsDictionary = [String: [String]]()
    var carSectionTitles = [String]()
    var cars = [SearchItem]()
    var cars2 = [SearchItem]()
    var isSearching = false
    var progressBar = GTProgressBar()
    
    //fire
    var user: UserModel!
    var ref: DatabaseReference!
    var ref2: DatabaseReference!
    var favor = Array<Favor>()
    var ref3: DatabaseReference!
    var refSub: DatabaseReference!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showCongr), name: NSNotification.Name("Check"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fireBaseSub), name: NSNotification.Name("CheckSub"), object: nil)
        
        searchBarLbl.delegate = self
        
        
        if appDelegate.childs.count == 0 {
            appDelegate.fetchCoreDataRef()
        }
        
        if appDelegate.referencesChild.count == 0 {
            appDelegate.fetchCoreDataRef()
        }
        
        //test store
        IAPService.shared.getProducts()
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        rangeChar()
        
        searchBarChange(searchBar: searchBarLbl)
        showTable()
        indexFunc()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserModel(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("favor")
        ref2 = Database.database().reference(withPath: "users").child((self.user.uid)).child("disclaimer")
        refSub  = Database.database().reference(withPath: "users").child((self.user.uid)).child("subscription")
        refSub.setValue(["subscription": self.appDelegate.subscribtion])
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() == true {
            favorConnection()
            
        } else {
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ref.removeAllObservers()
        
    }
    override func viewWillLayoutSubviews() {
        indexFunc()
    }
    
    fileprivate func favorConnection() {
        var _favor = Array<Favor>()
        
        //debug ??
        
        ref.observe(.value) { [weak self] (snapshot) in
            for item in snapshot.children {
                //                var a =  item as DataSnapshot!
                
                //                let disclaimer = item as! DataSnapshot!
                let favor = Favor(snapShot: item as! DataSnapshot)
                _favor.append(favor)
            }
            
            if self?.appDelegate.favourites.isEmpty == false {
                self?.appDelegate.favourites.removeAll()
            }
            
            for i in _favor {
                for j in i.favArray {
                    if self?.appDelegate.favourites.contains(where: {$0 == j}) == false {
                        //                        print("active2")
                        if self?.appDelegate.curentPdf.contains(where: {$0.model_name == j}) == true || self?.appDelegate.curentPdfRef.contains(where: {$0.title == j}) == true || self?.appDelegate.curentPdf.contains(where: {$0.model_number == j}) == true  {
                            //                            print("elem add \(j)")
                            self?.appDelegate.favourites.append(j)
                        }
                    }
                }
            }
            UserDefaults.standard.set(self?.appDelegate.favourites, forKey: "favorArr")
            
        }
        
        var value2: Int!
        refSub.observe(.value) { (snapshot) in
            for item in snapshot.children {
                //                print("item2 is \(item)")
                let subs = item as! DataSnapshot
                value2 = subs.value as? Int
                if value2 == 1 {
                    self.appDelegate.subscribtion = true
                } else {
                    self.appDelegate.subscribtion = false
                }
                
                //
                if Reachability.isConnectedToNetwork() == true {
                    if value2 == 1 {
                        if self.showAlert == true {
                            self.showSub(nameVC: "CheckDataController")
                        }
                    } else {
                        self.showSub(nameVC: "SubscribeAlert")
                    }
                }
            }
        }
        var value: Int!
        //disc
        
        ref3 = Database.database().reference(withPath: "users").child((self.user.uid)).child("disclaimer")
        ref3.observe(.value) { (snapshot) in
            for item in snapshot.children {
                let discl = item as! DataSnapshot
                value = discl.value as? Int
                if value == 1 {
                    self.appDelegate.showDisc = true
                } else {
                    self.appDelegate.showDisc = false
                }
            }
            if Reachability.isConnectedToNetwork() == true {
                if value == 1 {
                    let ref2  = Database.database().reference(withPath: "users").child((self.user.uid)).child("disclaimer")
                    ref2.setValue(["disclaimer": self.appDelegate.showDisc])
                } else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DiscAlert")
                    
                    vc?.view.backgroundColor = UIColor.white
                    self.addChild(vc!)
                    self.view.addSubview((vc?.view)!)
                }
            }
        }
    }
    
    @objc func fireBaseSub() {
        self.refSub  = Database.database().reference(withPath: "users").child((self.user.uid)).child("subscription")
        self.refSub.setValue(["subscription": self.appDelegate.subscribtion])
    }
    
    @objc func showCongr() {
        if Reachability.isConnectedToNetwork() == true {
            if showAlert == true {
                //при релизе вкл
//                                if appDelegate.subscribtion == true {
                showSub(nameVC: "CheckDataController")
//                                }
            }
        }
    }
    
    func showSub(nameVC: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: nameVC)
        
        vc?.view.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        self.addChild(vc!)
        self.view.addSubview((vc?.view)!)
    }
    
    //    func showIndexView() {
    //        if isSearching == true {
    //            tableViewIndex.isHidden = true
    //        } else {
    //            tableViewIndex.isHidden = false
    //        }
    //    }
    
    func index() {
        
        for i in appDelegate.parents {
            let a = appDelegate.parents.filter({$0.name == i.name})
            if cars.contains(where: {$0.name == a.first!.name!}) == false {
                let b = SearchItem(id: Int(i.id), name: i.name!, discription: "a")
                cars.append(b)
            }
        }
        
        // 1
        for car in cars {
            let carKey = String(car.name.prefix(1))
            if var carValues = carsDictionary[carKey] {
                carValues.append(car.name)
                carsDictionary[carKey] = carValues
            } else {
                carsDictionary[carKey] = [car.name]
            }
        }
        
        // 2
        carSectionTitles = [String](carsDictionary.keys)
        carSectionTitles = carSectionTitles.sorted(by: { $0 < $1 })
        
    }
    
    func indexFunc() {
        //index
        
        var display: CGFloat
        display = view.bounds.height
        if display < 800 {
            tableViewIndex.font = UIFont(name: "Lato", size: 12)!
            tableViewIndex.itemSpacing = 5
        } else if display < 900{
            tableViewIndex.font = UIFont(name: "Lato", size: 13)!
            tableViewIndex.itemSpacing = 6
        } else if display < 1120{
            tableViewIndex.font = UIFont(name: "Lato", size: 15)!
            tableViewIndex.itemSpacing = 12
        } else {
            tableViewIndex.font = UIFont(name: "Lato", size: 15)!
            tableViewIndex.itemSpacing = 24
        }
        
    }
    
    
    func indexItems(for tableViewIndex: TableViewIndex) -> [UIView] {
        index()
        return carSectionTitles.map{ title -> UIView in
            return StringItem(text: title)
        }
    }
    
    func tableViewIndex(_ tableViewIndex: TableViewIndex, didSelect item: UIView, at index: Int) -> Bool {
        
        if index < carSectionTitles.count {
            let indexPath = NSIndexPath(row: 0, section: index)
            tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
        } else {
        }
        
        
        
        return true // return true to produce haptic feedback on capable devices
    }
    
    func showTable() {
        if isSearching == true {
            showTableView.isHidden = false
            tableView.isHidden = false
        } else {
            showTableView.isHidden = true
            tableView.isHidden = true
        }
    }
    
    //search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText
        if searchText != "" {
            isSearching = true
        }
        
        showTable()
        tableView.reloadData()
        carsDictionary.removeAll()
        carSectionTitles.removeAll()
        
        if searchText != "" {
            for i in appDelegate.referencesParent {
                let a = appDelegate.referencesParent.filter({$0.id == i.id})
                if cars.contains(where: {$0.id == a.first!.id}) == false {
                    let b = SearchItem(id: Int(i.id), name: i.name!, discription: i.description2!)
                    cars.append(b)
                }
            }
            
            for i in appDelegate.parents {
                let a = appDelegate.parents.filter({$0.id == i.id})
                if cars.contains(where: {$0.id == a.first!.id}) == false {
                    let b = SearchItem(id: Int(i.id), name: i.name!, discription: "a")
                    cars.append(b)
                }
            }
            for i in appDelegate.models {
                let a = appDelegate.models.filter({$0.id == i.id})
                if cars.contains(where: {$0.id == a.first!.id}) == false {
                    let b = SearchItem(id: Int(i.id), name: i.name!, discription: "a")
                    cars.append(b)
                }
            }
            cars = cars.filter({ (elemt: SearchItem) -> Bool in
                elemt.name.lowercased().contains(searchText.lowercased())
            })
            
            
            
        } else {
            for i in appDelegate.parents {
                let a = appDelegate.parents.filter({$0.id == i.id})
                if cars.contains(where: {$0.id == a.first!.id}) == false {
                    let b = SearchItem(id: Int(i.id), name: i.name!, discription: "a")
                    cars.append(b)
                }
            }
            for i in appDelegate.models {
                let a = appDelegate.models.filter({$0.id == i.id})
                if cars.contains(where: {$0.id == a.first!.id}) == false {
                    let b = SearchItem(id: Int(i.id), name: i.name!, discription: "a")
                    cars.append(b)
                }
            }
        }
        for car in cars {
            let carKey = String(car.name.prefix(1))
            if var carValues = carsDictionary[carKey] {
                carValues.append(car.name)
                carsDictionary[carKey] = carValues
            } else {
                carsDictionary[carKey] = [car.name]
            }
        }
        
        carSectionTitles = [String](carsDictionary.keys)
        carSectionTitles = carSectionTitles.sorted(by: { $0 < $1 })
        self.tableView.reloadData()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        isSearching = false
        showTable()
        //        showIndexView()
        return true
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
        
    }
    
    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
        searchBarLbl.endEditing(true)
        searchBarLbl.resignFirstResponder()
        isSearching = false
        showTable()
        //        showIndexView()
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBarLbl.endEditing(true)
        searchBar.resignFirstResponder()
        isSearching = false
        showTable()
        //        showIndexView()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearching = false
        showTable()
        //        showIndexView()
    }
    
    
    //searchBar view
    func searchBarChange(searchBar: UISearchBar) {
        searchBar.setImage(UIImage(named: "ic_search_18px"), for: UISearchBar.Icon.search, state: UIControl.State.normal)
        searchBar.isTranslucent = true
        searchBar.alpha = 1
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = UIColor.clear
        searchBar.layer.borderWidth = 1
        searchBar.layer.cornerRadius = 5
        searchBar.layer.borderColor = UIColor(red: 232/255, green: 234/255, blue: 235/255, alpha: 1).cgColor
        
        //SearchBar Text
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor(red: 32/255, green: 46/255, blue: 61/255, alpha: 1)
        textFieldInsideUISearchBar?.font = UIFont(name: "Lato", size: 14)
        
        //SearchBar Placeholder
        let textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideUISearchBarLabel?.font = UIFont(name: "Lato", size: 14)
    }
    
    //nameLbl char range
    fileprivate func rangeChar() {
        let attributedString = nameLbl.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: 3.0, range: NSMakeRange(0, attributedString.length))
        nameLbl.attributedText = attributedString
        nameLbl.font = UIFont(name: "Lato", size: 20)
    }
    
    
    
    
    @IBAction func manufBut(_ sender: Any) {
        from = "Manuf"
        if Reachability.isConnectedToNetwork() {
            if appDelegate.closeCheckData == true {
                performSegue(withIdentifier: "showManufacturers", sender: (Any).self)
            }
        } else {
            performSegue(withIdentifier: "showManufacturers", sender: (Any).self)
        }
    }
    
    @IBAction func prodBut(_ sender: Any) {
        from = "ProdTypes"
        if Reachability.isConnectedToNetwork() {
            if appDelegate.closeCheckData == true {
                performSegue(withIdentifier: "showProductTypes", sender: (Any).self)
            }
        } else {
            performSegue(withIdentifier: "showProductTypes", sender: (Any).self)
        }
    }
    
    @IBAction func modelsBut(_ sender: Any) {
        from = "Models"
        if Reachability.isConnectedToNetwork() {
            
            if appDelegate.closeCheckData == true {
                
                performSegue(withIdentifier: "showProductTypes", sender: (Any).self)
            }
        } else {
            performSegue(withIdentifier: "showProductTypes", sender: (Any).self)
        }
    }
    
    
    
    @IBAction func favorTaped(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            if appDelegate.closeCheckData == true {
                performSegue(withIdentifier: "showFavourites", sender: (Any).self)
            }
        } else {
            performSegue(withIdentifier: "showFavourites", sender: (Any).self)
        }
    }
    
    @IBAction func AlertsTaped(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            if appDelegate.closeCheckData == true {
                performSegue(withIdentifier: "showAlerts", sender: (Any).self)
            }
        } else {
            performSegue(withIdentifier: "showAlerts", sender: (Any).self)
        }
    }
    
    @IBAction func referTaped(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            if appDelegate.closeCheckData == true {
                performSegue(withIdentifier: "showRef", sender: (Any).self)
            }
        } else {
            performSegue(withIdentifier: "showRef", sender: (Any).self)
        }
    }
    
    
    @IBAction func manuBut(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            if appDelegate.closeCheckData == true {
                performSegue(withIdentifier: "showSideMenu2", sender: (Any).self)
            }
        } else {
            performSegue(withIdentifier: "showSideMenu2", sender: (Any).self)
        }
    }
    
}

extension CepiaVCiPad {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        
        return footerView
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerLabel = UILabel()
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 32/255, green: 46/255, blue: 61/255, alpha: 1)
        headerLabel =
            UILabel(frame: CGRect(x: 30, y: 0, width:
                tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Lato-Black", size: 15)
        headerLabel.textColor = UIColor.white
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return carSectionTitles[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return carSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let carKey = carSectionTitles[section]
        if let carValues = carsDictionary[carKey] {
            return carValues.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCepia", for: indexPath) as! CepiaTVCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 241/255, green: 243/255, blue: 246/255, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        cell.separatorInset.left = CGFloat(25)
        cell.separatorInset.right = CGFloat(40)
        // Configure the cell...
        let carKey = carSectionTitles[indexPath.section]
        if let carValues = carsDictionary[carKey] {
            
            cell.nameLbl.text = carValues[indexPath.row]
            let text = cell.nameLbl.text
            if appDelegate.parents.contains(where: {$0.name == text}) {
                let cellName = appDelegate.parents.filter({$0.name == text})
                let selectedNameID = cellName.first?.id
                let resault = appDelegate.childs.filter{$0.parent == selectedNameID}
                let arr2 = appDelegate.childs.filter({$0.parent == resault.first?.id})
                var arr3 = [PdfDocumentInfo]()
                for i in arr2 {
                    var car = appDelegate.curentPdf.filter({$0.model_name == i.name})
                    if car.isEmpty == false {
                        if arr3.contains(where: {$0.model_name == i.name}) == false {
                            arr3.append(car.first!)
                        }
                    } else {
                        car = appDelegate.curentPdf.filter({$0.model_number == i.name})
                        if car.isEmpty == false {
                            if arr3.contains(where: {$0.model_number == i.name}) == false {
                                arr3.append(car.first!)
                            }
                        }
                    }
                    
                }
                cell.resultsLbl.text = "\(arr3.count) Results"
            }
            if appDelegate.childs.contains(where: {$0.name == text}) {
                var arr1 = appDelegate.curentPdf.filter({$0.model_name == text})
                if arr1.isEmpty {
                    arr1 = appDelegate.curentPdf.filter({$0.model_number == text})
                }
                cell.resultsLbl.text = "\(arr1.count) Results"
                
                
            }
            if appDelegate.referencesParent.contains(where: {$0.name == text}) {
                let arr1 = appDelegate.referencesParent.filter({$0.name == text})
                cell.resultsLbl.text = arr1.first?.description2!
            }
            if appDelegate.referencesChild.contains(where: {$0.name == text}) {
                let arr1 = appDelegate.referencesChild.filter({$0.name == text})
                cell.resultsLbl.text = arr1.first?.description2!
            }
        }
        cell.accessoryType = .disclosureIndicator
        return cell
        
        
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        //        tableView.sectionIndexColor = UIColor(red: 40/255, green: 36/255, blue: 58/255, alpha: 1)
        return [" "]
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //parentID
        let selectedCell = tableView.cellForRow(at: indexPath) as! CepiaTVCell
        let text = selectedCell.nameLbl.text
        var selectedName = appDelegate.parents.filter({$0.name == text})
        var selectedNameID: Int64!
        if selectedName.isEmpty {
            selectedName = appDelegate.models.filter({$0.name == text})
            if selectedName.isEmpty {
                //                let reflName = selectedName.first?.name
                if Reachability.isConnectedToNetwork() {
                    if appDelegate.referencesParent.contains(where: {$0.name == text}) {
                        if appDelegate.closeCheckData == true {
                            from = "Models"
                            performSegue(withIdentifier: "showRefSearch", sender: indexPath)
                        }
                    } else {
                        from = "Models"
                        performSegue(withIdentifier: "showRefSearch", sender: indexPath)
                    }
                } else if Reachability.isConnectedToNetwork() {
                    if appDelegate.referencesChild.contains(where: {$0.name == text}) {
                        if appDelegate.closeCheckData == true {
                            from = "Models"
                            performSegue(withIdentifier: "showRefSearch", sender: indexPath)
                        }
                    } else {
                        from = "Models"
                        performSegue(withIdentifier: "showRefSearch", sender: indexPath)
                    }
                }
            } else {
                let modelName = selectedName.first?.name
                if Reachability.isConnectedToNetwork() {
                    if appDelegate.closeCheckData == true {
                        from = "Models"
                        performSegue(withIdentifier: "searchCepia", sender: modelName)
                    }
                } else {
                    from = "Models"
                    performSegue(withIdentifier: "searchCepia", sender: modelName)
                }
                
            }
            
        } else {
            selectedNameID = selectedName.first?.id
            
            let cell = tableView.cellForRow(at: indexPath) as! CepiaTVCell
            if Reachability.isConnectedToNetwork() {
                if appDelegate.closeCheckData == true {
                    from = "Models"
                    performSegue(withIdentifier: "searchProd", sender: cell)
                }
            } else {
                from = "Models"
                performSegue(withIdentifier: "searchProd", sender: cell)
            }
            
        }
    }
    
    
    //        MARK: -Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        print("state is \(IAPService.shared.state)")
        if IAPService.shared.state == "purchasing" {
            let alert = UIAlertController(title: "Wait a minute", message: "Wait until the end of the purchase.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else if IAPService.shared.state == "purchased" {
            print("purchased subs")
        } else if appDelegate.subscribtion == false {
            showAlertError(withText: "Buy an annual subscription of $ 9.99 AUD for PPM Genius applications.", title: "Confirm Purchase")
        } else {
            print("error state is \(IAPService.shared.state)")
        }
        
        
        if segue.identifier == "showManufacturers" {
            let manuf = segue.destination as! ManufacturersiPad
            manuf.from = from
        }
        if segue.identifier == "showProductTypes" {
            let manuf = segue.destination as! ProductTypesiPad
            manuf.from = from
        }
        if segue.identifier == "searchProd" {
            let cell = sender as! CepiaTVCell
            let arr = appDelegate.parents.filter({$0.name == cell.nameLbl.text})
            let types = segue.destination as! ProductTypes
            types.from = "Manuf"
            types.parentID = arr.first?.id
            types.manufacturer = arr.first?.name
        }
        if segue.identifier == "searchCepia" {
            let nameModel = sender as! String
            let types = segue.destination as! VitalStatVCiPad
            types.name = nameModel
        }
        
        if segue.identifier == "showRefSearch" {
            let indexPath = sender as! IndexPath
            let selectedCell = tableView.cellForRow(at: indexPath) as! CepiaTVCell
            let text = selectedCell.nameLbl.text
            let selectedName = appDelegate.referencesParent.filter({$0.name == text})
            let selectedNameID = selectedName.first?.id
            
            let vc = segue.destination as! ReferencesVC2iPad
            vc.parentID = selectedNameID
            
        }
        
        showAlert = false
        searchBarLbl.text = ""
    }
    
    func showAlertError(withText: String, title: String) {
        let alert = UIAlertController(title: title, message: withText, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
        let subscribeAction = UIAlertAction(title: "Subscribe", style: .default) { (subscribe) in
            IAPService.shared.purchase(product: .autoRenewingSubs)
            
            let alert = UIAlertController(title: "Confirm Purchase", message: "After the subscription, wait until you receive a confirmation of the successful subscription", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(subscribeAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    func showAlertError2(withText: String, title: String) {
        let alert = UIAlertController(title: title, message: withText, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default) { (cencel) in
            do {
                try Auth.auth().signOut()
            } catch {
                print(error.localizedDescription)
            }
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: LoginVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

