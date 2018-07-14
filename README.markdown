# This is a fork of tpope/surround.vim and kana/surround.vim

kana's fork of surround.vim [surround.vim](https://github.com/kana/vim-surround)
adds more customizablility.

I wanted up-to-date version of it and merged with tpope's
[surround.vim](https://github.com/tpope/vim-surround).
I changed nothing. All are thanks to the two great plugins.

Currently, based on version 2.1 (2018-7-15)

## Install

Since plugin name is the same as the originals',  please install this after
you delete originals completely.

## Examples

    call SurroundRegister('g', 'Ra', ">\r<")

adds global two-char-operator to surround text with ">" and "<".
See `:h SurroundRegister` and `:h ftplugin` for per filetype settings.

You can use `for` in your vimrc to add rules like this.

    let s:surroundlist = [
        \ ['g', 'Ra', ">\r<"],
        \ ['g', 'R3a', ">>>\r<<<"],
        \ ['g', 'mk', "「\r」"],
        \ ['g', 'mn', "『\r』"],
        \ ['g', 'mb', "（\r）"],
        \ ['g', 'ms', "【\r】"],]
    for s:surr in s:surroundlist
      call SurroundRegister(s:surr[0], s:surr[1], s:surr[2])
    endfor

If you use Vim8 built-in plugin manager, you need to put `packloadall`
before calling this function. `:h packloadall`.

Original README is here.

# surround.vim

Surround.vim is all about "surroundings": parentheses, brackets, quotes,
XML tags, and more.  The plugin provides mappings to easily delete,
change and add such surroundings in pairs.

It's easiest to explain with examples.  Press `cs"'` inside

    "Hello world!"

to change it to

    'Hello world!'

Now press `cs'<q>` to change it to

    <q>Hello world!</q>

To go full circle, press `cst"` to get

    "Hello world!"

To remove the delimiters entirely, press `ds"`.

    Hello world!

Now with the cursor on "Hello", press `ysiw]` (`iw` is a text object).

    [Hello] world!

Let's make that braces and add some space (use `}` instead of `{` for no
space): `cs]{`

    { Hello } world!

Now wrap the entire line in parentheses with `yssb` or `yss)`.

    ({ Hello } world!)

Revert to the original text: `ds{ds)`

    Hello world!

Emphasize hello: `ysiw<em>`

    <em>Hello</em> world!

Finally, let's try out visual mode. Press a capital V (for linewise
visual mode) followed by `S<p class="important">`.

    <p class="important">
      <em>Hello</em> world!
    </p>

This plugin is very powerful for HTML and XML editing, a niche which
currently seems underfilled in Vim land.  (As opposed to HTML/XML
*inserting*, for which many plugins are available).  Adding, changing,
and removing pairs of tags simultaneously is a breeze.

The `.` command will work with `ds`, `cs`, and `yss` if you install
[repeat.vim](https://github.com/tpope/vim-repeat).

## Installation

Install using your favorite package manager, or use Vim's built-in package
support:

    mkdir -p ~/.vim/pack/tpope/start
    cd ~/.vim/pack/tpope/start
    git clone https://tpope.io/vim/surround.git
    vim -u NONE -c "helptags surround/doc" -c q

## Contributing

See the contribution guidelines for
[pathogen.vim](https://github.com/tpope/vim-pathogen#readme).

## Self-Promotion

Like surround.vim?  Star the repository on
[GitHub](https://github.com/tpope/vim-surround) and vote for it on
[vim.org](https://www.vim.org/scripts/script.php?script_id=1697).

Love surround.vim?  Follow [tpope](http://tpo.pe/) on
[GitHub](https://github.com/tpope) and
[Twitter](http://twitter.com/tpope).

## License

Copyright (c) Tim Pope.  Distributed under the same terms as Vim itself.
See `:help license`.
