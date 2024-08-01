//
//  ViewController.swift
//  vc
//
//  Created by Zhaojie CHEN(陳昭潔) on 2022/8/2.
//

import UIKit
import FABtn
import FABView

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var model: [String] = []
    let txf = UITextField()
    var datacount = 50
    private var row: Int! = nil
    let floatVC = FloatVC(fabDirection: .left, btnLeftOrRightSpace: 30, btnBottom: -30, btnPadding: 5, btnSize: 50, lblTextSize: 20)
    let floatView = FloatingActionButtonView(fabDirection: .right, fabCollapseImage: .img_add, fabExpandImage: .img_close, fabCollapseColor: .yellow, fabExpandColor: .black)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setData()
        addTableVC()
        layout()
        
        //floatVC.createFAB(image: .img_close, btnColor: .black)
        //floatVC.createFAB(image: UIImage(), title: "collapse1", btnColor: .yellow, lblColor: .yellow)
        //floatVC.createFAB(image: UIImage(), title: "no collapse", btnColor: .yellow, lblColor: .yellow)
        //addFloatingActionButtonView()
    }
    
    func addFloatingActionButtonView(){
        floatView.createFAB(image: .img_add, btnColor: .yellow)
        floatView.createFAB(image: UIImage(), title: "collapse2", btnColor: .yellow, lblColor: .yellow)
            //layoutFloaty
        view.insertSubview(floatView, at: 1)
        floatView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([floatView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0),
                                    floatView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0)])
    }
    
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.setImage(.img_add, for: .normal)
        btn.layer.cornerRadius = 25
        btn.backgroundColor = .yellow
        btn.addTarget(self, action: #selector(showFloatVC(_:)), for: .touchUpInside)
        return btn
    }()

    func layout(){
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([button.widthAnchor.constraint(equalToConstant: 50),
                                     button.heightAnchor.constraint(equalToConstant: 50),
                                     button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                                     button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)])
    }
    
    @IBAction func showFloatVC(_ sender: UIButton){
        present(floatVC, animated: false)
    }
    
    var data=[Int]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self), for: indexPath) as? TableViewCell{
            cell.textLabel!.text = "\(data[indexPath.row])"
            cell.textfield.text = model[indexPath.row]
            cell.textChanged {[weak self] newText in
                self?.model[indexPath.row] = newText
            }
            return cell
        }
        return UITableViewCell()
    }
        
    

    func addTableVC(){
         let tableView = UITableView(frame: .zero, style: .plain)
         self.view.addSubview(tableView)
         let leading = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
         let trailing = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0)
         let top = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 25)
         let bottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin,  multiplier: 1.0, constant: 0)
         NSLayoutConstraint.activate([leading, trailing, top, bottom])
         tableView.translatesAutoresizingMaskIntoConstraints = false
         tableView.register(TableViewCell.self, forCellReuseIdentifier: String(describing: TableViewCell.self))
         tableView.dataSource = self
         tableView.delegate = self
    }
    
    func setData(){
        for i in 0...datacount-1{
            data.append(i)
            model.append("")
        }
    }
}
