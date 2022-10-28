//
//  OrderListTableViewController.swift
//  DrinksOrder
//
//  Created by doriswlc on 2022/10/21.
//

import UIKit

class OrderListTableViewController: UITableViewController {
    var orderRecord: OrderRecord!
    var customerOrder: CustomerOrder!
    var totalQty = 0
    var totalPrice = 0
    
    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var uploadOrders: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var orders = OrderRecord.loadOrders() ?? []
        orders.append(orderRecord)
        customerOrder = CustomerOrder(records: orders)
        updateOrder()
        OrderRecord.saveOrders(customerOrder.records)
    }

    func updateOrder() {
        for i in customerOrder.records.indices {
            customerOrder.records[i].fields.customerName = customerName.text ?? ""
            customerOrder.records[i].fields.customerPhone = phoneLabel.text ?? ""
        }
        totalQty = 0
        totalPrice = 0
        for _ in customerOrder.records {
            totalQty += orderRecord.fields.qty
            totalPrice += orderRecord.fields.qty * orderRecord.fields.price
        }
        detailLabel.text = "總共\(totalQty)杯，總金額為\(totalPrice)元"
    }
    
    @IBAction func uploadOrders(_ sender: UIButton) {
        uploadOrders.isEnabled.toggle()
        updateOrder()
        let orderBody = customerOrder
        if let url = URL(string: "https://api.airtable.com/v0/appWKQiePYTFRgmRM/Order") {
            var request = URLRequest(url: url)
            request.setValue("Bearer keySfV0P5ClR74OTq", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
            request.httpBody = try? encoder.encode(orderBody)
            URLSession.shared.dataTask(with: request) { data, response , error in
                if let data, let content = String(data: data, encoding: .utf8) {
                    print(content)
                }
            }.resume()
        }
        let controller = UIAlertController()
        let okAction = UIAlertAction(title: "訂單上傳成功", style: .default)
        controller.addAction(okAction)
        present(controller, animated: true)
        customerOrder.records = []
        OrderRecord.saveOrders(customerOrder.records)
        detailLabel.text! += " 已下訂!"
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerOrder.records.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderTableViewCell.self)", for: indexPath) as! OrderTableViewCell
        let record = customerOrder.records[indexPath.row]
        cell.drinkNameLabel.text = record.fields.drinkName
        cell.sizeLabel.text = record.fields.size
        cell.qtyLabel.text = "\(record.fields.qty)"
        cell.priceLabel.text = "\(record.fields.price)"
        cell.addonLabel.text = "\(record.fields.addon)"
        cell.iceLabel.text = record.fields.ice
        cell.sugarLabel.text = record.fields.sugar
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        customerOrder.records.remove(at: indexPath.row)
        updateOrder()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        OrderRecord.saveOrders(customerOrder.records)
    }
}
