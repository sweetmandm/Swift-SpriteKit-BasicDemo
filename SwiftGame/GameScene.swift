//
//  GameScene.swift
//  SwiftGame
//
//  Created by David Sweetman on 6/3/14.
//  Copyright (c) 2014 tinfish. All rights reserved.
//

import SpriteKit

let colors = ["FFBD6C", "E85B25", "FF3535", "E825DD", "9729FF"]

func genBodyImageWithSize(bodySize: CGSize) -> UIImage {
    var bodyImg: UIImage
    
    UIGraphicsBeginImageContext(bodySize)
    var ctx = UIGraphicsGetCurrentContext()
    var index = Int(arc4random() % UInt32(colors.count))
    CGContextSetFillColorWithColor(ctx, UIColor(hex: colors[index]).CGColor)
    CGContextFillEllipseInRect(ctx, CGRectMake(0, 0, bodySize.width, bodySize.height))
    bodyImg = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    CGContextRelease(ctx)
    
    return bodyImg
}

func degreesToRadians(degrees: Float) -> Float {
    return degrees * Float(M_PI) / 180.0
}

class GameScene: SKScene {
    var orbiters: Array<Orbiter> = []
    var hero = SKSpriteNode(texture: SKTexture(image: genBodyImageWithSize(CGSize(width: 10, height: 10))))
    var touchLoc = CGPointZero
    
    func moveHeroToPoint(point: CGPoint) {
        hero.position = point
    }
    
    func moveHeroWithVector(vec: CGVector) {
        hero.position = CGPointMake(hero.position.x + vec.dx, hero.position.y + vec.dy)
    }
    
    override func didMoveToView(view: SKView) {
        let distance: Float = 80.0
        moveHeroToPoint(CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)))
        genOrbiter(hero, size: 60, angle: 0, distance: distance)
        genOrbiter(hero, size: 40, angle: 45, distance: distance/2)
        genOrbiter(hero, size: 60, angle: 90, distance: distance)
        genOrbiter(hero, size: 40, angle: 135, distance: distance/2)
        genOrbiter(hero, size: 60, angle: 180, distance: distance)
        genOrbiter(hero, size: 40, angle: 225, distance: distance/2)
        genOrbiter(hero, size: 60, angle: 270, distance: distance)
        genOrbiter(hero, size: 40, angle: 315, distance: distance/2)
        self.addChild(hero)
    }
    
    func genOrbiter(center: SKSpriteNode, size: CGFloat, angle: CGFloat, distance: CGFloat) {
        var orbiter = Orbiter(texture: SKTexture(image: genBodyImageWithSize(CGSize(width: size, height: size))))
        orbiters.append(orbiter)
        orbiter.angle = angle
        orbiter.position = CGPoint(
            x: distance*cosf(degreesToRadians(orbiter.angle)),
            y: distance*sinf(degreesToRadians(orbiter.angle))
        )
        
        center.addChild(orbiter)
        
        orbiter.anchorPoint = CGPoint(
            x: (CGRectGetMidX(center.frame) - CGRectGetMidX(orbiter.frame)) / self.frame.size.width,
            y: (CGRectGetMidY(center.frame) - CGRectGetMidY(orbiter.frame)) / self.frame.size.height
        )
        var rotate = SKAction.rotateByAngle(degreesToRadians(10), duration: 0.1)
        var orbitAction = SKAction.repeatActionForever(rotate)
        orbiter.runAction(orbitAction)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let previous = touch.previousLocationInNode(self)
            var vec = CGVectorMake(location.x - previous.x, location.y - previous.y)
            moveHeroWithVector(vec)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}

