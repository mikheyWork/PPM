import UIKit
import MYTableViewIndex


class ProductTypesiPad: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewIndexDataSource, TableViewIndexDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tableViewIndex: TableViewIndex!
    
    
    //MARK: -variales
    var from: String!
    var parentID: Int64?
    var childs: [CategoryEnt] = []
    var fltrChilds: [CategoryEnt] = []
    var carsDictionary = [String: [String]]()
    var carSectionTitles = [String]()
    var cars = [String]()
    var cars2 = [String]()
    var manufacturer = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rangeChar()
        indexFunc()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.fltrChilds = appDelegate.childs.filter{$0.parent == parentID}
        
    }
    
    override func viewWillLayoutSubviews() {
        
        self.tableView.reloadData()
        indexFunc()
    }
    
    func index() {
        
        if parentID != nil {
            let resault = appDelegate.childs.filter{$0.parent == parentID}
            for i in resault {
                if cars2.contains(i.name!) == false {
                    cars2.append(i.name!)
                }
            }
        } else {
            for i in appDelegate.childs {
                if cars2.contains(i.name!) == false {
                    cars2.append(i.name!)
                }
            }
        }
        
        for car in cars2 {
            let aText = car
            let text = aText
            let cellName = appDelegate.childs.filter({$0.name == text})
            let selectedNameID = cellName.first?.id
            let resault = appDelegate.childs.filter{$0.parent == selectedNameID}
            if resault.count > 0 {
                cars.append(aText)
            }
        }
        
        // 1
        for car in cars {
            let carKey = String(car.prefix(1))
            if var carValues = carsDictionary[carKey] {
                carValues.append(car)
                carsDictionary[carKey] = carValues
            } else {
                carsDictionary[carKey] = [car]
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
        }
        
        
        
        return true // return true to produce haptic feedback on capable devices
    }
    
    //    nameLbl char range
    fileprivate func rangeChar() {
        let attributedString = nameLbl.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: 3.0, range: NSMakeRange(0, attributedString.length))
        nameLbl.attributedText = attributedString
    }
    
    @IBAction func backBut(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func menuBut(_ sender: Any) {
        //sideMenu
    }
    
}

extension ProductTypesiPad {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor(red: 32/255, green: 46/255, blue: 61/255, alpha: 1)
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
        // 1
        return carSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 2
        
        let carKey = carSectionTitles[section]
        if let carValues = carsDictionary[carKey] {
            return carValues.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 3
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! ProductTypesTVCell
        
        cell.separatorInset.left = CGFloat(30)
        cell.separatorInset.right = CGFloat(30)
        
        cell.separatorInset.left = CGFloat(30)
        cell.separatorInset.right = CGFloat(50)
        // Configure the cell...
        let carKey = carSectionTitles[indexPath.section]
        if let carValues = carsDictionary[carKey] {
            cell.nameLbl.text = carValues[indexPath.row]
            var cellName = [CategoryEnt]()
            if manufacturer != "" {
                cellName = appDelegate.parents.filter({$0.name == manufacturer})
            } else {
                let arr1 = appDelegate.childs.filter({$0.name == cell.nameLbl.text})
                for i in arr1 {
                    cellName.append(i)
                }
            }
            
            var res2 = [CategoryEnt]()
            if manufacturer != "" {
                let selectedNameID = cellName.first?.id
                let resault = appDelegate.childs.filter{$0.parent == selectedNameID}
                res2 = appDelegate.childs.filter{$0.parent == resault.first?.id}
            } else {
                var resault = [CategoryEnt]()
                var arr4 = [CategoryEnt]()
                for i in cellName {
                    let selectedNameID = i.id
                    resault = appDelegate.childs.filter{$0.parent == selectedNameID}
                    for i in resault {
                        if arr4.contains(where: {$0.name == i.name}) == false {
                            arr4.append(contentsOf: resault)
                        }
                        
                    }
                }
                res2 = arr4
            }
            var arr3 = [PdfDocumentInfo]()
            for i in res2 {
                var car = appDelegate.curentPdf.filter({$0.model_name == i.name})
                
                if car.isEmpty == false {
                    for i in car {
                        arr3.append(i)
                    }
                } else {
                    car = appDelegate.curentPdf.filter({$0.model_number == i.name})
                    if car.isEmpty == false {
                        for i in car {
                            arr3.append(i)
                        }
                    }
                }
                
            }
            cell.resaultLbl.text = "\(arr3.count) Results"
        }
        
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        tableView.sectionIndexColor = UIColor.white
        //        return carSectionTitles
        return [" "]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //parentID
        let selectedCell = tableView.cellForRow(at: indexPath) as! ProductTypesTVCell
        let text = selectedCell.nameLbl.text
        let selectedName = appDelegate.childs.filter({$0.name == text})
        let selectedNameID = selectedName.first?.id
        if from == "Manuf" {
            performSegue(withIdentifier: "showModel", sender: selectedNameID)
        }
        if from == "Models" {
            performSegue(withIdentifier: "showModel", sender: selectedNameID)
        }
        if from == "ProdTypes" {
            performSegue(withIdentifier: "ShowProd2", sender: selectedNameID)
        }
    }
    
    //MARK: -Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showModel" {
           let parentId = sender as! Int64
            let types = segue.destination as! ModelsVCiPad
            types.from = from
            types.parentID = parentId
            types.manufacturer = manufacturer
        }
        if segue.identifier == "ShowProd2" {
            let parentId = sender as! Int64
            let types = segue.destination as! ProductiPad
            let filterArr = appDelegate.childs.filter({$0.id == parentId})
            let name2 = filterArr.first?.name
            if name2 != nil {
                types.name = name2!
            }
            types.parentID = parentId
            types.manufacturer = manufacturer
            
        }
    }
}
