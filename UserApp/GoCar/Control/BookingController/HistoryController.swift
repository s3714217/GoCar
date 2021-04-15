//
//  HistoryController.swift
//  GoCar
//
//  Created by Thien Nguyen on 15/4/21.
//

import UIKit

class HistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var history: [History]!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell {
           
            
            cell.carImg.image = UIImage(imageLiteralResourceName: history[indexPath.row].carModel.lowercased().trimmingCharacters(in: .whitespaces))
            cell.carRego.text! = "Car Rego: \(history[indexPath.row].carID)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            cell.carModel.text! = "Car Model: \(history[indexPath.row].carModel)"
            cell.returnDate.text! = "Return date: \(dateFormatter.string(from: history[indexPath.row].returnDate)) "
            cell.cost.text! = "Cost: $\(String(history[indexPath.row].amount))"
            cell.transaction.text! = "ID: \(history[indexPath.row].id)"
            return cell
        }
    
        return UITableViewCell()
    }
    

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.registerTableViewCells()
    }
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "TableViewCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "TableViewCell")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
