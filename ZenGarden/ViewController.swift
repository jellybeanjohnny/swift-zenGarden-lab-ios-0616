//
//  ViewController.swift
//  ZenGarden
//
//  Created by Flatiron School on 6/30/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var rakeImageView: UIImageView!
	@IBOutlet weak var rockImageView: UIImageView!
	@IBOutlet weak var shrugImageView: UIImageView!
	@IBOutlet weak var swordRockImageView: UIImageView!
	
	
	@IBOutlet weak var rakeLeftConstraint: NSLayoutConstraint!
	@IBOutlet weak var rakeTopConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var rockTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var rockRightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var shrubLeftConstraint: NSLayoutConstraint!
	@IBOutlet weak var shrubBottomConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var swordRightConstraint: NSLayoutConstraint!
	@IBOutlet weak var swordBottomConstraint: NSLayoutConstraint!
	
	
	
	
	var currentLocation: CGPoint = CGPointZero
	
	override func viewDidLoad() {
		super.viewDidLoad()
		for subview in view.subviews where subview is UIImageView {
			let zenImageView = subview as! UIImageView
			let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan))
			zenImageView.addGestureRecognizer(panGesture)
		}
	}
	
	func handlePan(recognizer: UIPanGestureRecognizer) {
		
		if recognizer.view is UIImageView {
			let draggedImageView = recognizer.view as! UIImageView
			
			switch draggedImageView {
			case rakeImageView: drag(withPanGesture: recognizer, xConstraint: rakeLeftConstraint, yConstraint: rakeTopConstraint, isBottom: false)
			case rockImageView: drag(withPanGesture: recognizer, xConstraint: rockRightConstraint, yConstraint: rockTopConstraint, isBottom: false)
			case shrugImageView: drag(withPanGesture: recognizer, xConstraint: shrubLeftConstraint, yConstraint: shrubBottomConstraint, isBottom: true)
			case swordRockImageView: drag(withPanGesture: recognizer, xConstraint: swordRightConstraint, yConstraint: swordBottomConstraint, isBottom: true)
			default: break
			}
		}
	}
	
	func drag(withPanGesture panGesture: UIPanGestureRecognizer, xConstraint: NSLayoutConstraint, yConstraint: NSLayoutConstraint, isBottom: Bool) {
		let newLocation = panGesture.translationInView(view)
		
		if panGesture.state == .Began {
			currentLocation = newLocation
		}
		else if panGesture.state == .Changed {
			checkWinCondition()
			let deltaX = currentLocation.x - newLocation.x
			let deltaY = currentLocation.y - newLocation.y
			
			print("DeltaX: \(deltaX)")
			print("DeltaY: \(deltaY)")
			
			xConstraint.constant -= deltaX
			yConstraint.constant += isBottom ? deltaY : -deltaY
			
			currentLocation = newLocation
		}
	}
	
	func checkWinCondition() {
		
		
		var swordConditionMet = false
		var shrubRakeConditionMet = false
		var stoneConditionMet = false
		
		// sword should be in the top left or bottom left
		if swordRockImageView.center.x < view.center.x {
			swordConditionMet = true
		}
		
		// shrub and rake must be near each other
		if CGRectIntersectsRect(shrugImageView.frame, rakeImageView.frame) {
			shrubRakeConditionMet = true
		}
		
		// stone should be on a different north/south than sword
		if (rockImageView.center.y > view.center.y && swordRockImageView.center.y < view.center.y) ||
			(rockImageView.center.y < view.center.y && swordRockImageView.center.y > view.center.y) {
			stoneConditionMet = true
		}
		
		if swordConditionMet && shrubRakeConditionMet && stoneConditionMet {
			let alertController = UIAlertController.init(title: "You win", message: "yay", preferredStyle: UIAlertControllerStyle.Alert)
			let alertAction = UIAlertAction.init(title: "Okay", style: UIAlertActionStyle.Default, handler: { (action) in
				self.randomizeGardenObjects()
			})
			alertController.addAction(alertAction)
			self.presentViewController(alertController, animated: true, completion: nil)
			
		}
	}
	
	func randomizeGardenObjects() {
		// change the garden object's constraint constants to be some random values within the bounds of the screen
	}
	
}

