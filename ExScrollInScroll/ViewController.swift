//
//  ViewController.swift
//  ExScrollInScroll
//
//  Created by 김종권 on 2023/01/09.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.bounces = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
    }()
    private let emptyView = UIView()
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    private let tableView: UITableView = {
        let view = UITableView()
        view.bounces = false
        view.backgroundColor = .lightGray
        // 1.
//        view.isScrollEnabled = false
        return view
    }()
    
    private let items = (0...500).map(String.init)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(emptyView)
        stackView.addArrangedSubview(tableView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        emptyView.snp.makeConstraints {
            $0.height.equalTo(500)
        }
        tableView.snp.makeConstraints {
            $0.height.equalTo(1200)
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        
        scrollView.delegate = self
        tableView.delegate = self
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        
        let topMargin = 56.0 // 상단 56.0 마진
        let topSpacing = emptyView.bounds.height - topMargin
        
        if scrollView == self.scrollView {
            // 상단 뷰의 height만큼 스크롤 한 경우, tableView의 스크롤 on
            let shouldOnScroll = topSpacing - scrollView.contentOffset.y < 0
            tableView.isScrollEnabled = shouldOnScroll
        }
    }
}
