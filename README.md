<div align="center">

# asdf-gitleaks [![Build](https://github.com/jmcvetta/asdf-gitleaks/actions/workflows/build.yml/badge.svg)](https://github.com/jmcvetta/asdf-gitleaks/actions/workflows/build.yml) [![Lint](https://github.com/jmcvetta/asdf-gitleaks/actions/workflows/lint.yml/badge.svg)](https://github.com/jmcvetta/asdf-gitleaks/actions/workflows/lint.yml)


[Gitleaks](https://github.com/zricethezav/gitleaks) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add gitleaks
# or
asdf plugin add gitleaks https://github.com/jmcvetta/asdf-gitleaks.git
```

gitleaks:

```shell
# Show all installable versions
asdf list-all gitleaks

# Install specific version
asdf install gitleaks latest

# Set a version globally (on your ~/.tool-versions file)
asdf global gitleaks latest

# Now gitleaks commands are available
gitleaks --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/jmcvetta/asdf-gitleaks/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Jason McVetta](https://github.com/jmcvetta/)
