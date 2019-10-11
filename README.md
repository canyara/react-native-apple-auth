# react-native-apple-auth

based on [`expo-apple-authentication`](https://github.com/expo/expo/tree/master/packages/expo-apple-authentication)

## Getting started

`$ yarn add git+https://github.com/canyara/react-native-apple-auth.git`

### Mostly automatic installation

`$ react-native link react-native-apple-auth`

### Manual installation

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-apple-auth` and add `AppleAuth.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libAppleAuth.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

## Usage

use as `expo-apple-authentication`

```javascript
import AppleAuth from "react-native-apple-auth";

AppleAuth.isAvailableAsync();
AppleAuth.signInAsync(options);
AppleAuth.getCredentialStateAsync(user);
```
