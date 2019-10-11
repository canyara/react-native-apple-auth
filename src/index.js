import { NativeEventEmitter, NativeModules } from "react-native";
const { AppleAuth } = NativeModules;

import {
  AppleAuthenticationSignInOptions,
  AppleAuthenticationRefreshOptions,
  AppleAuthenticationSignOutOptions,
  AppleAuthenticationCredential,
  AppleAuthenticationCredentialState,
  AppleAuthenticationOperation,
  AppleAuthenticationRevokeListener
} from "./AppleAuthentication.types";

export async function isAvailableAsync(): Promise<boolean> {
  if (!AppleAuth || !AppleAuth.isAvailableAsync) {
    return false;
  }
  return AppleAuth.isAvailableAsync();
}

export async function signInAsync(
  options?: AppleAuthenticationSignInOptions
): Promise<AppleAuthenticationCredential> {
  if (!AppleAuth || !AppleAuth.requestAsync) {
    throw new UnavailabilityError("expo-apple-authentication", "signInAsync");
  }
  const requestOptions = {
    ...options,
    requestedOperation: AppleAuthenticationOperation.LOGIN
  };
  const credential = await AppleAuth.requestAsync(requestOptions);
  if (
    !credential.authorizationCode ||
    !credential.identityToken ||
    !credential.user
  ) {
    throw new CodedError(
      "ERR_APPLE_AUTHENTICATION_REQUEST_FAILED",
      "The credential returned by `signInAsync` is missing one or more required fields."
    );
  }
  return credential;
}

export async function refreshAsync(
  options: AppleAuthenticationRefreshOptions
): Promise<AppleAuthenticationCredential> {
  if (!AppleAuth || !AppleAuth.requestAsync) {
    throw new UnavailabilityError("expo-apple-authentication", "refreshAsync");
  }
  const requestOptions = {
    ...options,
    requestedOperation: AppleAuthenticationOperation.REFRESH
  };
  const credential = await AppleAuth.requestAsync(requestOptions);
  if (
    !credential.authorizationCode ||
    !credential.identityToken ||
    !credential.user
  ) {
    throw new CodedError(
      "ERR_APPLE_AUTHENTICATION_REQUEST_FAILED",
      "The credential returned by `refreshAsync` is missing one or more required fields."
    );
  }
  return credential;
}

export async function signOutAsync(
  options: AppleAuthenticationSignOutOptions
): Promise<AppleAuthenticationCredential> {
  if (!AppleAuth || !AppleAuth.requestAsync) {
    throw new UnavailabilityError("expo-apple-authentication", "signOutAsync");
  }
  const requestOptions = {
    ...options,
    requestedOperation: AppleAuthenticationOperation.LOGOUT
  };
  return AppleAuth.requestAsync(requestOptions);
}

export async function getCredentialStateAsync(
  user: string
): Promise<AppleAuthenticationCredentialState> {
  if (!AppleAuth || !AppleAuth.getCredentialStateAsync) {
    throw new UnavailabilityError(
      "expo-apple-authentication",
      "getCredentialStateAsync"
    );
  }
  return AppleAuth.getCredentialStateAsync(user);
}

const AppleAuthenticationEventEmitter = new NativeEventEmitter(AppleAuth);

export function addRevokeListener(
  listener: AppleAuthenticationRevokeListener
): Subscription {
  return AppleAuthenticationEventEmitter.addListener(
    "AppleAuth.appleIdCredentialRevoked",
    listener
  );
}
