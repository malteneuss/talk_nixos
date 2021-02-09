---
author: Malte Neuss
title: NixOS
---

## NixOS 
> "Reproducible builds and deployments."

![](img/nix-logo.svg){ width=40% }

<small style="font-size: 9pt">
By Tim Cuthbertson CC BY 4.0, https://nixos.org
</small>

::: notes
used by Mozilla for Firefox, Target, Atlassian for Marketplace, Klarna
:::

## Content 
:::::::::::::: columns
::: {.column width="50%"}
![](img/nix-logo.svg){ width=60% }

:::
::: {.column width="50%"}
**Nix**

* Package Manager
* Language
* OS
:::
::::::::::::::


::: notes
manager installable on windows, mac, linux
several copies of app in different versions
deployable like Ansible, Terraform
about as many packages as Arch Linux AUR

Nix lang = Json + functions
reproducible development environments =>faster onboarding
switching between projects is easy, effortless, fast
containerizsable into docker
:::

## Nix Package Manager

* Adhoc environments
  ```nix
  $ nix-shell --packages jdk
  ```
* Reproducible environments
  ```nix
  mkDerivation {
    name = "myProject-1.0.0";
    src = ./src; 
    buildInputs = [ maven jdk ...];
  }
  ```

::: notes
* \>60k packages
* many ecosystems\
Java, JS, Python, Rust, Haskell...
* reproducible
:::

## Demo
::: notes
Demo show nix shell 
nix-shell --packages cowsay --run "cowsay hi"
- jupyter notebook env
nix-shell --packages 'python3.withPackages(ps: with ps; [ numpy scipy matplotlib notebook scikitlearn scipy nltk spacy])'
- Find Nix Store Path of app
readlink -f $(which java)
:::

## Nix Language
![](img/xkcd-standards.png){ width=60% }

<small style="font-size: 9pt">
By https://xkcd.com/927/ CC BY-NC 2.5
</small>


## Nix Language
**Derivation**
```nix
{
  "/nix/store/dvmidxj5...-myProject-1.0.0.drv": {
    "outputs": {
      "out": {
        "path": "/nix/store/w9yy7v...-myProject-1.0.0"
      }
    },
    "inputSrcs": [
      "/nix/store/9krlzvn...-default-builder.sh"
    ],
    "inputDrvs": {
      "/nix/store/1psqjc0l1..-bash-4.4-p23.drv": [
        "out"
      ],
      "/nix/store/8fbvqyxl9y...-myProject-1.0.0.tar.gz.drv": [
        "out"
      ],
      "/nix/store/m15naxf2...-stdenv-linux.drv": [
        "out"
      ]
    },
    "platform": "x86_64-linux",
    "builder": "/nix/store/2jysm...-bash-4.4-p23/bin/bash",
    "args": [
      "-e",
      "/nix/store/9krlzvny65g...-default-builder.sh"
    ],
    "env": {
      "buildInputs": "",
      "builder": "/nix/store/2jysm...-bash-4.4-p23/bin/bash",
      "configureFlags": "",
      "depsBuildBuild": "",
      "depsBuildBuildPropagated": "",
      "depsBuildTarget": "",
      "depsBuildTargetPropagated": "",
      "depsHostHost": "",
      "depsHostHostPropagated": "",
      "depsTargetTarget": "",
      "depsTargetTargetPropagated": "",
      "doCheck": "1",
      "doInstallCheck": "",
      "name": "myProject-1.0.0",
      "nativeBuildInputs": "",
      "out": "/nix/store/w9yy7v6...-myProject-1.0.0",
      "outputs": "out",
      "patches": "",
      "pname": "myProject",
      "propagatedBuildInputs": "",
      "propagatedNativeBuildInputs": "",
      "src": "/nix/store/3x7dwzq01...-myProject-1.0.0.tar.gz",
      "stdenv": "/nix/store/333six1f...-stdenv-linux",
      "strictDeps": "",
      "system": "x86_64-linux",
      "version": "1.0.0"
    }
  }
}
```

## Nix Language
:::::::::::::: columns
::: {.column width="50%"}
**≈Json + Functions**
```nix
mkDerivation {
  name = "myProject-1.0.0";
  src = ./src; 
  buildInputs = [ maven jdk ];
}
```
:::
::: {.column width="50%"}
**Benefits**

