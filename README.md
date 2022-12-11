# GNU stow

You need **git**, and **stow**

```
stow -nvt ~
```
<details><summary>A letter for myself ARCHIVE</summary>
<p>

# A letter to myself in the future 3

Thanks @numToStr for information that his dotfiles managed by GNU stow, that made me think what GNU stow is...and now I can configure my programs very easily...the nex step I need to understand how can I install all my programs in one time and do I need it?

# A letter to myself in the future 2

Ok, finally, you install `Arch` and I forgot to `push` my previous changes...
One more problem is when you `install kitty` and etc, you create a dir in **.config**, so when you create semilinks they appears in created folder, and don't work properly. Now I think I can add `rm -frd <path>` and then create a semilink to this `<path>`. Also, I add a packer installer link.

# A letter to myself in the future

It's great that I start doing all this stuff, but listen I'm not good at scripts and now `2022-09-10` I don't know how to do this...

### You really wanted to use Sway due to Wayland

Yeah, you ... I mean "I" wanted to use it, because I've heard that the Wayland is great.
So, first of all, you install the latest Ubuntu, then change Nvidia drivers, because it's unsupported, and then `sudo apt install sway`. You've found a funny way how to check if the Wayland is works. `Alt+F2` and then `r`.

```
    Install Ubuntu
    Check if Wayland is working
        You can use opensource drivers for Nvidia
    sudo apt install sway
```

### In Sway you use `kitty`, `nvim`

You tried so hard to understand how to customize all that stuff, and you managed it. Install `kitty`, `nvim`, and then run script to create semilinks.
By the way you use `zsh`.

```
    install kitty
    install zsh and oh-my-zsh
    install nvim
    run install.sh
```
### Finally

And that's it. That how you've installed your enviroment, I hope future you will make something more elegant.

</p>
</details>
