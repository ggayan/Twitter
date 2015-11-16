//
//  MenuViewController.h
//  Twitter
//
//  Created by Gabriel Gayán on 11/12/15.
//  Copyright © 2015 Gabriel Gayan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ControllerSelection) {
    profile,
    timeline,
    mentions
};

@class MenuViewController;

@protocol MenuViewControllerDelegate <NSObject>

-(void)didSelectView:(ControllerSelection)selection;

@end

@interface MenuViewController : UIViewController

@property (weak, nonatomic) id<MenuViewControllerDelegate> delegate;

@end
