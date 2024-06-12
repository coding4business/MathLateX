//
//  EnvironmentValues+ImageCache.swift
//  MathLateX
//
//  Created by christian on 05/06/24.
//

import SwiftUI

struct ImageCacheKey: EnvironmentKey {
  static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
  var imageCache: ImageCache {
    get { self[ImageCacheKey.self] }
    set { self[ImageCacheKey.self] = newValue }
  }
}
