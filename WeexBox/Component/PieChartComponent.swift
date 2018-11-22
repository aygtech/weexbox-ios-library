//
//  PieChartComponent.swift
//  WeexBox
//
//  Created by Mario on 2018/11/22.
//  Copyright © 2018 Ayg. All rights reserved.
//

import Foundation
import Charts

class PieChartComponent: BaseComponent, ChartViewDelegate {
    
    var chartView: PieChartView!
    
    override func loadView() -> UIView {
        chartView = PieChartView()
        return chartView
    }
    
    override func viewDidLoad() {
        chartView.delegate = self
    }
}
