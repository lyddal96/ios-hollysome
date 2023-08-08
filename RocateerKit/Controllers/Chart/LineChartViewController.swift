//
//  singleLineChartViewController.swift
//  RocateerKit
//
//  Created by rocateer on 2020/01/22.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit
import Charts

class LineChartViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var singleLineChartView: LineChartView!
  @IBOutlet weak var multiLineChartView: LineChartView!
  
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
    
    
    var lineData: [ChartDataEntry] = []
    //    for (index, element) in studyWeekList.enumerated() {
    //      let dataEntry = ChartDataEntry(x: Double(index), y: Double(element.studyTime ?? 0), data: self.monthArr)
    //      lineData.append(dataEntry)
    //    }
    
    var index = 0
    for value in 0..<120 {
      if value % 10 == 0 {
        index += 1
        let dataEntry = ChartDataEntry(x: Double(index), y: Double(value), data: self.monthArr)
        lineData.append(dataEntry)
      }
    }
    self.singleLineChart(lineData: lineData)
    
    
    var lineData2: [ChartDataEntry] = []
    var index2 = 0
    for value in (0..<120).reversed() {
      if value % 10 == 0 {
        index2 += 1
        let dataEntry = ChartDataEntry(x: Double(index2), y: Double(value), data: self.monthArr)
        lineData2.append(dataEntry)
      }
    }
    
    self.multipleLineChart(lineData: lineData, lineData2: lineData2, dayArr: self.monthArr, redLabel: "red", blueLabel: "blue", minimum: 0, maximum: 120)
    
    
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
  /// 싱글 라인
  func singleLineChart(lineData: [ChartDataEntry]) {
    self.singleLineChartView.data = nil
    self.singleLineChartView.leftAxis.removeAllLimitLines()
    
    let chartDataSet = LineChartDataSet(entries: lineData, label: "레이블")
    
    let max = chartDataSet.yMax
    let maxLine = ChartLimitLine(limit: max) //, label: "\(Int(max))h"
    maxLine.drawLabelEnabled = true
    maxLine.lineColor = UIColor(named: "E6E6E6")!
    maxLine.lineDashLengths = [10.0]
    maxLine.lineDashPhase = 0.1
    maxLine.lineWidth = 1
    maxLine.labelPosition = .leftBottom
    maxLine.valueTextColor = UIColor(named: "333333")!
    
    chartDataSet.colors = [UIColor(named: "00AA7D")!]
    chartDataSet.lineWidth = 4
    chartDataSet.highlightEnabled = false
    chartDataSet.drawCirclesEnabled = false
    chartDataSet.drawCircleHoleEnabled = false
    //    chartDataSet.circleColors = [Colors._00AA7D]
    //    chartDataSet.circleRadius = 2
    chartDataSet.fillAlpha = 1
    chartDataSet.valueColors = [UIColor.clear]
    chartDataSet.highlightColor = .clear
    chartDataSet.drawIconsEnabled = true
    chartDataSet.iconsOffset = CGPoint(x: 0, y: 0)
    let gradient = self.getGradientRedFilling()
    chartDataSet.fill = LinearGradientFill(gradient: gradient, angle: 90.0)
    chartDataSet.drawFilledEnabled = true
    
    
    let data = LineChartData()
    data.dataSets = [chartDataSet]
    self.singleLineChartView.data = data
    self.singleLineChartView.legend.enabled = false
    self.singleLineChartView.leftAxis.addLimitLine(maxLine)
    self.singleLineChartView.doubleTapToZoomEnabled = false
    self.singleLineChartView.leftAxis.axisLineColor = .clear
    self.singleLineChartView.leftAxis.labelTextColor = .clear
    self.singleLineChartView.leftAxis.drawGridLinesEnabled = false
    self.singleLineChartView.leftAxis.axisMinimum = 0
    self.singleLineChartView.xAxis.drawGridLinesEnabled = true
    self.singleLineChartView.xAxis.gridColor = UIColor(named: "F7F7F7")!
    self.singleLineChartView.xAxis.drawGridLinesEnabled = true
    self.singleLineChartView.xAxis.gridLineWidth = 1.5
    self.singleLineChartView.xAxis.axisLineColor = UIColor.clear
    //      self.singleLineChartView.xAxis.labelFont = UIFont(name: "NanumBarunGothicOTF", size: 9)!
    self.singleLineChartView.xAxis.labelTextColor = UIColor(named: "999999")!
    self.singleLineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
    self.singleLineChartView.xAxis.labelCount = 11
    self.singleLineChartView.rightAxis.enabled = true
    self.singleLineChartView.rightAxis.drawGridLinesEnabled = false
    self.singleLineChartView.rightAxis.axisLineColor = UIColor(named: "999999")!
    self.singleLineChartView.rightAxis.axisLineWidth = 1.5
    self.singleLineChartView.rightAxis.labelTextColor = UIColor.clear
    self.singleLineChartView.setVisibleXRangeMaximum(7)
    
    var dayArrFormatter = [""]
    for value in self.monthArr {
      let stringMonth = "\(value)월"
      dayArrFormatter.append(stringMonth)
    }
    self.singleLineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dayArrFormatter)
    
    
  }
  
  /// 멀티라인
  func multipleLineChart(lineData: [ChartDataEntry], lineData2: [ChartDataEntry], dayArr: [String], redLabel: String, blueLabel: String, minimum: Double, maximum: Double) {
    self.multiLineChartView.data = nil
    self.multiLineChartView.leftAxis.removeAllLimitLines()
    self.dayArr = [String]()
    self.dayArr = dayArr
    
    let chartDataSet = LineChartDataSet(entries: lineData, label: redLabel)
    chartDataSet.colors = [UIColor(red: 252/255, green: 90/255, blue: 93/255, alpha: 1)]
    chartDataSet.circleColors = [UIColor(red: 252/255, green: 90/255, blue: 93/255, alpha: 1)]
    chartDataSet.circleRadius = 4
    chartDataSet.drawCircleHoleEnabled = false
    chartDataSet.lineWidth = 0.7
    chartDataSet.fillAlpha = 1
    chartDataSet.valueColors = [UIColor.clear]
    
    
    
    let chartDataSet2 = LineChartDataSet(entries: lineData2, label: blueLabel)
    chartDataSet2.colors =  [UIColor(red: 44/255, green: 155/255, blue: 244/255, alpha: 1)]
    chartDataSet2.circleColors = [UIColor(red: 44/255, green: 155/255, blue: 244/255, alpha: 1)]
    chartDataSet2.circleRadius = 4
    chartDataSet2.drawCircleHoleEnabled = false
    chartDataSet2.lineWidth = 0.7
    chartDataSet2.fillAlpha = 1
    chartDataSet2.valueColors = [UIColor.clear]
    
    
    
    let data = LineChartData()
    data.dataSets = [chartDataSet, chartDataSet2]
    self.multiLineChartView.data = data
    
    let redLine = ChartLimitLine(limit: 100.0)
    let blueLine = ChartLimitLine(limit: 140.0)
    redLine.drawLabelEnabled = true
    blueLine.drawLabelEnabled = true
    
    redLine.limit = 110.0
    redLine.lineColor = UIColor(named: "FC5A5D")!
    redLine.lineWidth = 0.3
    blueLine.limit = 140.0
    blueLine.lineColor = UIColor(named: "2C9BF4")!
    blueLine.lineWidth = 0.3
    
    self.multiLineChartView.legend.enabled = true
    self.multiLineChartView.legend.form = .circle
    self.multiLineChartView.legend.verticalAlignment = .top
    self.multiLineChartView.legend.horizontalAlignment = .right
    
    self.multiLineChartView.data = data
    self.multiLineChartView.leftAxis.axisLineColor = UIColor(named: "EFEFEF")!
    self.multiLineChartView.leftAxis.labelTextColor = UIColor(named: "282828")!
    self.multiLineChartView.leftAxis.addLimitLine(redLine)
    self.multiLineChartView.leftAxis.addLimitLine(blueLine)
    self.multiLineChartView.leftAxis.axisMinimum = minimum
    self.multiLineChartView.leftAxis.axisMaximum = maximum
    //    self.multiLineChartView.xAxis.granularity = 2.0
    
    self.multiLineChartView.rightAxis.enabled = true
    self.multiLineChartView.rightAxis.drawGridLinesEnabled = false
    self.multiLineChartView.rightAxis.axisLineColor = UIColor(named: "EFEFEF")!
    self.multiLineChartView.rightAxis.labelTextColor = UIColor.clear
    self.multiLineChartView.xAxis.labelCount = 11
    self.multiLineChartView.xAxis.drawGridLinesEnabled = true
    self.multiLineChartView.xAxis.gridColor = UIColor(named: "EFEFEF")!
    self.multiLineChartView.xAxis.axisLineColor = UIColor.clear
    self.multiLineChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
    self.multiLineChartView.xAxis.labelTextColor = UIColor(named: "797979")!
    
    log.debug(self.multiLineChartView.xAxis.labelCount)
    
    var dayArrFormatter = [""]
    for value in self.monthArr {
      let stringMonth = "\(value)월"
      dayArrFormatter.append(stringMonth)
    }
    
    self.multiLineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dayArrFormatter)
    
  }
  
  
  /// 라인 하단에 그라데이션
  func getGradientRedFilling() -> CGGradient {
    let coloTop = UIColor(red: 0/255, green: 170/255, blue: 125/255, alpha: 0.12).cgColor
    let colorBottom = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1).cgColor
    let gradientColors = [coloTop, colorBottom] as CFArray
    let colorLocations: [CGFloat] = [0.7, 0.0]
    return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!
  }

  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}


