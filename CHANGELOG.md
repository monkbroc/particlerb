# Changelog

## 2.1.0 (August 3, 2019)

- Add support for listing, adding and removing product devices. Thanks @Talha5 [PR #9](https://github.com/monkbroc/particlerb/pull/9)
- Fix broken API response for product details. Thanks @TyGuy [PR #11](https://github.com/monkbroc/particlerb/pull/11)

## 2.0.1 (November 28, 2018)

- Update version of Faraday. Thanks @Talha5 [PR #8](https://github.com/monkbroc/particlerb/pull/8)

## 2.0.0 (June 3, 2018)

- Add partial support for products. Thanks @TyGuy! [PR #7](https://github.com/monkbroc/particlerb/pull/7) 
- BREAKING CHANGE: `device.product` now returns a Product object instead of a string. Use `device.platform_name` for old behavior.
- Fix `webhook.remove`. Thanks @gemfarmer! [PR #6](https://github.com/monkbroc/particlerb/pull/6)

## 1.4.0 (September 11, 2017)

- Support OAuth client for login
- Add OAuth clients

## 1.3.1 (January 26, 2017)

- Send the device ID in the url of the provisioning endpoint

## 1.3.0 (November 8, 2016)

- Add device provisioning endpoint
- Add simple_message to errors

## 1.2.0 (October 18, 2016)

- Add platforms
- Add build targets
- Add update public key
- Pin listen gem version to maintain compatibility with older rubies

## 1.1.0 (July 21, 2015)

Relax faraday_middleware version dependency.

## 1.0.0 (July 15, 2015)

First stable version of the Particle Ruby client.

- Supports devices, events, webhooks, compiling and authentication
