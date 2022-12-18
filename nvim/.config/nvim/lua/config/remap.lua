local kmp = vim.keymap

vim.g.mapleader = " "

kmp.set("n", "<C-d>", "<C-d>zz")
kmp.set("n", "<C-u>", "<C-u>zz")
kmp.set("n", "n", "nzzzv")
kmp.set("n", "N", "Nzzzv")
