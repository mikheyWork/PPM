import UIKit
import Firebase

class ReferencesFSVC2: UIViewController {

    
    
    @IBOutlet weak var starBut: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    var name = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name = PDFDownloader.shared.addPercent(fromString: name)
        read(nameFile: name)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    func read(nameFile: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("\(nameFile).pdf")
            //reading
            let request = URLRequest(url: fileURL)
            self.webView.loadRequest(request)
        }
    }
    
    @IBAction func backBut(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func backBut2(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func menuBut(_ sender: Any) {
        //sideMenu
    }
    
}
