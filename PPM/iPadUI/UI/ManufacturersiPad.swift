import UIKit
import Alamofire
import SwiftyJSON
import MYTableViewIndex

class ManufacturersiPad: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewIndexDataSource,TableViewIndexDelegate {
    
    //MARK: -outletss
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var top5But: UIButton!
    @IBOutlet weak var azBut: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewIndex: TableViewIndex!
    
    //MARK: -variables
    
    var parents: [CategoryEnt] = []
    var childs: [CategoryEnt] = []
    var sideMenuShow = false
    var from = "pusto"
    var isTop5Taped = true
    var isAzTabep = false
    var showIndex = false
    var carsDictionary = [String: [String]]()
    var carSectionTitles = [String]()
    var cars = [String]()
    var arr1 = ["Biotronik", "Boston Scientific", "Medtronic", "Sorin Group", "St. Jude Medical"]
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        if appDelegate.parents.isEmpty == false {
            rangeChar()
            top5But.layer.cornerRadius = 15
            azBut.layer.cornerRadius = 15
            buttonChang(senderButton: top5But, senderSwitch: isTop5Taped)
            buttonChang(senderButton: azBut, senderSwitch: isAzTabep)
        } else {
            showAlert()
        }
        
        
        
        showIndexView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        self.tableView.reloadData()
        indexFunc()
    }
    
    //MARK: -MEthods
    
    func index() {
        for i in appDelegate.parents {
            if cars.contains(i.name!) == false {
                cars.append(i.name!)
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
            tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
        } else {
        }
        
        
        
        return true // return true to produce haptic feedback on capable devices
    }
    
    func showAlert() {
        let noIndormationAlert = UIAlertController(title: "Problem with internet connection", message: "Check internet connection and reload app", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { (cancel) in
            self.navigationController?.popViewController(animated: true)
        }
        noIndormationAlert.addAction(action)
        present(noIndormationAlert, animated: true, completion: nil)
    }
    
    fileprivate func buttonChang(senderButton: UIButton,senderSwitch: Bool) {
        if senderSwitch == false {
            senderButton.layer.borderWidth = 1
            senderButton.layer.borderColor = (UIColor(red: 143/255, green: 150/255, blue: 158/255, alpha: 1)).cgColor
            senderButton.backgroundColor = UIColor(red: 40/255, green: 36/255, blue: 58/255, alpha: 0.0)
            senderButton.setTitleColor(UIColor(red: 143/255, green: 150/255, blue: 158/255, alpha: 1), for: .normal)
        } else {
            senderButton.layer.borderWidth = 0
            senderButton.backgroundColor = UIColor(red: 8/255, green: 12/255, blue: 17/255, alpha: 1)
            senderButton.setTitleColor(UIColor.white, for: .normal)
        }
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
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func menuBut(_ sender: Any) {
        //sideMenu
    }
    
    @IBAction func sideMenuBut(_ sender: Any) {
        if sideMenuShow == true {
            
        }
    }
    
}

extension ManufacturersiPad {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        if self.isAzTabep {
        }
        
        return footerView
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerLabel = UILabel()
        let headerView = UIView()
        if self.isAzTabep {
            headerView.backgroundColor = UIColor(red: 32/255, green: 46/255, blue: 61/255, alpha: 1)
            headerLabel =
                UILabel(frame: CGRect(x: 30, y: 0, width:
                    tableView.bounds.size.width, height: tableView.bounds.size.height))
            headerLabel.font = UIFont(name: "Lato-Black", size: 15)
            headerLabel.textColor = UIColor.white
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ManufacturersTVCell
        cell.separatorInset.left = CGFloat(30)
        cell.separatorInset.right = CGFloat(30)
        
        
        if self.isAzTabep {
            cell.separatorInset.left = CGFloat(30)
            cell.separatorInset.right = CGFloat(50)
            // Configure the cell...
            let carKey = carSectionTitles[indexPath.section]
            if let carValues = carsDictionary[carKey] {
                cell.createrLabel.text = carValues[indexPath.row]
            }
            
        } else {
            cell.separatorInset.left = CGFloat(30)
            cell.separatorInset.right = CGFloat(30)
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
        
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if self.isAzTabep {
            tableView.sectionIndexColor = UIColor.white
            
            
            //        return carSectionTitles
            return [" "]
        }
        
        return []
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.backgroundView?.backgroundColor = UIColor.green
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //parentID
        
        performSegue(withIdentifier: "showType", sender: indexPath)
    }
    
    
    //MARK: -Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showType" {
            let index = sender as! IndexPath
            
            let selectedCell = tableView.cellForRow(at: index) as! ManufacturersTVCell
            let text = selectedCell.createrLabel.text
            let selectedName = appDelegate.parents.filter({$0.name == text})
            let selectedNameID = selectedName.first?.id
            
            let types = segue.destination as! ProductTypesiPad
            types.from = from
            types.parentID = selectedNameID
            types.manufacturer = text!
        }
        
    }
}
