@import AuthenticationServices;

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(13.0))

@interface AppleAuthenticationRequest : NSObject <ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

- (instancetype)initWithOptions:(NSDictionary *)options
                    andCallback:(void(^)(NSDictionary *response, NSError *error))callback;

- (void)performOperation:(ASAuthorizationProviderAuthorizationOperation)operation;

+ (AppleAuthenticationRequest *)performOperation:(ASAuthorizationProviderAuthorizationOperation)operation
                                       withOptions:(NSDictionary *)options
                                      withCallback:(void(^)(NSDictionary *, NSError *))callback;

@end

NS_ASSUME_NONNULL_END
