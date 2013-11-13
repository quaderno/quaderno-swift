//
//  RECQuadernoClient.m
//
//  Copyright (c) 2013 Recrea (http://recreahq.com/)
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

NSString * const RECQuadernoKitAPIHostname				= @"https://quadernoapp.com/";
NSString * const RECQuadernoKitAPIEndPointSuffix	= @"/api/v1";


@interface RECQuadernoClient ()

@property (nonatomic, strong, readonly) NSString *authToken;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end


@implementation RECQuadernoClient

- (instancetype)init {
	return [self initWithAuthenticationToken:nil account:nil];
}

- (instancetype)initWithAuthenticationToken:(NSString *)authToken account:(NSString *)account {
	if (!account || account.length == 0) {
		return nil;
	}

	NSString *URLString = [NSString stringWithFormat:@"%@%@%@", RECQuadernoKitAPIHostname, account, RECQuadernoKitAPIEndPointSuffix];
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

- (void)ping:(void (^)(BOOL success))response {
	[self.sessionManager GET:@"/" parameters:nil
									 success:^(NSURLSessionDataTask *task, id responseObject) {
										 response(YES);
									 }
									 failure:^(NSURLSessionDataTask *task, NSError *error) {
										 response(NO);
									 }];
}

@end
