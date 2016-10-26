# wercker step install-terraform

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