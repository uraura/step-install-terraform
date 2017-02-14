# install-terraform

[![wercker status](https://app.wercker.com/status/2e0b839be1100258dd06c1bd67f73715/s/master "wercker status")](https://app.wercker.com/project/bykey/2e0b839be1100258dd06c1bd67f73715)

A wercker step for install [Terraform](https://www.terraform.io/).

**install location**

- /usr/local/src or `$WERCKER_CACHE_DIR`/usr/local/src

## Options

- `version`(required) set terraform version
- `use-cache` (optional, default:true) install to `WERCKER_CACHE_DIR`

## Example

```yaml
build:
  steps:
    - jyotti/install-terraform:
      version: 0.7.7
```