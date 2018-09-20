# Releasing

- `make test` to test gem
- `git commit -a` to commit outstanding changes
- `git tag -s x.y.z -m 'Release x.y.z'` to create release tag
- `git push && git push --tags` to push changes
- `make publish` to release gem
