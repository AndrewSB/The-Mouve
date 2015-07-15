//
//  AOLinkedStoryboardSegue.h
//  The Mouve
//
//  Created by Hilal Habashi on 7/14/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHLinkStoryboards : UIStoryboardSegue

+ (UIViewController *)sceneNamed:(NSString *)identifier;

@end