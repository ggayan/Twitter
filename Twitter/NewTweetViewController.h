//
//  NewTweetViewController.h
//  Twitter
//
//  Created by Gabriel Gayan on 15/8/11.
//  Copyright © 2015 Gabriel Gayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"

@class NewTweetViewController;

@protocol NewTweetViewControllerDelegate <NSObject>

- (void)newTweetCreated:(Tweet *)tweet;

@end

@interface NewTweetViewController : UIViewController

@property (nonatomic) NSString *initialText;
@property (nonatomic) NSString *replyingTweetId;
@property (nonatomic) id<NewTweetViewControllerDelegate> delegate;

@end