* Declarative
* Functional
* Pure


:::
::::::::::::::

## Nix Language
**Pure, Functional, Lazy**

* Strings `"hello"`{.nix}
* Numbers `42`{.nix}
* List    `[1 2 3]`{.nix}
* Expressions `1+2+3`{.nix}

* Attribute Sets `{ }`{.nix}
* Functions `f x`{.nix}

::: notes
pure = no side effects, no variables = declarative
functional = first-class support 
lazy = expression is not evaluated until value is needed
* Let-Expressions
* Pattern-Matching
not-general purpose language
dynamically types = no type signatures/compile time
:::

## Attribute Set
```nix
{
  name = "myProject-1.0.0";
  src = ./src; 
  buildInputs = [ maven jdk ];
  ...
}
```
Assignment:
```nix
myNumber   = 3;
myAttrSet  = { name = "myProject-1.0.0"; src = ... }
myString   = myAttrSet.name;
myFunction = x: 2*x;
```

::: notes
adhoc variable declaration
think like const myDerivation
:::

## Functions
:::::::::::::: columns
::: {.column width="50%"}

**Typescript**
```typescript
const f = x => 2x
f(3)
```

:::
::: {.column width="50%"}
**Nix**
```nix
f = x: 2*x        # definition
f 3               # usage
```

:::
::::::::::::::

::: notes
**Math**
```
f: ℝ ⟶ ℝ
f: x ↦ 2x
```
:::

## Functions
:::::::::::::: columns
::: {.column width="50%"}

**Typescript**
```typescript
const g = (x,y) => x+y
g(3,4)
```

:::
::: {.column width="50%"}
**Nix**
```nix
g = x: y: x+y
g 3 4
```

:::
::::::::::::::

## Functions
**Currying**
```
g: (ℝ,ℝ) ⟶ ℝ                      g: ℝ ⟶ (ℝ ⟶ ℝ)
g: (x,y) ↦ x+y                    g: x ↦ (y ↦ x+y)
```
**Usage**
```
g (3,4)                           g 3 4
```

## Functions
```nix
mkDerivation {
  name = "myProject-1.0.0";
  src = ./src; 
  ..
}
```

**Resulting Derivation**
```nix
{
  "/nix/store/dvmig8jgrdapvbyxb1rprckdmdqx08kv-myProject-1.0.0.drv": {
    "outputs": {
      "out": {
        "path": "/nix/store/w9yy7v61ipb5rx6i35zq1mvc2iqfmps1-myProject-1.0.0"
      }
    },
    "inputSrcs": [
      "/nix/store/9krlzvny65gdc8s7kpb6lkx8cd02c25b-default-builder.sh"
    ],
    "inputDrvs": {
      "/nix/store/1psqjc0l1vmjsjy4ha5ywbv1l0993cka-bash-4.4-p23.drv": [
        "out"
      ],
      "/nix/store/8fbvqyxl9y0savd7lsrfbq9d8qpfbh7b-myProject-1.0.0.tar.gz.drv": [
        "out"
      ],
      "/nix/store/m15naxf285zafnsnlzfaxy0r10dzlanx-stdenv-linux.drv": [
        "out"
      ]
    },
    "platform": "x86_64-linux",
    "builder": "/nix/store/2jysm3dfsgby5sw5jgj43qjrb5v79ms9-bash-4.4-p23/bin/bash",
    "args": [
      "-e",
      "/nix/store/9krlzvny65gdc8s7kpb6lkx8cd02c25b-default-builder.sh"
    ],
    "env": {
      "buildInputs": "",
      "builder": "/nix/store/2jysm3dfsgby5sw5jgj43qjrb5v79ms9-bash-4.4-p23/bin/bash",
      "configureFlags": "",
      "depsBuildBuild": "",
      "depsBuildBuildPropagated": "",
      "depsBuildTarget": "",
      "depsBuildTargetPropagated": "",
      "depsHostHost": "",
      "depsHostHostPropagated": "",
      "depsTargetTarget": "",
      "depsTargetTargetPropagated": "",
      "doCheck": "1",
      "doInstallCheck": "",
      "name": "myProject-1.0.0",
      "nativeBuildInputs": "",
      "out": "/nix/store/w9yy7v61ipb5rx6i35zq1mvc2iqfmps1-myProject-1.0.0",
      "outputs": "out",
      "patches": "",
      "pname": "myProject",
      "propagatedBuildInputs": "",
      "propagatedNativeBuildInputs": "",
      "src": "/nix/store/3x7dwzq014bblazs7kq20p9hyzz0qh8g-myProject-1.0.0.tar.gz",
      "stdenv": "/nix/store/333six1faw9bhccsx9qw5718k6b1wiq2-stdenv-linux",
      "strictDeps": "",
      "system": "x86_64-linux",
      "version": "1.0.0"
    }
  }
}
```

