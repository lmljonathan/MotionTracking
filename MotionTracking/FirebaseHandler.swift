//
//  FirebaseHandler.swift
//  MotionTracking
//
//  Created by Jonathan Lam on 1/30/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

let ref = FIRDatabase.database().reference()

func pushNode(node: Node) {
    print("push Node")
    print(ref.description())
    ref.child("Nodes").childByAutoId().setValue(node.toDictionary())
}
