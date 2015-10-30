//
// RECQuadernoClient.m
//
// Copyright (c) 2013-2015 Recrea (http://recreahq.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RECQuadernoClient.h"
#import <AFNetworking/AFNetworking.h>

NSString * const RECQuadernoAPIHostname				= @"https://quadernoapp.com/";
NSString * const RECQuadernoAPIEndPointSuffix	= @"/api/v1";

NSString * const RECQuadernoAPIRateLimitKey					= @"X-RateLimit-Limit";
NSString * const RECQuadernoAPIRemainingRequestsKey	= @"X-RateLimit-Remaining";

NSString * const RECQuadernoKitRateLimitKey					= @"limit";
NSString * const RECQuadernoKitRemainingRequestsKey	= @"remaining";


@interface RECQuadernoClient ()

@property (nonatomic, strong, readonly) NSString *authToken;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic) NSUInteger rateLimit;

@property (nonatomic) NSUInteger remainingRequests;

@end


@implementation RECQuadernoClient

- (instancetype)init {
	return [self initWithAuthenticationToken:nil account:nil];
}

- (instancetype)initWithAuthenticationToken:(NSString *)authToken account:(NSString *)account {
	if (!account || account.length == 0) {
		return nil;
	}

	NSString *URLString = [NSString stringWithFormat:@"%@%@%@", RECQuadernoAPIHostname, account, RECQuadernoAPIEndPointSuffix];
	return [self initWithAuthenticationToken:authToken
																	 baseURL:[NSURL URLWithString:URLString]];
}

- (instancetype)initWithAuthenticationToken:(NSString *)authToken baseURL:(NSURL *)baseURL {
	self = [super init];
	if (!self) {
		return nil;
	}

	if (!authToken || authToken.length == 0) {
		return nil;
	}

	if (!baseURL) {
		return nil;
	}

	_baseURL = baseURL;
	_authToken = authToken;
	_sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:_baseURL];

	return self;
}

#pragma mark -

- (void)getConnectionEntitlements:(void (^)(NSDictionary *entitlements, NSError *error))connectionEntitlements {
	[self.sessionManager GET:@"/ping.json" parameters:nil
									 success:^(NSURLSessionDataTask *task, id responseObject) {
										 if (!task) {
											 connectionEntitlements(@{}, nil);
											 return;
										 }

										 if (![task.response isKindOfClass:[NSHTTPURLResponse class]]) {
											 connectionEntitlements(@{}, nil);
											 return;
										 }

										 NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
										 NSDictionary *headers = response.allHeaderFields;
										 if (!headers || headers.count == 0) {
											 connectionEntitlements(@{}, nil);
											 return;
										 }

										 id rateLimit = headers[RECQuadernoAPIRateLimitKey];
										 if (!rateLimit || ![rateLimit isKindOfClass:[NSNumber class]]) {
											 connectionEntitlements(@{}, nil);
											 return;
										 }
										 NSMutableDictionary *entitlementsJSON = [NSMutableDictionary dictionaryWithDictionary:@{RECQuadernoKitRateLimitKey: rateLimit}];
										 self.rateLimit = [rateLimit unsignedIntegerValue];

										 id remainingRequests = headers[RECQuadernoAPIRemainingRequestsKey];
										 if (!remainingRequests || ![remainingRequests isKindOfClass:[NSNumber class]]) {
											 connectionEntitlements([NSDictionary dictionaryWithDictionary:entitlementsJSON], nil);
											 return;
										 }

										 [entitlementsJSON setObject:remainingRequests forKey:RECQuadernoKitRemainingRequestsKey];
										 self.remainingRequests = [remainingRequests unsignedIntegerValue];
										 connectionEntitlements([NSDictionary dictionaryWithDictionary:entitlementsJSON], nil);
									 }
									 failure:^(NSURLSessionDataTask *task, NSError *error) {
										 connectionEntitlements(nil, error);
									 }];
}

@end