::: notes
nix show-derivation nixpkgs.hello
functions allow shorter code (code reuse) and strong customization
:::

## Derivation
```nix
# shell.nix
let 
 pkgs = import <nixpkgs> {}; 
in
pkgs.stdenv.mkDerivation {
  name = "myProject-1.0.0";
  src = ./src; 
  buildInputs = [ pkgs.maven pkgs.jdk ];
  buildPhase = "maven clean build";
}
```


::: notes
:::

## Nixpkgs
`(import <nixpkgs> {})`{.nix} evaluates to:
```nix
{
  stdenv = { .. }
  ...
  maven = stdenv.mkDerivation {... jdk ...}
  jdk = ..
  jdk11 = ..
  ...
  git = ....
  ...
  firefox = ...
  ...
}
```

<small style="font-size: 9pt">
https://github.com/NixOS/nixpkgs
</small>

::: notes
huge package set
ca 1.5GB
quite fast because lazy and mkDerivation functions aren't called if not used
:::

## Search Packages
![](img/nixos-search.png){ width=70% }
https://search.nixos.org



## Reproducible Builds
```nix
$ nix-build shell.nix   # build artifact, put into store
```
**Store**
```bash
/nix/store/9234jfkdfj23j45r2102jfd-myProject-1.0.0
/nix/store/34234sdfjskdfj32j4kjdsf-maven-3.0.0
/nix/store/sdf34dfkjlkj09u123123ss-maven-3.0.0
..
/nix/store/fsdkf234jdfdsfjkj0111df-jdk-1.8.0
..
```
```nix
$ nix-shell shell.nix    # load environment with buildInputs
```

## Demo
::: notes
demo switching between two environments
- Find Nix Store Path of app
readlink -f $(which java)
docker https://nixos.org/guides/building-and-running-docker-images.html
:::

## NixOS
```nix

{
  ..
  boot.loader.grub.device = "/dev/sda";
  boot.kernelPackages = pkgs.linuxPackages_latest; 
  ..
  
  users.users.mneuss = {
    isNormalUser = true;
    home = "/home/mneuss";
    extraGroups = [ 
      "wheel" # Enable ‘sudo’ for the user.
      "docker"
      "network-manager" ]; 
  };

  # install packages
  environment.systemPackages = with pkgs; [
    jetbrains.idea-ultimate
    vscode
    git
    maven
    jdk11
  ];
  programs.bash.enableCompletion = true;
  
  sound.enable = true;

  # Desktop
  services.xserver.enable = true; 
  services.xserver.layout = "us"; 
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  # Network
  networking.firewall.allowedTCPPorts = [ 80 ];
  networking.firewall.firewall.enable = true;
  networking.hostName = "laptop"; 
  networking.networkmanager.enable = true;


  system.stateVersion = "20.09";
  ...
}
```

```
nixos-rebuild switch
```

::: notes
**Declarative Linux operating system**
atomic new generation installation
atomic rollback
:::

## Further Study

![](img/nix-logo.svg){ width=10% }

:::::::::::::: columns
::: {.column width="50%"}
* **Main Page** https://nixos.org/
* **Cloud Deployment** https://github.com/NixOS/nixops
:::
::: {.column width="50%"}

* **My Blog** https://lambdablob.com/
* **Switch Dev Environments** https://direnv.net/

:::
::::::::::::::

