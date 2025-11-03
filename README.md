# Duganator Neovim Config

This is our family Neovim config (yes, really: the wife, the kids, and me). We use Arch BTW.

## Purpose

It's not meant for everyone, but can serve as a source of ideas or a starting point for your own customization. What is the target use case of this config? My day job is writing Elixir. As a family, we are learning Zig and Go. I also manage a handful of Linux servers. We all also have prose and PIM tasks. So, we want a Neovim config that covers all our needs that can run on our mediacenter, servers, workstations, etc. so we can all feel at home any any computer in the house/online. One config to rule them all.

It's not stable or perfectly thought out. Things will change, break and get swapped around as we each grow in our vim knowledge.

> [!WARNING]  
> This config requires `vim.pack`, which is only available in >= `0.12`, (currently unreleased).
>
> I use [bob](https://github.com/MordechaiHadad/bob) to install nightly builds.

## Origin

What I basically did to get here:

- Try out [LazyVim](https://www.lazyvim.org/) for a month or two to get reasonably proficient with Neovim
- Tried out customizing [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- Started over from scratch with a single-file config using the new `vim.pack`
- Slowly iterated based on real-world usage and experience

You may be better served by exploring those options on your own, and don't forget to RTFM!
