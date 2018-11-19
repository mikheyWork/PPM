import UIKit
import Alamofire
import SwiftyJSON
import MYTableViewIndex

class Manufacturers: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewIndexDelegate, TableViewIndexDataSource {
    
    //MARK: -outletss
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var top5But: UIButton!
    @IBOutlet weak var azBut: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewIndex: TableViewIndex!
    
    //MARK: -variables
    var parentID: Int?
    var parents: [CategoryEnt] = []
    var childs: [CategoryEnt] = []
    var isTop5Taped = true
    var isAzTabep = false
    var from = "pusto"
    var showIndex = false
    var carsDictionary = [String: [String]]()
    var carSectionTitles = [String]()
    var cars = [CategoryEnt]()
    var arr1 = ["Biotronik", "Boston Scientific", "Medtronic", "Sorin Group", "St. Jude Medical"]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appDelegate.parents.isEmpty == false {
            rangeChar()
            top5But.layer.cornerRadius = 14
            azBut.layer.cornerRadius = 14
            buttonChang(senderButton: top5But, senderSwitch: isTop5Taped)
            buttonChang(senderButton: azBut, senderSwitch: isAzTabep)
        } else {
            showAlert()
        }
        
        indexFunc()
        showIndexView()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        tableView.reloadData()
    }
    
    
    //MARK: -MEthods
    
    func index() {
        
        for i in appDelegate.parents {
            if cars.contains(i) == false {
                cars.append(i)
            }
        }
        
        for car in cars {
            let carKey = String((car.name?.prefix(1))!)
            if var carValues = carsDictionary[carKey] {
                carValues.append(car.name!)
                carsDictionary[carKey] = carValues
            } else {
                carsDictionary[carKey] = [car.name!]
            }
        }
        
        carSectionTitles = [String](carsDictionary.keys)
        carSectionTitles = carSectionTitles.sorted(by: { $0 < $1 })
        
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
    
    func showIndexView() {
        if showIndex == true {
            tableViewIndex.isHidden = false
        } else {
            tableViewIndex.isHidden = true
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
            tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
        } else {

        }
        
        return true // return true to produce haptic feedback on capable devices
    }
    
    
    fileprivate func buttonChang(senderButton: UIButton,senderSwitch: Bool) {
        if senderSwitch == false {
            senderButton.layer.borderWidth = 1
            senderButton.layer.borderColor = (UIColor(red: 181/255, green: 193/255, blue: 208/255, alpha: 1)).cgColor
            senderButton.backgroundColor = UIColor.white
            senderButton.setTitleColor(UIColor(red: 35/255, green: 52/255, blue: 70/255, alpha: 1), for: .normal)
        } else {
            
            
            senderButton.layer.borderWidth = 0
            senderButton.backgroundColor = UIColor(red: 35/255, green: 52/255, blue: 70/255, alpha: 1)
            senderButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    func showAlert() {
        let noIndormationAlert = UIAlertController(title: "Problem with internet connection", message: "Check internet connection and reload app", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { (cancel) in
            self.navigationController?.popViewController(animated: true)
        }
        noIndormationAlert.addAction(action)
        present(noIndormationAlert, animated: true, completion: nil)
    }
    
    
    //nameLbl char range
    fileprivate func rangeChar() {
        let attributedString = nameLbl.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: 3.0, range: NSMakeRange(0, attributedString.length))
        nameLbl.attributedText = attributedString
    }
    
    @IBAction func top5Tap(_ sender: Any) {
        if isTop5Taped == false {
            isTop5Taped = true
            isAzTabep = false
        } else {
            isTop5Taped = false
            isAzTabep = true
        }
        buttonChang(senderButton: top5But, senderSwitch: isTop5Taped)
        buttonChang(senderButton: azBut, senderSwitch: isAzTabep)
        if showIndex == false {
            showIndex = true
        } else {
            showIndex = false
        }
        showIndexView()
        
        self.tableView.reloadData()
    }
    
    @IBAction func azTap(_ sender: Any) {
        if isAzTabep == false {
            isAzTabep = true
            isTop5Taped = false
        } else {
            isAzTabep = false
            isTop5Taped = true
        }
        buttonChang(senderButton: azBut, senderSwitch: isAzTabep)
        buttonChang(senderButton: top5But, senderSwitch: isTop5Taped)
        
        
        if showIndex == false {
            showIndex = true
        } else {
            showIndex = false
        }
        showIndexView()
        self.tableView.reloadData()
    }
    
    @IBAction func backBut(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func menuBut(_ sender: Any) {
        //sideMenu
    }
}

extension Manufacturers {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let footerViewSub = UIView()
        if self.isAzTabep {
            
            footerViewSub.frame =  CGRect(x: 25     , y: 0, width:
                tableView.bounds.size.width - 65 , height: 0.5)
            footerView.backgroundColor = UIColor.white.withAlphaComponent(1)
        }
        return footerView
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerLabel = UILabel()
        let headerView = UIView()
        if self.isAzTabep {
            headerView.backgroundColor = UIColor.white
            headerLabel =
                UILabel(frame: CGRect(x: 25, y: 0, width:
                    tableView.bounds.size.width, height: tableView.bounds.size.height))
            headerLabel.font = UIFont(name: "Lato-Black", size: 15)
            headerLabel.textColor = UIColor(red: 181/255, green: 193/255, blue: 209/255, alpha: 1)
            headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
            headerLabel.sizeToFit()
            headerView.addSubview(headerLabel)
            
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var stringName: String!
        if self.isAzTabep {
            stringName = carSectionTitles[section]
        }
        return stringName
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 1
        var count: Int!
        if self.isAzTabep {
            count = carSectionTitles.count
        } else {
            count = 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isAzTabep {
            // 2
            
            let carKey = carSectionTitles[section]
            if let carValues = carsDictionary[carKey] {
                return carValues.count
            }
        } else {
            return 5
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 3
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ManufacturersTVCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 241/255, green: 243/255, blue: 246/255, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        
        
        if self.isAzTabep {
            cell.separatorInset.left = CGFloat(25)
            cell.separatorInset.right = CGFloat(40)
            // Configure the cell...
            let carKey = carSectionTitles[indexPath.section]
            if let carValues = carsDictionary[carKey] {
                cell.createrLabel.text = carValues[indexPath.row]
                
            }
            
        } else {
            cell.separatorInset.left = CGFloat(25)
            cell.separatorInset.right = CGFloat(25)
            cell.createrLabel.text = arr1[indexPath.row]
        }
        
        let text = cell.createrLabel.text
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
        cell.resaultLabel.text = "\(arr3.count) Results"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        if self.isAzTabep {
            
            tableView.sectionIndexColor = UIColor(red: 40/255, green: 36/255, blue: 58/255, alpha: 1)
            return [" "]
        }
        return []
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.backgroundView?.backgroundColor = UIColor.green
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //parentID
        let selectedCell = tableView.cellForRow(at: indexPath) as! ManufacturersTVCell
       
        
        performSegue(withIdentifier: "showType", sender: selectedCell)
    }
    
    //MARK: -Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showType" {
            
            let cell = sender as! ManufacturersTVCell
            
            let text = cell.createrLabel.text
            let selectedName = appDelegate.parents.filter({$0.name == text})
            let selectedNameID = selectedName.first?.id
            
            let types = segue.destination as! ProductTypes
            types.from = from
            types.parentID = selectedNameID
            types.manufacturer = text
        }
    }
}

