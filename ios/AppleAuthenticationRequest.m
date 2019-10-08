// Copyright 2018-present 650 Industries. All rights reserved.

#import "AppleAuthenticationRequest.h"
#import "AppleAuthenticationMappings.h"

@interface AppleAuthenticationRequest ()

@property (nonatomic, strong, nonnull) NSDictionary *options;
@property (nonatomic, strong, nullable) void(^callback)(NSDictionary *, NSError *);
@property (nonatomic, strong, nonnull) ASAuthorizationController *authController;

@end

@implementation AppleAuthenticationRequest

- (instancetype)initWithOptions:(NSDictionary *)options
                    andCallback:(void(^)(NSDictionary *response, NSError *error))callback
{
  if (self = [super init]) {
    _options = options;
    _callback = callback;
  }
  return self;
}

- (void)performOperation:(ASAuthorizationProviderAuthorizationOperation)operation
{
  ASAuthorizationAppleIDProvider* appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
  ASAuthorizationAppleIDRequest* request = [appleIDProvider createRequest];

  NSArray<NSNumber *> *requestedScopes = _options[@"requestedScopes"];

  request.requestedScopes = [AppleAuthenticationMappings importScopes:requestedScopes];
  request.requestedOperation = operation;

  if (_options[@"user"]) {
    request.user = _options[@"user"];
  }
  if (_options[@"state"]) {
    request.state = _options[@"state"];
  }

  _authController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
  _authController.presentationContextProvider = self;
  _authController.delegate = self;

  [_authController performRequests];
}

+ (AppleAuthenticationRequest *)performOperation:(ASAuthorizationProviderAuthorizationOperation)operation
                                       withOptions:(NSDictionary *)options
                                      withCallback:(void(^)(NSDictionary *, NSError *))callback
{
  AppleAuthenticationRequest *authRequest = [[AppleAuthenticationRequest alloc] initWithOptions:options andCallback:callback];
  [authRequest performOperation:operation];
  return authRequest;
}

#pragma mark - ASAuthorizationControllerDelegate

- (void)authorizationController:(ASAuthorizationController *)controller
   didCompleteWithAuthorization:(ASAuthorization *)authorization
{
  ASAuthorizationAppleIDCredential *credential = authorization.credential;

  NSDictionary *fullName;
  if (credential.fullName) {
    fullName = [AppleAuthenticationMappings exportFullName:credential.fullName];
  }
  NSString *authorizationCode;
  if (credential.authorizationCode) {
    authorizationCode = [AppleAuthenticationMappings exportData:credential.authorizationCode];
  }
  NSString *identityToken;
  if (credential.identityToken) {
    identityToken = [AppleAuthenticationMappings exportData:credential.identityToken];
  }

  NSDictionary *response = @{
      @"fullName": fullName ? fullName : @"",
                         @"email": credential.email ? credential.email: @"",
                         @"user": credential.user,
                         @"realUserStatus": [AppleAuthenticationMappings exportRealUserStatus:credential.realUserStatus],
      @"state": credential.state ? credential.state : @"",
      @"authorizationCode": authorizationCode ? authorizationCode : @"",
      @"identityToken": identityToken ? identityToken : @"",
                         };

  if (_callback) {
    _callback(response, nil);
    _callback = nil;
  }
}

- (void)authorizationController:(ASAuthorizationController *)controller
           didCompleteWithError:(NSError *)error
{
  if (_callback) {
    _callback(nil, error);
    _callback = nil;
  }
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding

- (nonnull ASPresentationAnchor)presentationAnchorForAuthorizationController:(nonnull ASAuthorizationController *)controller
{
  return [[UIApplication sharedApplication] keyWindow];
}

@end
