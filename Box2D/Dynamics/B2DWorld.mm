//
//  CBWorld.m
//  CBBox2D
//
//  Created by Juan Jose Karam on 2/17/13.
//  Copyright (c) 2013 CurveBeryl. All rights reserved.
//

#import "B2DWorld.h"
#import "B2DBody.h"
#import "B2DContactListener.h"

@interface B2DWorld ()

- (b2BodyType)convertBodyType:(B2DBodyTypes)bodyType;

@end


@implementation B2DWorld

- (id)init
{
  self = [super init];

  if (self) {

    b2Vec2 gravity;
    gravity.Set(0.0f, 0.0f);

    self.world = new b2World(gravity);
  }
  return self;
}


- (void)dealloc
{
  delete self.world;
  self.world = nil;
}


#pragma mark - Properties


- (CGPoint)gravity
{
  b2Vec2 gravity = self.world->GetGravity();

  return CGPointMake(gravity.x, gravity.y);
}


- (void)setGravity:(CGPoint)newGravity
{
  b2Vec2 gravity;
  gravity.Set(newGravity.x, newGravity.y);

  self.world->SetGravity(gravity);
}


- (BOOL)continuousPhysics
{
  return self.world->GetContinuousPhysics();
}


- (void)setContinuousPhysics:(BOOL)continuousPhysics
{
  self.world->SetContinuousPhysics(continuousPhysics);
}


- (BOOL)allowsSleeping
{
  return self.world->GetAllowSleeping();
}


- (void)setAllowsSleeping:(BOOL)allowsSleeping
{
  self.world->SetAllowSleeping(allowsSleeping);
}



#pragma mark - Public Methods

- (void)stepWithDelta:(CGFloat)delta
 velocityInteractions:(int)velocityInteractions
 positionInteractions:(int)positionInteractions
{
  self.world->Step(delta, velocityInteractions, positionInteractions);
}


- (B2DBody *)createBodyInPosition:(CGPoint)position
                             type:(B2DBodyTypes)bodyType
{
  b2BodyDef bodyDefinition;
  bodyDefinition.type = [self convertBodyType:bodyType];
  bodyDefinition.position.Set(position.x, position.y);

  b2Body *body = self.world->CreateBody(&bodyDefinition);

  return [[B2DBody alloc] initWithBody:body];
}


- (void)removeBody:(B2DBody *)body
{
  self.world->DestroyBody(body.body);
}


- (void)addContactListener:(B2DContactListener *)contactListener
{
  self.world->SetContactListener(contactListener.contactListener);
}


#pragma mark - Private Methods

- (b2BodyType)convertBodyType:(B2DBodyTypes)bodyType
{
  b2BodyType convertedBodyType = b2_staticBody;

  if (bodyType == kKinematicBodyType)
  {
    convertedBodyType = b2_kinematicBody;
  }
  else if(bodyType == kDynamicBodyType)
  {
    convertedBodyType = b2_dynamicBody;
  }

  return convertedBodyType;
}



@end
