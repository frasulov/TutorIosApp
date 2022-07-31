//
//  CustomCalloutViewModel.swift
//  Tutor
//
//  Created by Fagan Rasulov on 28.07.22.
//

import UIKit
import MapViewPlus

// CalloutViewModel is a protocol of MapVieWPlus. Currently, it has no requirements to its conformant classes.
class YourCalloutViewModel: CalloutViewModel {

  var title: String
  var image: UIImage

  init(title: String, image: UIImage) {
    self.title = title
    self.image = image
  }
}
