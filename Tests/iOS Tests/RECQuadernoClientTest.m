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

NSString * const RECQuadernoKitTestHost			= @"https://test.quadernoapp.com/";
NSString * const RECQuadernoKitTestAccount	= @"quadernokit";
NSString * const RECQuadernoKitTestToken		= @"c76712e5-a79e-4453-8a9b-7669fbd4e086";


@interface RECQuadernoClientTest : RECTestCase
@end

@implementation RECQuadernoClientTest

- (RECQuadernoClient *)quadernoClient {
	static dispatch_once_t pred;
  static RECQuadernoClient *sharedInstance = nil;

  dispatch_once(&pred, ^{
		sharedInstance = [[RECQuadernoClient alloc] initWithAuthenticationToken:RECQuadernoKitTestToken account:RECQuadernoKitTestAccount];
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

@end
