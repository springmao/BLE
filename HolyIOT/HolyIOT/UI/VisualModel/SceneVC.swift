//
//  SceneVC.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 16.04.2018.
//

import SceneKit

class SceneVC: UIViewController {

    @IBOutlet weak var sceneView: SCNView!

    var device: HolyDevice!

    var cubeNode: SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = SCNScene()

        sceneView.scene = scene

        let camera = SCNCamera()

        let cameraNode = SCNNode()

        cameraNode.camera = camera

        cameraNode.position = SCNVector3(x: 0.0, y: 0.0, z: 3.0)

        let light = SCNLight()

        light.type = SCNLight.LightType.omni

        let lightNode = SCNNode()

        lightNode.light = light

        lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)

        let cubeGeometry = SCNBox(width: 1.0, height: 0.2, length: 1.5, chamferRadius: 0.15)

        cubeNode = SCNNode(geometry: cubeGeometry)

        scene.rootNode.addChildNode(lightNode)
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(cubeNode)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        device.delegate = self
    }
}

extension SceneVC: HolyDeviceProtocol {
    func holyDevice(_ holyDevice: HolyDevice, didReceiveAccData data: AccelerometerData) {

    }

    func holyDevice(_ holyDevice: HolyDevice, didReceiveGyroData data: GyroscopeData) {

    }

    func holyDevice(_ holyDevice: HolyDevice, didReceiveMagnetoData data: MagnetometerData) {

    }

    func holyDevice(_ holyDevice: HolyDevice, didReceiveBarometerValue value: Int) {

    }

    func holyDevice(_ holyDevice: HolyDevice, didReceiveHumidityValue value: Float) {

    }

    func holyDevice(_ holyDevice: HolyDevice, didReceiveTemperatureValue value: Float) {

    }

    func connected(_ holyDevice: HolyDevice) {

    }

    func disconnected(_ holyDevice: HolyDevice) {

    }
	
	func sensorReady(_ holyDevice: HolyDevice, sensorType: SensorType) {
		
	}

    func holyDevice(_ holyDevice: HolyDevice, didReceiveSFLData data: SFLData) {

        let qx = data.x
        let qy = data.y
        let qz = data.z
        let qw = data.w

        let vector = toEulerAngle(q: SCNQuaternion(x: qx, y: qy, z: qz, w: qw))

        cubeNode.eulerAngles = SCNVector3(x: vector.y, y: -vector.z, z: vector.x)
    }

    func toEulerAngle(q: SCNQuaternion) -> SCNVector3 {
        // roll (x-axis rotation)
        let sinr = 2.0 * (q.w * q.x + q.y * q.z)
        let cosr = 1.0 - 2.0 * (q.x * q.x + q.y * q.y)
        let roll = atan2(sinr, cosr)

        // pitch (y-axis rotation)
        let sinp = 2.0 * (q.w * q.y - q.z * q.x)

        var pitch: Float!
        if (fabs(sinp) >= 1) {
            pitch = copysign(Float.pi / 2, sinp) // use 90 degrees if out of range
        } else {
            pitch = asin(sinp)
        }

        // yaw (z-axis rotation)
        let siny = +2.0 * (q.w * q.z + q.x * q.y)
        let cosy = +1.0 - 2.0 * (q.y * q.y + q.z * q.z)
        let yaw = atan2(siny, cosy)

        return SCNVector3(x: pitch, y: yaw, z: roll)
    }
}
