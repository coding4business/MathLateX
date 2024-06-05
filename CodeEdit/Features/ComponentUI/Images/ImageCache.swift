//
//  ImageCache.swift
//  MathLateX
//
//  Created by christian on 05/06/24.
//

import SwiftUI

protocol ImageCache {
  subscript(_ url: URL) -> NSImage? { get set }
}

struct TemporaryImageCache: ImageCache {
  private let cache: NSCache<NSURL, NSImage> = {
    let cache = NSCache<NSURL, NSImage>()
    cache.countLimit = 100  // 100 items
    cache.totalCostLimit = 1024 * 1024 * 100  // 100 MB
    return cache
  }()

  subscript(_ key: URL) -> NSImage? {
    get { cache.object(forKey: key as NSURL) }
    set {
      newValue == nil
        ? cache.removeObject(forKey: key as NSURL)
        : cache.setObject(newValue!, forKey: key as NSURL)
    }
  }
}
