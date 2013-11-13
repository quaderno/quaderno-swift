//
//  RECQuadernoClientTest.m
//
// Copyright (c) 2013 Recrea (http://recreahq.com)
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

#import "RECTestCase.h"
#import "RECQuadernoClient.h"
#import <AFHTTPSessionManager.h>

NSString * const RECQuadernoKitTestHost			= @"https://quadernoapp-com-d81137w3z9n1.eu1.runscope.net/";
NSString * const RECQuadernoKitTestAccount	= @"quadernokit";
NSString * const RECQuadernoKitTestToken		= @"c76712e5-a79e-4453-8a9b-7669fbd4e086";

/**
 *  Reopen class to test private properties
 */
@interface RECQuadernoClient ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end


@interface RECQuadernoClientTest : RECTestCase
@end

@implementation RECQuadernoClientTest

- (RECQuadernoClient *)quadernoClient {
	static dispatch_once_t pred;
  static RECQuadernoClient *sharedInstance = nil;

  dispatch_once(&pred, ^{
		sharedInstance = [[RECQuadernoClient alloc] initWithAuthenticationToken:RECQuadernoKitTestToken
																																		baseURL:[NSURL URLWithString:RECQuadernoKitTestHost]];
	});
  return sharedInstance;
}

#pragma mark -

- (void)testThatDesignatedInitializerBuildsDefaultBaseURL {
	RECQuadernoClient *client = [[RECQuadernoClient alloc] initWithAuthenticationToken:RECQuadernoKitTestToken account:RECQuadernoKitTestAccount];

	NSString *expectedURLString = [NSString stringWithFormat:@"%@%@%@", @"https://quadernoapp.com/", RECQuadernoKitTestAccount, @"/api/v1"];
	NSURL *expectedURL = [NSURL URLWithString:expectedURLString];
	expect(client.baseURL).to.equal(expectedURL);
}

- (void)testThatDesignatedInitializerBuildsCustomBaseURL {
	NSURL *customBaseURL = [NSURL URLWithString:@"http://example.com/"];
	RECQuadernoClient *client = [[RECQuadernoClient alloc] initWithAuthenticationToken:RECQuadernoKitTestToken baseURL:customBaseURL];
	expect(client.baseURL).to.equal(customBaseURL);
}

- (void)testThatDesignatedInitializerReturnsNilIfAuthenticationTokenIsMissing {
	RECQuadernoClient *client = [[RECQuadernoClient alloc] initWithAuthenticationToken:nil account:RECQuadernoKitTestAccount];
	expect(client).to.beNil;
}

- (void)testThatDesignatedInitializerReturnsNilIfAccountIsMissing {
	RECQuadernoClient *client = [[RECQuadernoClient alloc] initWithAuthenticationToken:RECQuadernoKitTestToken account:nil];
	expect(client).to.beNil;
}

- (void)testThatDesignatedInitializerReturnsNilIfCustomBaseURLIsMissing {
	RECQuadernoClient *client = [[RECQuadernoClient alloc] initWithAuthenticationToken:RECQuadernoKitTestToken baseURL:nil];
	expect(client).to.beNil;
}

#pragma mark -

- (void)testThatPingInvokesSessionManager {
	id mockSessionManager = [OCMockObject mockForClass:[AFHTTPSessionManager class]];
	self.quadernoClient.sessionManager = mockSessionManager;

	[[mockSessionManager expect] GET:OCMOCK_ANY parameters:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
	[self.quadernoClient ping:nil];
	[mockSessionManager verify];
}

- (void)testThatPingSetsBlockArgumentWhenRequestSuccess {
	id mockSessionManager = [OCMockObject mockForClass:[AFHTTPSessionManager class]];

	[[mockSessionManager expect] GET:OCMOCK_ANY
												parameters:nil
													 success:[OCMArg checkWithBlock:^BOOL(void (^successBlock)(NSURLSessionTask *, id)) {
		successBlock(nil, [NSString stringWithCString:__FUNCTION__ encoding:NSUTF8StringEncoding]);
		return YES;
	}]
													 failure:OCMOCK_ANY];
	self.quadernoClient.sessionManager = mockSessionManager;


	__block NSNumber *blockSuccess = nil;
	[self.quadernoClient ping:^(BOOL success) {
		blockSuccess = [NSNumber numberWithBool:success];
	}];

	expect(blockSuccess).will.equal(@YES);
}

- (void)testThatPingSetsBlockArgumentWhenRequestFails {
	id mockSessionManager = [OCMockObject mockForClass:[AFHTTPSessionManager class]];

	[[mockSessionManager expect] GET:OCMOCK_ANY
												parameters:nil
													 success:OCMOCK_ANY
													 failure:[OCMArg checkWithBlock:^BOOL(void (^failureBlock)(NSURLSessionTask *, NSError *)) {
		failureBlock(nil, [NSError errorWithDomain:OCMOCK_ANY code:400 userInfo:OCMOCK_ANY]);
		return YES;
	}]];
	self.quadernoClient.sessionManager = mockSessionManager;


	__block NSNumber *blockSuccess = nil;
	[self.quadernoClient ping:^(BOOL success) {
		blockSuccess = [NSNumber numberWithBool:success];
	}];

	expect(blockSuccess).will.equal(@NO);
}

@end
