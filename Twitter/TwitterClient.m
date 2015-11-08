//
//  TwitterClient.m
//  Twitter
//
//  Created by Gabriel Gayán on 11/5/15.
//  Copyright © 2015 Gabriel Gayan. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"Xi4Ha2FVzixcEId3OJlJlJCpB";
NSString * const kTwitterConsumerSecret = @"jmBHiNpiCp8zhgk6pKGwVPkMnMVUseDb9ixLdZNOSUEzGMY8wo";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl]
                                                  consumerKey:kTwitterConsumerKey
                                               consumerSecret:kTwitterConsumerSecret];
        }
    });

    return instance;
}


- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion= completion;
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"/oauth/request_token"
                             method:@"POST"
                        callbackURL:[NSURL URLWithString:@"ggayantwitter://request"]
                              scope:nil
                            success:^(BDBOAuth1Credential *requestToken) {
                                NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
                            }
                            failure:^(NSError *error) {
                                NSLog(@"Error: %@", error.localizedDescription);
                                self.loginCompletion(nil, error);
                            }];
}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token"
                            method:@"POST"
                      requestToken:[BDBOAuth1Credential
                                    credentialWithQueryString:url.query]
                           success:^(BDBOAuth1Credential *accessToken) {
                               NSLog(@"got the access token!");
                               [self.requestSerializer saveAccessToken:accessToken];

                               [self GET:@"1.1/account/verify_credentials.json" parameters:nil
                                 success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                     User *user = [[User alloc] initWithDictionary:responseObject];
                                     [User setCurrentuser:user];
                                     NSLog(@"current user: %@", user.name);
                                     self.loginCompletion(user, nil);
                                 } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                     NSLog(@"failed getting current user");
                                     self.loginCompletion(nil, error);
                                 }];
                           } failure:^(NSError *error) {
                               NSLog(@"Failed to get the request token!");
                               self.loginCompletion(nil, error);
                           }];

}

- (void)homeTimeLineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

@end
