# Repos with .dotfiles and co

## tips 
Generating zsh completions:

```sh
mkdir $ZSH/completions/
CMD="<cmd>" $CMD completion zsh > $zsh/completion/_$CMD
```

Fast ssh-keygen:


```sh
ssh-keygen -t rsa -N ""  -f ~/.ssh/<filename>
```

Use ssh key in git:

```sh
git config [--local|--global] core.sshCommand 'ssh -i ~/.ssh/<filename>'
```

Restore plugins from lazy:

from vim cmd:
```
:Lazy restore
```

