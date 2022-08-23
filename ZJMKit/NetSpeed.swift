//
//  NetSpeed.swift
//  ZJMKit
//
//  Created by JunMing on 2022/8/23.
//  Copyright © 2022 JunMing. All rights reserved.
//

import UIKit

public typealias CurrNetSpeed = (_ speed: String) -> Void

public enum ConnectType {
    case wifi
    case wwan
    case unknow
    
    var name: String {
        switch self {
        case .wifi:
            return "Wi-Fi"
        case .wwan:
            return "蜂窝网络"
        case .unknow:
            return "无网络"
        }
    }
}

public enum SpeedType {
    case recv
    case sent
    case all
    
    // wifi和wwan只能使用一个上面能表示所以情况
    var name: String {
        switch self {
        case .recv:
            return "下载速度"
        case .sent:
            return "上传速度"
        case .all:
            return "当前总速度"
        }
    }
}

public struct ByteCount {
    public var received: UInt64 = 0
    public var sent: UInt64 = 0
    public var total: UInt64 {
        return received + sent
    }

    var zero: Bool {
        return (received == 0) && (sent == 0)
    }
}

extension ByteCount {
    // 当前网速
    static func speed(new: ByteCount, old: ByteCount, interval: TimeInterval) -> ByteCount {
        let recv = (new.received > old.received) ? (new.received - old.received) : 0
        let sent = (new.sent > old.sent) ? (new.sent - old.sent) : 0
        return ByteCount(received: recv, sent: sent)
    }
}

public class NetSpeed {
    private var timer: Timer?
    private var netSpeed: CurrNetSpeed?
    private var lastData = NetTool.ByteData()
    public static let share = NetSpeed()
    
    public var connType: ConnectType {
        if let address = NetTool.getAddress(true) {
            return (address.count > 0) ? .wifi : .wwan
        }
        return .unknow
    }
    
    /// wifi下载速度
    private func wifi(_ timeInterval: TimeInterval) -> ByteCount {
        let newByte = NetTool.getInterfaceBytes()
        let byteCount = ByteCount.speed(new: newByte.wifi, old: lastData.wifi, interval: timeInterval)
        self.lastData = newByte
        return byteCount
    }
    
    private func wwan(_ timeInterval: TimeInterval) -> ByteCount {
        let newByte = NetTool.getInterfaceBytes()
        let byteCount = ByteCount.speed(new: newByte.wwan, old: lastData.wwan, interval: timeInterval)
        self.lastData = newByte
        return byteCount
    }
    
    private func startTimer(_ type: SpeedType, _ timeInterval: TimeInterval) {
        if timer != nil { endNetSpeed() }
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self](_) in
            if let speed = self?.currNetSpeed(type, timeInterval) {
                self?.netSpeed?(speed)
            }
        }
    }
    
    // 停止监听当前网速
    public func endNetSpeed() {
        timer?.invalidate()
        timer = nil
    }
    
    // 打开计时器回调返回当前网速
    public func startNetSpeed(_ type: SpeedType, _ timeInterval: TimeInterval = 1, netSpeed: @escaping CurrNetSpeed) {
        self.netSpeed = netSpeed
        self.startTimer(type, timeInterval)
    }
    
    /// 被动调用获取当前网速
    public func currNetSpeed(_ type: SpeedType, _ timeInterval: TimeInterval = 0.5) -> String {
        switch type {
        case .recv:
            return netSpeed(type, timeInterval).received.double.format
        case .sent:
            return netSpeed(type, timeInterval).sent.double.format
        case .all:
            return netSpeed(type, timeInterval).total.double.format
        }
    }
    
    public func netSpeed(_ type: SpeedType, _ timeInterval: TimeInterval) -> ByteCount {
        if lastData.zero {
            lastData = NetTool.getInterfaceBytes()
            return ByteCount()
        } else {
            if connType == .wwan {
                return wwan(timeInterval)
            } else if connType == .wifi {
                return wifi(timeInterval)
            } else {
                return ByteCount()
            }
        }
    }
}

public struct NetTool {
    struct ByteData {
        var wifi = ByteCount()
        var wwan = ByteCount()
        var zero: Bool {
            return wifi.zero && wwan.zero
        }
    }
    
    static func getInterfaceBytes() -> ByteData {
        var result = ByteData()
        var addrsPointer: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&addrsPointer) == 0 {
            var pointer = addrsPointer
            while pointer != nil {
                if let addrs = pointer?.pointee {
                    let name = String(cString: addrs.ifa_name)
                    if addrs.ifa_addr.pointee.sa_family == UInt8(AF_LINK) {
                        if name.hasPrefix("en") { // Wifi
                            let networkData = unsafeBitCast(addrs.ifa_data, to: UnsafeMutablePointer<if_data>.self)
                            result.wifi.received += UInt64(networkData.pointee.ifi_ibytes)
                            result.wifi.sent += UInt64(networkData.pointee.ifi_obytes)
                        } else if name.hasPrefix("pdp_ip") { // WWAN
                            let networkData = unsafeBitCast(addrs.ifa_data, to: UnsafeMutablePointer<if_data>.self)
                            result.wwan.received += UInt64(networkData.pointee.ifi_ibytes)
                            result.wwan.sent += UInt64(networkData.pointee.ifi_obytes)
                        }
                    }
                }
                pointer = pointer?.pointee.ifa_next
            }
            freeifaddrs(addrsPointer)
        }
        return result
    }
    
    // 获取Wi-Fi/WWAN ip地址
    public static func getAddress(_ isWifi: Bool) -> String? {
        var address : String?
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                let name = String(cString: interface.ifa_name)
                if name == (isWifi ? "en0" : "pdp_ip0") {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
}

extension UInt64 {
    var double: Double {
        return Double(self)
    }
}

extension Double {
    public var kb: Double {
        return self / 1024
    }
    
    public var mb: Double {
        return kb / 1024
    }
    
    public var gb: Double {
        return mb / 1024
    }
    
    public func format(_ n: Int) -> String {
        return String(format: "%.\(n)f", self)
    }
    
    public var format: String {
        if self.gb > 1 {
            return self.gb.format(0) + " GB"
        } else if self.mb > 1 {
            return self.mb.format(0) + " MB"
        } else {
            return self.kb.format(0) + " KB"
        }
    }
}
