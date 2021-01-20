//
//  ViewController.swift
//  ZJMKit
//
//  Created by simplismvip on 03/28/2020.
//  Copyright (c) 2020 simplismvip. All rights reserved.
//

import UIKit
import ZJMKit
import SnapKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource = [JMModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        dataSource = JMDataTools.parseJson(name: "zjmkit")
        tableView.register(JMTableViewCell.self, forCellReuseIdentifier: "JMTableViewCell")
//        view.addSubview(btn)
//        btn.setTitle("按钮😄", for: .normal)
//        btn.jmAddAction { (_) in
//            JMNotify.jmNotify(eventName: "NotifyViewController", info: nil)
//        }
        
        JMNotify.jmRegisterNotify(eventName: "NotifyViewController", instanse: self) { (_) in
            print("---ViewController")
        }
        
//        NotificationCenter.default.jm.addObserver(target: self, name: "NotifyViewController") { (notify) in
//            print(notify)
//        }
//
//        NotificationCenter.default.jm.addObserver(target: self, name: "SecNotifyViewController") { (notify) in
//            print(notify)
//        }
    }

//    @IBAction func show(_ sender: Any) {
//        JMTextToast.share.jmShowString(text: "哈哈，我是一个☝️弹窗", seconds: 5)
//    }
//
//    @IBAction func tapAction(_ sender: Any) {
//        navigationController?.pushViewController(SECONDController(), animated: true)
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        btn.frame = CGRect.Rect(100, 100, 100, 100)
//    }
}

// MARK: TableView --
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "JMTableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "JMTableViewCell")
        }
        let newcell = cell as? JMTableViewCell
        newcell?.title.text = dataSource[indexPath.row].title
        newcell?.subTitle.text = dataSource[indexPath.row].subTitle
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vcStr = dataSource[indexPath.row].pushvc,
           let anyclass = JMStrToClass.jmClassFrom(vcStr),
           let controller = (anyclass as? UIViewController.Type)?.init() {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

class JMTableViewCell: JMBaseTableViewCell {
    public let title = UILabel() // 标题
    public let subTitle = UILabel() // 自标题
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(title)
        contentView.addSubview(subTitle)
        backgroundColor = UIColor.white
    
        title.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(5)
            make.height.equalTo(29)
            make.left.equalTo(snp.left).offset(10)
        }
        
        subTitle.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(2)
            make.height.equalTo(20)
            make.left.equalTo(title)
        }
        
        title.jmConfigLabel(font: UIFont.jmMedium(17), color: UIColor.jmHexColor("#333333"))
        subTitle.jmConfigLabel(font: UIFont.jmRegular(12), color: UIColor.jmHexColor("#333333"))
    }

    func refresh(model: JMModel) {
        title.text = model.title
        subTitle.text = model.subTitle
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
