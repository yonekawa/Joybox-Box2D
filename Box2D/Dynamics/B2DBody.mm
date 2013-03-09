//
//  CBBody.m
//  CBBox2D
//
//  Created by Juan Jose Karam on 2/17/13.
//  Copyright (c) 2013 CurveBeryl. All rights reserved.
//
//  Inspired by:
//
//  Thanks to Axcho for his beautiful Cocos2D-Box2D implementation
//  CCBox2D (https://github.com/axcho/CCBox2D)


#import "B2DBody.h"
#import "B2DShape.h"


@implementation B2DBody

@synthesize body;
@synthesize position;
@synthesize angle;
@synthesize center;

- (id)initWithBody:(b2Body *)aBody
{
  self = [super init];
  
  if (self)
  {
    self.body = aBody;
    aBody->SetUserData((__bridge void *)self);
  }
  
  return self;
}


#pragma mark - Properties

- (CGPoint)position
{
  b2Vec2 actualPosition = self.body->GetPosition();
  
  return CGPointMake(actualPosition.x, actualPosition.y);
}


- (CGFloat)angle
{
  return self.body->GetAngle();
}


- (CGPoint)center
{
  b2Vec2 vectorCenter = self.body->GetWorldCenter();
  
  return CGPointMake(vectorCenter.x, vectorCenter.y);
}


- (BOOL)isSleepingAllowed
{
  return self.body->IsSleepingAllowed();
}


- (void)setSleepingAllowed:(BOOL)sleepingAllowed
{
  self.body->SetSleepingAllowed(sleepingAllowed);
}


#pragma mark - Public Methods

- (void)addFixureForShape:(B2DShape *)shape
                 friction:(CGFloat)friction
              restitution:(CGFloat)restitution
                  density:(CGFloat)density
                 isSensor:(BOOL)isSensor
{
  b2FixtureDef fixureDefinition;
  
  fixureDefinition.shape = shape.shape;
  fixureDefinition.friction = friction;
  fixureDefinition.restitution = restitution;
  fixureDefinition.density = density;
  fixureDefinition.isSensor = isSensor;
  body->CreateFixture(&fixureDefinition);
}


- (void)applyForce:(CGPoint)force
        atLocation:(CGPoint)location
         asImpulse:(BOOL)impulse
{
  b2Vec2 vectorForce;
  vectorForce.Set(force.x, force.y);
  
  b2Vec2 vectorLocation;
  vectorLocation.Set(location.x, location.y);
  
  if (impulse)
  {
    self.body->ApplyLinearImpulse(vectorForce, vectorLocation);
  }
  else
  {
    self.body->ApplyForce(vectorForce, vectorLocation);
  }
}


- (void)applyTorque:(CGFloat)torque
          asImpulse:(BOOL)impulse
{
  if (impulse)
  {
    self.body->ApplyAngularImpulse(torque);
  }
  else
  {
    self.body->ApplyTorque(torque);
  }
}

@end