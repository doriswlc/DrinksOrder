//
//  OrderTableViewController.swift
//  DrinksOrder
//
//  Created by doriswlc on 2022/10/18.
//

import UIKit

class OrderTableViewController: UITableViewController {
    var orderRecord: OrderRecord!
    var drinkSelected: Fields!
    var customerOrder = CustomerOrder(records: [])
    var addons = [Addon]()
    var priceM = 0
    var priceL = 0

    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var sizeSegment: UISegmentedControl!
    @IBOutlet var addonButton: [UIButton]!
    @IBOutlet weak var iceSegment: UISegmentedControl!
    @IBOutlet weak var sugarSegment: UISegmentedControl!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderRecord = OrderRecord(fields: DrinkOrdered(drinkName: drinkSelected.drinkname, size: "M", addon: [], ice: "正常", sugar: "正常", qty: 1, price: 0, customerName: "鐵粉", customerPhone: "0912345678"))
        initialSizeIH()
        updateUI()
    }
    
    func initialSizeIH() {
        var priceStr = ""
        if drinkSelected.size.count == 2 {
            priceStr = drinkSelected.price[0]
            priceStr.removeFirst()
            priceM = Int(priceStr)!
            priceStr = drinkSelected.price[1]
            priceStr.removeFirst()
            priceL = Int(priceStr)!
            switch sizeSegment.selectedSegmentIndex {
            case 0:
                orderRecord.fields.size = drinkSelected.size[0]
                orderRecord.fields.price = priceM
            case 1:
                orderRecord.fields.size = drinkSelected.size[1]
                orderRecord.fields.price = priceL
            default:
                break
            }
        } else {
            priceStr = drinkSelected.price[0]
            priceStr.removeFirst()
            switch drinkSelected.size[0] {
            case "M":
                priceM = Int(priceStr)!
                sizeSegment.removeSegment(at: 1, animated: true)
                orderRecord.fields.price = priceM
            case "L":
                priceL = Int(priceStr)!
                sizeSegment.removeSegment(at: 0, animated: true)
                orderRecord.fields.price = priceL
            default:
                break
            }
        }
        if drinkSelected.ih.contains("Fix") {
            for _ in 1...3 {
                iceSegment.removeSegment(at: 1, animated: true)
            }
            sugarSegment.selectedSegmentIndex = 0
            sugarSegment.isEnabled.toggle()
        }
        if !drinkSelected.ih.contains("H") {
            iceSegment.removeSegment(at: iceSegment.numberOfSegments - 1, animated: true)
        }
    }
    
    func updateUI() {
        drinkNameLabel.text = orderRecord.fields.drinkName
        qtyLabel.text = "\(orderRecord.fields.qty)"
        priceLabel.text = "$\(orderRecord.fields.price)"
        orderButton.setTitle("訂購\(orderRecord.fields.qty)杯，總金額：$\(orderRecord.fields.price * orderRecord.fields.qty)", for: .normal)
    }
    
    @IBAction func sizeChange(_ sender: UISegmentedControl) {
        if sizeSegment.selectedSegmentIndex == 1 {
            orderRecord.fields.price += priceL - priceM
        } else {
            orderRecord.fields.price -= priceL - priceM
        }
        updateUI()
    }
    
    @IBAction func addonChosen(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected.toggle()
            switch sender {
            case addonButton[0]:
                orderRecord.fields.price += Addon.A.rawValue
            case addonButton[1]:
                orderRecord.fields.price += Addon.B.rawValue
            case addonButton[2]:
                orderRecord.fields.price += Addon.C.rawValue
            case addonButton[3]:
                orderRecord.fields.price += Addon.D.rawValue
            default:
                break
            }
            orderRecord.fields.addon.append(sender.configuration?.title ?? "")
        } else {
            sender.isSelected.toggle()
            switch sender {
            case addonButton[0]:
                orderRecord.fields.price -= Addon.A.rawValue
            case addonButton[1]:
                orderRecord.fields.price -= Addon.B.rawValue
            case addonButton[2]:
                orderRecord.fields.price -= Addon.C.rawValue
            case addonButton[3]:
                orderRecord.fields.price -= Addon.D.rawValue
            default:
                break
            }
            var index = 0
            for i in addons.indices {
                if orderRecord.fields.addon[i] == sender.configuration?.title {
                    index = i
                }
            }
            orderRecord.fields.addon.remove(at: index)
        }
        updateUI()
    }
    
    @IBAction func iceChange(_ sender: UISegmentedControl) {
        if iceSegment.numberOfSegments == 5 {
            switch iceSegment.selectedSegmentIndex {
            case 0:
                orderRecord.fields.ice = "正常"
            case 1:
                orderRecord.fields.ice = "少冰"
            case 2:
                orderRecord.fields.ice = "微冰"
            case 3:
                orderRecord.fields.ice = "去冰"
            case 4:
                orderRecord.fields.ice = "熱飲"
            default:
                break
            }
        } else if iceSegment.numberOfSegments == 2 {
            switch iceSegment.selectedSegmentIndex {
            case 0:
                orderRecord.fields.ice = "正常"
            case 1:
                orderRecord.fields.ice = "熱飲"
            default:
                break
            }
        } else {
            orderRecord.fields.ice = "正常"
        }
    }
    
    @IBAction func sugarChange(_ sender: UISegmentedControl) {
        switch sugarSegment.selectedSegmentIndex {
        case 0:
            orderRecord.fields.sugar = "正常"
        case 1:
            orderRecord.fields.sugar = "少糖"
        case 2:
            orderRecord.fields.sugar = "半糖"
        case 3:
            orderRecord.fields.sugar = "微糖"
        case 4:
            orderRecord.fields.sugar = "無糖"
        default:
            break
        }
    }
    
    @IBAction func amountChange(_ sender: UIStepper) {
        orderRecord.fields.qty = Int(sender.value)
        updateUI()
    }
    
    @IBAction func placeSingleOrder(_ sender: UIButton) {
        performSegue(withIdentifier: "showOrders", sender: nil)
    }
    
    @IBSegueAction func showOrders(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> OrderListTableViewController? {
        let controller = OrderListTableViewController(coder: coder)
        controller?.orderRecord = self.orderRecord
        return controller
    }
}
