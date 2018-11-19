import UIKit
import MYTableViewIndex
import GTProgressBar

class AlertsVCiPad: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewIndexDelegate, TableViewIndexDataSource {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var top5But: UIButton!
    @IBOutlet weak var azBut: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewIndex: TableViewIndex!
    @IBOutlet weak var progressBar: GTProgressBar!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: -variables
    var isTop5Taped = true
    var isAzTabep = false
    var nameVC = "VitalStatVC"
    var carsDictionary = [String: [Alert]]()
    var carSectionTitles = [String]()
    var cars = [Alert]()
    var showIndex = false
    
    var name = ""
    
    var name2 = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.isHidden = true
        webView.isHidden = true
        rangeChar()
        top5But.layer.cornerRadius = 15
        azBut.layer.cornerRadius = 15
        buttonChang(senderButton: top5But, senderSwitch: isTop5Taped)
        buttonChang(senderButton: azBut, senderSwitch: isAzTabep)
        showIndexView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
        print("name2 \(name2)")
        if appDelegate.curentPdfRef.contains(where: {$0.title == name2}) == false {
            webView.isHidden = true
            progressView.isHidden = true
            view.backgroundColor = UIColor(red: 234/255, green: 34/255, blue: 37/255, alpha: 1)
            imageView.image = UIImage(named: "CEPIA Splash 1")
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        self.tableView.reloadData()
        indexFunc()
    }
    
    func showIndexView() {
        if showIndex == true {
            tableViewIndex.isHidden = false
        } else {
            tableViewIndex.isHidden = true
        }
    }
    
    func index() {
        
        
        carsDictionary.removeAll()
        carSectionTitles.removeAll()
        cars.removeAll()
        
        for i in appDelegate.curentPdf {
            if i.alerts != nil && i.alerts != "false" && i.alerts != "" {
                var a: Alert!
                if i.model_name != "" && i.model_name != "_" && i.model_name != "false" {
                    a = Alert(name: i.model_name!, date: i.modified!)
                } else {
                    a = Alert(name: i.model_number!, date: i.modified!)
                }
                
                if cars.contains(where: {$0.name == i.model_name}) == false {
                    cars.append(a)
                }
            }
            
        }
        
        if isAzTabep {
            cars = cars.sorted(by: {$0.name > $1.name})
        } else if isTop5Taped {
            cars = cars.sorted(by: {$0.date > $1.date})
        } else {
            
        }
        
        
        for car in cars {
            let carKey = String(car.name.prefix(1))
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
    
    @IBAction func goToFS(_ sender: Any) {
        if name != "" {
         performSegue(withIdentifier: "showAlertPdf", sender: name)
        }
        
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
}

extension AlertsVCiPad {
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        if self.isAzTabep {
            
            footerView.backgroundColor = UIColor(red: 32/255, green: 46/255, blue: 61/255, alpha: 1)
            
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
            let carKey = carSectionTitles[section]
            if let carValues = carsDictionary[carKey] {
                return carValues.count
            }
        } else {
            return cars.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 3
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell6", for: indexPath) as! AlertsTVCell
        
        cell.separatorInset.left = CGFloat(30)
        cell.separatorInset.right = CGFloat(30)
    
        if isAzTabep == true {
            cell.separatorInset.left = CGFloat(30)
            cell.separatorInset.right = CGFloat(50)
            let carKey = carSectionTitles[indexPath.section]
            if let carValues = carsDictionary[carKey] {
                cell.nameLbl.text = carValues[indexPath.row].name
            }
            let text = cell.nameLbl.text
            let arr = cars.filter({$0.name == text})
            let alert = arr.first?.date
            
            let date = alert?.dropLast(9)
            let time = alert?.dropFirst(11)
            
            cell.dateLbl.text = "\(date!)   \(time!)"
        } else {
            cell.separatorInset.left = CGFloat(30)
            cell.separatorInset.right = CGFloat(30)
            cell.nameLbl.text = cars[indexPath.row].name
            let alert = cars[indexPath.row].date
            
            let date = alert?.dropLast(9)
            let time = alert?.dropFirst(11)
            
            cell.dateLbl.text = "\(date!)   \(time!)"
        }
    
        if cell.nameLbl.text == name2 {
            cell.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0)
        }
        
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var text = " "
        
        let cell = tableView.cellForRow(at: indexPath) as! AlertsTVCell
        
        if cell.nameLbl.text != nil {
            text = cell.nameLbl.text!
        }
        
        name2 = text
//        if appDelegate.curentPdf.contains(where: {$0.model_name == text}) {
            performSegue(withIdentifier: "showAlertsPdf", sender: text)
//        } else {
//            progressView.isHidden = false
//            webView.isHidden = false
//            view.backgroundColor = UIColor.white
//            imageView.image = nil
//            progressShow()
//            var pdfname = PDFDownloader.shared.addPercent(fromString: text)
//            name = pdfname
//            read(nameFile: pdfname)
//            tableView.reloadData()
//        }
    }
    
    func read(nameFile: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("\(nameFile).pdf")
            //reading
            let request = URLRequest(url: fileURL)
            self.webView.loadRequest(request)
        }
    }
    
    func progressShow() {
        var progress: Float = 0.0
        self.progressBar.progress = 0
        // Do the time critical stuff asynchronously
        DispatchQueue.global(qos: .background).async {
            repeat {
                progress += 0.075
                Thread.sleep(forTimeInterval: 0.25)
                //                    print (progress)
                DispatchQueue.main.async(flags: .barrier) {
                    
                    self.progressBar.animateTo(progress: CGFloat(progress))
                }
                // time progress
            } while progress < 1.0
            DispatchQueue.main.async {
                self.progressView.isHidden = true
            }
        }
    }
    
    
    //MARK: -Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAlertsPdf" {
            let name = sender as! String
            
            let vs = segue.destination as! VitalStatVCiPad
            vs.name = name
            var arr = appDelegate.childs.filter({$0.name == name})
            
            vs.parentID = arr.first?.parent
        }
        
        if segue.identifier == "showAlertPdf" {
            let name = sender as! String
            
            let vs = segue.destination as! AlertsFSVC
            vs.name = name
            
        }
        
    }
}

