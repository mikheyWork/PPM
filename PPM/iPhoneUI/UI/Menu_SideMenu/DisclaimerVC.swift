import UIKit

class DisclaimerVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        rangeChar()
        
        if appDelegate.model == "iPhone"  {
            textView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        
    }
    
    //nameLbl char range
    fileprivate func rangeChar() {
        let attributedString = nameLbl.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: 3.0, range: NSMakeRange(0, attributedString.length))
        nameLbl.attributedText = attributedString
    }
    
    @IBAction func acceptBut(_ sender: Any) {
        let alert = UIAlertController(title: "Disclaimer", message: "Do you agree to disclaimer?", preferredStyle: .alert)
        let agreeAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
        let disagreeAction = UIAlertAction(title: "No", style: .cancel) { (cancel) in
        }
        alert.addAction(agreeAction)
        alert.addAction(disagreeAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backBut(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
