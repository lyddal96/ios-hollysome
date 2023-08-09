//
//  BarChartViewController.swift
//  hollysome
//
//  Created by rocateer on 2020/01/22.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var singleBarChartView: BarChartView!
  @IBOutlet weak var multiBarChartView: BarChartView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var monthArr = [String]()
  var dayArr = [String]()
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    for value in 1..<13 {
      self.monthArr.append("\(value)")
    }
    
    
    var barData: [BarChartDataEntry] = []
    var index = 0
    for value in 0..<120 {
      if value % 10 == 0 {
        index += 1
        let dataEntry = BarChartDataEntry(x: Double(index), y: Double(value), data: self.monthArr)
        barData.append(dataEntry)
      }
    }
    self.singleBarChart(barData: barData)
    
    
    //    var dataEntries = [BarChartDataEntry]()
    //
    //    for i in 0..<dataPoints.count {
    //      let dataEntry = BarChartDataEntry(x: Double(i), yValues: [values[i], values2[i], values3[i]], data: dataPoints[i] as AnyObject?)
    //      dataEntries.append(dataEntry)
    //    }
    
    var dataEntries = [BarChartDataEntry]()
    
    for i in 0..<13 {
      let dataEntry = BarChartDataEntry(x: Double(i), yValues: [Double(i/3), Double(i/5), Double(i/2)], data: self.monthArr)
      dataEntries.append(dataEntry)
    }
    self.multiBarChart(barData: dataEntries)
    
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 싱글 바
  func singleBarChart(barData: [ChartDataEntry]) {
    self.singleBarChartView.data = nil
    
    let chartDataSet = BarChartDataSet(entries: barData, label: "")
//    chartDataSet.highlightColor = UIColor.red
//    chartDataSet.highlightAlpha = 1
    let chartData = BarChartData(dataSet: chartDataSet)
    
    self.singleBarChartView.data = chartData
    let xAxisValue = singleBarChartView.xAxis
    xAxisValue.valueFormatter = self
    
    
    chartDataSet.colors = [UIColor(red: 59/255, green: 174/255, blue: 229/255, alpha: 1)]
//    self.singleBarChartView.chartDescription?.text = ""
    self.singleBarChartView.xAxis.labelPosition = .bottom
    self.singleBarChartView.legend.enabled = false
    self.singleBarChartView.highlighter = nil
    self.singleBarChartView.scaleYEnabled = false
    self.singleBarChartView.scaleXEnabled = false
    self.singleBarChartView.pinchZoomEnabled = false
    self.singleBarChartView.doubleTapToZoomEnabled = false
    self.singleBarChartView.rightAxis.enabled = false
    self.singleBarChartView.xAxis.drawGridLinesEnabled = false
    
    self.singleBarChartView.barData?.setValueTextColor(UIColor.clear)
    
    let line = ChartLimitLine(limit: 60.0)
    self.singleBarChartView.leftAxis.addLimitLine(line)
    self.singleBarChartView.leftAxis.axisMinimum = 0.0
    self.singleBarChartView.leftAxis.axisMaximum = 120.0
    self.singleBarChartView.leftAxis.minWidth = 10.0
    self.singleBarChartView.leftAxis.spaceMax = 10.0
    self.singleBarChartView.leftAxis.labelCount = 13
    
    self.singleBarChartView.data = chartData
    
  }
  
  /// 멀티 바
  func multiBarChart(barData: [BarChartDataEntry]) {
    let chartDataSet = BarChartDataSet(entries: barData, label: "")
    chartDataSet.colors = [UIColor(named: "FC5A5D")!, UIColor(named: "F6D54A")!, UIColor(named: "2C9BF4")!]
    chartDataSet.stackLabels = ["사용안한시간", "설정시간", "초과시간"]
    
    let chartData = BarChartData(dataSets: [chartDataSet])
    chartData.barWidth = 0.5
    
    self.multiBarChartView.data = chartData
    let xAxisValue = self.singleBarChartView.xAxis
    xAxisValue.valueFormatter = self
    
    
    self.multiBarChartView.drawValueAboveBarEnabled = false
    self.multiBarChartView.fitBars = true
//    self.multiBarChartView.chartDescription?.text = ""
    self.multiBarChartView.xAxis.labelPosition = .bottom
    self.multiBarChartView.xAxis.granularity = 1
    self.multiBarChartView.barData?.setValueTextColor(UIColor.clear)
    self.multiBarChartView.highlighter = nil
    self.multiBarChartView.scaleYEnabled = false
    self.multiBarChartView.scaleXEnabled = false
    self.multiBarChartView.pinchZoomEnabled = false
    self.multiBarChartView.doubleTapToZoomEnabled = false
    self.multiBarChartView.rightAxis.enabled = false
    self.multiBarChartView.xAxis.drawGridLinesEnabled = false
    self.multiBarChartView.legend.horizontalAlignment = .right
    self.multiBarChartView.leftAxis.axisMinimum = 0.0
    self.multiBarChartView.leftAxis.axisMaximum = 12.0
    self.multiBarChartView.leftAxis.labelCount = 12
    self.multiBarChartView.data = chartData
    
    
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}
//-------------------------------------------------------------------------------------------
// MARK: - IAxisValueFormatter
//-------------------------------------------------------------------------------------------
extension BarChartViewController: AxisValueFormatter {
  
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    return "\(value)" //self.days[Int(value)]
  }
}

extension BarChartViewController: ChartViewDelegate {
//  chartValueSelected
  func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    log.debug("\(highlight)" )
  }
}


