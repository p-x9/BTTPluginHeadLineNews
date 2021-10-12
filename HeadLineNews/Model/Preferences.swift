//
//  Preferences.swift
//  HeadLineNews
//
//  Created by p-x9 on 2021/10/13.
//  
//

import Foundation

class Preferences {
    static let shared = Preferences()

    var configuration: [AnyHashable: Any] = [:]

    var rssUrls: [String] = ["https://news.yahoo.co.jp/rss/topics/top-picks.xml"]
    var textSpeed: Float = 1
    var textColor: Int = 0xFFFFFFFF
    var fontName: String = "HelveticaNeue"
    var fontSize: CGFloat = 20.0
    var backgroundColor: Int = 0x00000000

    private init() {}

    func update(with configuration: [AnyHashable: Any]) {
        self.configuration = configuration

        var isChangedRSSUrl = false

        let prefix = "plugin_var_"
        configuration.forEach {key, value in
            guard let key = key as? String else {
                return
            }
            switch key {
            case prefix + "rssURLs":
                guard let value = value as? String else {
                    return
                }
                isChangedRSSUrl = value != self.rssUrls.joined(separator: ",")
                self.rssUrls = value.split(separator: ",").map { String($0) }
            case prefix + "textSpeed":
                self.textSpeed = value as? Float ?? 1
            case prefix + "textColor":
                guard let value = value as? String else {
                    return
                }
                self.textColor = NSColor(rgba: value)?.rgbaInt ?? 0xFFFFFFFF
            case prefix + "fontName":
                guard let value = value as? String else {
                    return
                }
                self.fontName = value
            case prefix + "fontSize":
                self.fontSize = value as? CGFloat ?? 20
            case prefix + "backgroundColor":
                guard let value = value as? String else {
                    return
                }
                self.backgroundColor = NSColor(rgba: value)?.rgbaInt ?? 0x00000000
            default:
                break
            }
        }

        if isChangedRSSUrl {
           NotificationCenter.default.post(name: .shouldChangeRssUrl, object: nil)
        }
        NotificationCenter.default.post(name: .shouldReloadUISettings, object: nil)
    }
}

extension NSNotification.Name {
    static let shouldChangeRssUrl = NSNotification.Name("shouldChangeRssUrl")
    static let shouldReloadUISettings = NSNotification.Name("shouldReloadUISettings")
}
