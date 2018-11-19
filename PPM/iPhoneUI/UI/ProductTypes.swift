import UIKit
import MYTableViewIndex

class ProductTypes: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewIndexDelegate, TableViewIndexDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tableViewIndex: TableViewIndex!
    
    
    
    //MARK: -variales
    
    var carsDictionary = [String: [String]]()
    var carSectionTitles = [String]()
    var cars = [String]()
    var cars2 = [String]()
    var showIndex = false
    var from: String!
    var parentID: Int64?
    //    var childs: [Categ] = []
    var fltrChilds: [CategoryEnt] = []
    var resault: [CategoryEnt] = []
    
    var manufacturer: String!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rangeChar()
        indexFunc()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        self.tableView.reloadData()
    }
    
    func indexFunc() {
        //index
        
        var display: CGFloat
        display = view.bounds.height
        
        tableViewIndex.backgroundColor = UIColor.clear
        if display < 600 {
            tableViewIndex.font = UIFont(name: "Lato", size: 8)!
            tableViewIndex.itemSpacing = 2
        } else if display < 700{
            tableViewIndex.font = UIFont(name: "Lato", size: 10)!
            tableViewIndex.itemSpacing = 4
        } else if display < 800 {
            tableViewIndex.font = UIFont(name: "Lato", size: 11)!
            tableViewIndex.itemSpacing = 4
        } else {
            tableViewIndex.font = UIFont(name: "Lato", size: 12)!
            tableViewIndex.itemSpacing = 4
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
        return true 
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
        
        for car in cars {
            let carKey = String(car.prefix(1))
            if var carValues = carsDictionary[carKey] {
                carValues.append(car)
                carsDictionary[carKey] = carValues
            } else {
                carsDictionary[carKey] = [car]
            }
        }
        carSectionTitles = [String](carsDictionary.keys)
        carSectionTitles = carSectionTitles.sorted(by: { $0 < $1 })
    }
    
    //    nameLbl char range
    fileprivate func rangeChar() {
        let attributedString = nameLbl.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: 3.0, range: NSMakeRange(0, attributedString.length))
        nameLbl.attributedText = attributedString
    }
    
    @IBAction func backBut(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuBut(_ sender: Any) {
        //sideMenu
    }
}


extension ProductTypes {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let footerViewSub = UIView()
        footerViewSub.frame =  CGRect(x: 25     , y: 0, width:
            tableView.bounds.size.width - 65 , height: 0.5)
        footerView.backgroundColor = UIColor.white.withAlphaComponent(1)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerLabel = UILabel()
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerLabel =
            UILabel(frame: CGRect(x: 25, y: 0, width:
                tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Lato-Black", size: 15)
        headerLabel.textColor = UIColor(red: 181/255, green: 193/255, blue: 209/255, alpha: 1)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! ProductTypesTVCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 241/255, green: 243/255, blue: 246/255, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        cell.separatorInset.left = CGFloat(25)
        cell.separatorInset.right = CGFloat(40)
        // Configure the cell...
        let carKey = carSectionTitles[indexPath.section]
        if let carValues = carsDictionary[carKey] {
            
            cell.nameLbl.text = carValues[indexPath.row]
            var cellName = [CategoryEnt]()
            if manufacturer != nil && manufacturer != "" {
                cellName = appDelegate.parents.filter({$0.name == manufacturer})
            } else {
                let arr1 = appDelegate.childs.filter({$0.name == cell.nameLbl.text})
                for i in arr1 {
                    cellName.append(i)
                }
            }
            
            var res2 = [CategoryEnt]()
            if manufacturer != nil && manufacturer != "" {
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
        
        
        
        cell.accessoryType = .disclosureIndicator
        return cell
        
        
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        tableView.sectionIndexColor = UIColor(red: 40/255, green: 36/255, blue: 58/255, alpha: 1)
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
            let types = segue.destination as! ModelsVC
            
            let parentId = sender as! Int64
            types.from = from
            types.parentID = parentId
            types.manufacturer = manufacturer
        }
        if segue.identifier == "ShowProd2" {
            let types = segue.destination as! Product
            let parentId = sender as! Int64
            types.manufacturer = manufacturer
            types.parentID = parentId
        }
    }
}
