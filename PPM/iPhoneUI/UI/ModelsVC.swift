import UIKit
import MYTableViewIndex

class ModelsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewIndexDataSource, TableViewIndexDelegate{
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tableViewIndex: TableViewIndex!
    
    var from: String!
    var parentID: Int64?
    var filterArray: [CategoryEnt] = []
    var carsDictionary = [String: [String]]()
    var carSectionTitles = [String]()
    var cars = [String]()
    
    //    var childs: [Categ] = []
    var fltrChilds: [CategoryEnt] = []
    var resault: [CategoryEnt] = []
    var name4 = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var manufacturer: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rangeChar()
        indexFunc()
        
        for i in appDelegate.childs {
            print("a is \(i.name)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        filterArray = appDelegate.allCateg.filter({$0.parent == parentID})
        self.tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        self.tableView.reloadData()
    }
    
    func indexFunc() {
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
            var resault = [CategoryEnt]()
            var arr1 = [CategoryEnt]()
            if manufacturer != "" && manufacturer != nil {
                let cellName = appDelegate.parents.filter({$0.name == manufacturer})
                let selectedNameID = cellName.first?.id
                resault = appDelegate.childs.filter{$0.parent == selectedNameID}
                parentID = resault.first?.id
                arr1 = appDelegate.childs.filter({$0.parent == parentID})
            } else {
                let selectedNameID = appDelegate.childs.filter({$0.id == parentID})
                resault = appDelegate.childs.filter{$0.name == selectedNameID.first?.name}
                arr1 = appDelegate.childs.filter({$0.name == selectedNameID.first?.name})
            }
            for i in arr1 {
                if manufacturer == nil || manufacturer == "" {
                let arr2 = appDelegate.childs.filter({$0.parent == i.id})
                    for i in arr2 {
                        if appDelegate.curentPdf.contains(where: {$0.model_name == i.name}) {
                            let car = appDelegate.curentPdf.filter({$0.model_name == i.name})
                            if manufacturer != nil && manufacturer != "" {
                                if cars.contains((car.first?.model_name)!) == false {
                                    cars.append((car.first?.model_name)!)
                                }
                            } else {
                                cars.append((car.first?.model_name)!)
                            }
                        } else {
                            if appDelegate.curentPdf.contains(where: {$0.model_number == i.name}) {
                                let car = appDelegate.curentPdf.filter({$0.model_number == i.name})
                                if cars.contains((car.first?.model_number)!) == false {
                                    cars.append((car.first?.model_number)!)
                                }
                            }
                        }
                    }
                } else {
                    if appDelegate.curentPdf.contains(where: {$0.model_name == i.name}) {
                        let car = appDelegate.curentPdf.filter({$0.model_name == i.name})
                        if manufacturer != nil && manufacturer != "" {
                            if cars.contains((car.first?.model_name)!) == false {
                                cars.append((car.first?.model_name)!)
                            }
                        } else {
                            cars.append((car.first?.model_name)!)
                        }
                    } else {
                        if appDelegate.curentPdf.contains(where: {$0.model_number == i.name}) {
                            let car = appDelegate.curentPdf.filter({$0.model_number == i.name})
                            if cars.contains((car.first?.model_number)!) == false {
                                cars.append((car.first?.model_number)!)
                            }
                        }
                    }
                }
            }
        } else {
            for i in appDelegate.curentPdf {
                    cars.append(i.model_name!)
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

extension ModelsVC {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! ModelsTVCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 241/255, green: 243/255, blue: 246/255, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        cell.separatorInset.left = CGFloat(25)
        cell.separatorInset.right = CGFloat(40)
        // Configure the cell...
        let carKey = carSectionTitles[indexPath.section]
        if let carValues = carsDictionary[carKey] {
            cell.nameLbl.text = carValues[indexPath.row]
            cell.text2 = carValues[indexPath.row]
            let text = cell.nameLbl.text
            var cellName = appDelegate.curentPdf.filter({$0.model_name == text})
            if cellName.isEmpty == true {
                cellName = appDelegate.curentPdf.filter({$0.model_number == text})
            }
            let selectedNameID = cellName.first?.manufacturer
                let a = cellName.first?.model_number!
                cell.resaultLbl.text = selectedNameID
                if a != nil {
                    if cell.text2 == a {
                        cell.nameLbl.text = carValues[indexPath.row]
                    } else {
                        cell.nameLbl.text = "\(carValues[indexPath.row]) \(a!)"
                    }
                }
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        tableView.sectionIndexColor = UIColor(red: 40/255, green: 36/255, blue: 58/255, alpha: 1)
        return [" "]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! ModelsTVCell
        if from == "Manuf" {
            performSegue(withIdentifier: "ShowVital2", sender: selectedCell)
        }
        if from == "Models" {
            performSegue(withIdentifier: "showProduct", sender: selectedCell)
        }
    }
    
    //MARK: -Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        let parentId = sender as! Int64
        
        if segue.identifier == "ShowVital2" {
            
            let parentId = sender as! ModelsTVCell
            let text = parentId.text2
            let vitalStat = segue.destination as! VitalStatVC
            vitalStat.name = text
        }
        
        if segue.identifier == "showProduct" {
            
            let parentId = sender as! ModelsTVCell
            let text = parentId.text2
            let selectedName = appDelegate.childs.filter({$0.name == text})
            let prod = segue.destination as! Product
            prod.name = text
            prod.prodName = text
            
            let id = appDelegate.childs.filter({$0.id == selectedName.first?.parent})
            prod.parentID = id.first?.id
        }
    }
}


