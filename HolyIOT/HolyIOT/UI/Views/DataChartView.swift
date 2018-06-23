//
//  DataChartView.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 30.04.2018.
//

import UIKit

typealias ChartName = String

class Chart {

	var sweep: Int = 200

	let name: ChartName

	let color: UIColor

	var array: Array<Float>

	init(_ name: ChartName) {

		self.name = name

		self.color = UIColor.randomColor

		self.array = Array<Float>()
	}

	func addValue(_ value: Float) {

		if array.count == sweep {
			array.removeFirst()
		}

		array.append(value)
	}

}

class DataChartView: UIView {

	/*Public*/

	var sweep: Int = 200

	var threshold: CGFloat = 5.0

	var unit: String = ""

	/*reserve of free space on screen*/
	var reserve: CGFloat = 0.15

	/*Private*/

	private var minThreshold: CGFloat {
		return -threshold
	}

	private var maxThreshold: CGFloat {
		return threshold
	}

	private var chartNames: [ChartName] = []

	private var charts = Dictionary<ChartName, Chart>()

	private var shapeLayers = Dictionary<ChartName, CAShapeLayer>()

	private var yShapeLayers = CAShapeLayer()

	private var minShapeLayers = CAShapeLayer()

	private var maxShapeLayers = CAShapeLayer()

	override func awakeFromNib() {
		super.awakeFromNib()

		yShapeLayers.fillColor = UIColor.clear.cgColor
		yShapeLayers.strokeColor = UIColor.white.cgColor
		yShapeLayers.lineWidth = 0.5
		self.layer.addSublayer(yShapeLayers)

		minShapeLayers.fillColor = UIColor.clear.cgColor
		minShapeLayers.strokeColor = UIColor.white.cgColor
		minShapeLayers.lineWidth = 0.5
		self.layer.addSublayer(minShapeLayers)

		maxShapeLayers.fillColor = UIColor.clear.cgColor
		maxShapeLayers.strokeColor = UIColor.white.cgColor
		maxShapeLayers.lineWidth = 0.5
		self.layer.addSublayer(maxShapeLayers)

		backgroundColor = .black
	}

	override func draw(_ rect: CGRect) {

		let aspectY = (rect.height / 2) / (threshold * (1.0 + reserve))

		let aspectX = rect.width / CGFloat(sweep)

		let centexY = rect.height / 2

		let textWidth: CGFloat = 100.0

		let textLeftOffset: CGFloat = 2.0

		let textHeight: CGFloat = 16.0

		for chartName in chartNames {
			drawChart(name: chartName, aspectX: aspectX, centexY: centexY, aspectY: aspectY)
		}

		let maxThresholdCenter = centexY - aspectY * threshold
		drawText("\(maxThreshold)\(unit)", size: CGRect(x: textLeftOffset, y: maxThresholdCenter - textHeight, width: textWidth, height: 14))
		drawLine(maxShapeLayers, leftOffset: 0, centerY: maxThresholdCenter, width: rect.width)

		drawText("0\(unit)", size: CGRect(x: textLeftOffset, y: centexY - textHeight, width: textWidth, height: 14))
		drawLine(yShapeLayers, leftOffset: 0, centerY: centexY, width: rect.width)

		let minThresholdCenter = centexY + aspectY * threshold
		drawText("\(minThreshold)\(unit)", size: CGRect(x: textLeftOffset, y: minThresholdCenter  - textHeight, width: textWidth, height: 14))
		drawLine(minShapeLayers, leftOffset: 0, centerY: minThresholdCenter, width: rect.width)
	}

	func drawText(_ text: String, size: CGRect) {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .left

		let attributes = [
			NSAttributedStringKey.paragraphStyle: paragraphStyle,
			NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0),
			NSAttributedStringKey.foregroundColor: UIColor.white
		]

		let attributedString = NSAttributedString(string: text, attributes: attributes)

		let stringRect = size
		attributedString.draw(in: stringRect)
	}

	func addShape(_ name: ChartName, _ color: UIColor? = nil) {

		let shape = CAShapeLayer()

		shape.fillColor = UIColor.clear.cgColor

		shape.strokeColor = color?.cgColor ?? UIColor.randomColor.cgColor

		shape.lineWidth = 1.0

		shapeLayers[name] = shape

		self.layer.addSublayer(shape)
	}

	func addChart(_ name: ChartName, _ color: UIColor? = nil) {

		chartNames.append(name)

		let chart = Chart(name)

		charts[name] = chart

		addShape(name, color)
	}

	func addValue(name: ChartName, _ value: Float) {

		if !chartNames.contains(name) {
			addChart(name)
		}

		charts[name]?.addValue(value)
	}

	func drawLine(_ shape: CAShapeLayer, leftOffset: CGFloat, centerY: CGFloat, width: CGFloat) {

		let path = UIBezierPath()

		path.move(to: CGPoint(x: leftOffset, y: centerY))

		path.addLine(to: CGPoint(x: width, y: centerY))

		shape.path = path.cgPath
	}

	func drawChart(name: ChartName, aspectX: CGFloat, centexY: CGFloat, aspectY: CGFloat) {

		guard let chart = charts[name], let shape = shapeLayers[name] else { return }

		let array = chart.array

		guard array.count > 1 else { return }

		let path = UIBezierPath()

		/*invert y value because Y axis of the view is inverted*/
		let firstPoint = CGPoint(x: 0.0, y: centexY - aspectY * CGFloat(array[0]))

		path.move(to: firstPoint)

		for index in 1..<array.count {
			/*invert y value because Y axis of the view is inverted*/
			let point = CGPoint(x: aspectX * CGFloat(index), y: centexY - aspectY * CGFloat(array[index]))
			path.addLine(to: point)
		}

		shape.path = path.cgPath
	}

}
