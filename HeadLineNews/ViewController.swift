//
//  ViewController.swift
//  HeadLineNews
//
//  Created by p-x9 on 2021/10/13.
//  
//

import Cocoa
import SnapKit

class ViewController: NSViewController {

    let headLineNewsView: HeadLineNewsView = {
        let view = HeadLineNewsView()
        view.frame = NSRect(x: 0, y: 0, width: 600, height: 30)
        return view
    }()

    let preferences = Preferences.shared
    let rssParser = RSSParser()
    var items: [Item] = []

    var isRunning: Bool {
        self.headLineNewsView.isRunning
    }

    var rssURLs: [URL] {
        preferences.rssUrls.compactMap { URL(string: $0) }
    }
    var speed: Float { preferences.textSpeed }
    var textColor: NSColor { NSColor(rgba: preferences.textColor) }
    var font: NSFont {
        NSFont(name: preferences.fontName, size: preferences.fontSize) ?? .systemFont(ofSize: 20)
    }
    var backgroundColor: NSColor { NSColor(rgba: preferences.backgroundColor) }

    override func loadView() {
        self.view = self.headLineNewsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.headLineNewsView.delegate = self
        self.updateUISettings()

        self.setupTapGesture()
        self.setupLongPressGesture()

        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(updateUISettings),
                                                          name: .shouldReloadUISettings, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(updateRssUrl),
                                                          name: .shouldChangeRssUrl, object: nil)
    }

    func setupTapGesture() {
        let tapGesture = NSClickGestureRecognizer()
        tapGesture.target = self
        tapGesture.action = #selector(tap)
        tapGesture.allowedTouchTypes = .direct
        self.view.addGestureRecognizer(tapGesture)
    }

    func setupLongPressGesture() {
        let longPressGesture = NSPressGestureRecognizer()
        longPressGesture.target = self
        longPressGesture.action = #selector(longPress)
        longPressGesture.allowedTouchTypes = .direct
        self.view.addGestureRecognizer(longPressGesture)
    }

    @objc
    func updateUISettings() {
        DispatchQueue.main.async {
            self.headLineNewsView.textColor = self.textColor
            self.headLineNewsView.speed = self.speed
            self.headLineNewsView.font = self.font
            self.headLineNewsView.backgroundColor = self.backgroundColor
        }
    }

    @objc
    func updateRssUrl() {
        DispatchQueue.main.async {
            let isRunning = self.isRunning
            self.headLineNewsView.stopAnimating()
            self.items = self.rssParser.parse(urls: self.rssURLs)
            if isRunning {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) {_ in
                    self.headLineNewsView.startAnimating(with: self.items)
                }
            }
        }
    }

    func openLink() {
        guard let item = self.headLineNewsView.currentItem,
              let url = URL(string: item.link) else {
            return
        }
        NSWorkspace.shared.open(url)
    }

    @objc
    func tap(_ sender: NSGestureRecognizer?) {
        if !self.isRunning {
            self.items = self.rssParser.parse(urls: self.rssURLs)
            self.headLineNewsView.startAnimating(with: items)
        } else {
            self.openLink()
        }
    }

    @objc
    func longPress(_ sender: NSGestureRecognizer?) {
        self.headLineNewsView.stopAnimating()
    }

}

extension ViewController: HeadLineNewsViewDelegate {
    func nextItems(for view: HeadLineNewsView) -> [Item] {
        self.items = self.rssParser.parse(urls: self.rssURLs)
        return self.items
    }

    func headLineNewsView(_ view: HeadLineNewsView, animationEndedWith items: [Item]) {

    }
}
